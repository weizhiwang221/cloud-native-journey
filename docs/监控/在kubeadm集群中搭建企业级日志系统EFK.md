# 在kubeadm集群中搭建企业级日志系统EFK


1. 确认集群正常：

```
kubectl cluster-info
kubectl get nodes -o wide
```

1. 由于你是 **单节点集群**，默认 `control-plane` 节点有污点，Pod 不会调度到它。可以选择：

   - **方法A（推荐）：** 在后面 YAML 里都加上 tolerations。

   - **方法B：** 直接移除污点：

     ```
     kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
     ```

2. 检查有没有默认的 **StorageClass**（后面 Elasticsearch 要用PVC存储数据）：

```
kubectl get sc
```

- 如果没有，可以快速装一个轻量的本地存储：

  ```
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
  kubectl annotate sc local-path storageclass.kubernetes.io/is-default-class="true"
  ```

------

要不要我帮你先写一个 **创建命名空间 efk** 的 YAML 和命令？这样我们从这里开始，一步步往下搭建。

### 1️⃣ 创建命名空间 efk

你可以直接执行命令：

```
kubectl create namespace efk
```

### 1️⃣ 创建命名空间 efk

你可以直接执行命令：

```
kubectl create namespace efk
```

或者写成一个 YAML 清单（建议用这种方式，方便版本管理）：

```
# efk-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: efk
```

执行：

```
kubectl apply -f efk-namespace.yaml
```

然后验证：

```
kubectl get ns
```

------

👉 下一步我们要处理 **Elasticsearch 的前置内核参数 vm.max_map_count**（否则启动会报错）。
 要不要我先帮你写一个 **DaemonSet 来设置 vm.max_map_count**？

### 2️⃣ 创建 DaemonSet 设置内核参数

新建文件 **`efk-sysctl.yaml`**：

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: efk-sysctl
  namespace: efk
spec:
  selector:
    matchLabels:
      app: efk-sysctl
  template:
    metadata:
      labels:
        app: efk-sysctl
    spec:
      hostPID: true
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
      containers:
        - name: sysctl
          image: busybox:1.36
          securityContext:
            privileged: true
          command: ["sh", "-c"]
          args:
            - |
              sysctl -w vm.max_map_count=262144
              sysctl -w fs.file-max=1048576
              # 容器保持存活
              sleep 3600000
```

应用：

```
kubectl apply -f efk-sysctl.yaml
```

检查是否运行成功：

```
kubectl -n efk get pods -o wide
```

登录节点确认参数已生效：

```
sysctl -n vm.max_map_count
```

正常的话应该输出：`262144`

### 3️⃣ 部署 Elasticsearch（单节点）

新建文件 **`elasticsearch-single.yaml`**：

```
apiVersion: v1
kind: Service
metadata:
  name: elasticsearch
  namespace: efk
  labels:
    app: elasticsearch
spec:
  ports:
    - name: http
      port: 9200
      targetPort: 9200
  selector:
    app: elasticsearch
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: efk
spec:
  serviceName: elasticsearch
  replicas: 1
  selector:
    matchLabels:
      app: elasticsearch
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
      containers:
        - name: es
          image: docker.io/elasticsearch:8.14.1
          ports:
            - containerPort: 9200
              name: http
            - containerPort: 9300
              name: transport
          env:
            - name: discovery.type
              value: single-node
            - name: ES_JAVA_OPTS
              value: "-Xms512m -Xmx512m"
            - name: xpack.security.enabled
              value: "false"   # 单机测试关闭安全认证
          volumeMounts:
            - name: es-data
              mountPath: /usr/share/elasticsearch/data
          resources:
            requests:
              cpu: "250m"
              memory: "1Gi"
            limits:
              cpu: "1"
              memory: "2Gi"
  volumeClaimTemplates:
    - metadata:
        name: es-data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: "local-path"  # 如果你用了 local-path-provisioner
        resources:
          requests:
            storage: 20Gi
```

应用：

```
kubectl apply -f elasticsearch-single.yaml
```

等待启动完成：

```
kubectl -n efk rollout status sts/elasticsearch
```

检查 Pod：

```
kubectl -n efk get pods -o wide
```

测试访问：

```
kubectl -n efk port-forward svc/elasticsearch 9200:9200 &
curl http://127.0.0.1:9200
```

正常的话会返回 Elasticsearch 的 JSON 信息。

###### ChatGPT 说：

好的 👍 我们继续来部署 **Kibana**，它是 Elasticsearch 的可视化界面。

### 4️⃣ 部署 Kibana

新建文件 **`kibana.yaml`**：

```
apiVersion: v1
kind: Service
metadata:
  name: kibana
  namespace: efk
  labels:
    app: kibana
spec:
  type: NodePort   # 单节点集群，方便外部访问
  ports:
    - name: http
      port: 5601
      targetPort: 5601
      nodePort: 30601   # 访问端口，可自行修改
  selector:
    app: kibana
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: efk
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kibana
  template:
    metadata:
      labels:
        app: kibana
    spec:
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
      containers:
        - name: kibana
          image: docker.io/kibana:8.14.1
          ports:
            - containerPort: 5601
          env:
            - name: ELASTICSEARCH_HOSTS
              value: "[\"http://elasticsearch.efk.svc:9200\"]"
            - name: NODE_OPTIONS
              value: "--max-old-space-size=2048"
          resources:
            requests:
              cpu: "100m"
              memory: "256Mi"
            limits:
              cpu: "500m"
              memory: "512Mi"
```

应用：

```
kubectl apply -f kibana.yaml
```

等待启动：

```
kubectl -n efk rollout status deploy/kibana
```

检查 Pod：

```
kubectl -n efk get pods -o wide
```

然后访问：

```
http://<你的节点IP>:30601
```

就能看到 Kibana 界面啦 🎉

------

✅ Kibana 已经搭建好了。

### 5️⃣ 部署 Fluent Bit

#### 5.1 创建 RBAC

新建文件 **`fluent-bit-rbac.yaml`**：

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: fluent-bit
  namespace: efk
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: fluent-bit-read
rules:
  - apiGroups: [""]
    resources: ["pods", "namespaces"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: fluent-bit-read
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: fluent-bit-read
subjects:
  - kind: ServiceAccount
    name: fluent-bit
    namespace: efk
```

应用：

```
kubectl apply -f fluent-bit-rbac.yaml
```

------

#### 5.2 创建 ConfigMap

新建文件 **`fluent-bit-config.yaml`**：

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  namespace: efk
data:
  fluent-bit.conf: |
    [SERVICE]
        Flush        5
        Daemon       Off
        Log_Level    debug
        Parsers_File parsers.conf

    [INPUT]
        Name              tail
        Path              /var/log/containers/*.log
        Exclude_Path      /var/log/containers/*_fluent-bit-*
        Tag               kube.*
        Mem_Buf_Limit     50MB
        Skip_Long_Lines   On
        Refresh_Interval  5
        Parser            docker

    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL            https://kubernetes.default.svc:443
        Kube_Tag_Prefix     kube.var.log.containers.
        Merge_Log           On
        Keep_Log            Off
        K8S-Logging.Parser  On
        K8S-Logging.Exclude Off

    [OUTPUT]
        Name            es
        Match           kube.*
        Host            elasticsearch.efk.svc
        Port            9200
        Logstash_Format On
        Logstash_Prefix kubernetes
        Replace_Dots    On
        Retry_Limit     False

  parsers.conf: |
    [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L%z

```

应用：

```
kubectl apply -f fluent-bit-config.yaml
```

------

✅ 到这里，RBAC 和配置文件就准备好了。
 下一步就是部署 **Fluent Bit DaemonSet**，它会在每个节点运行并采集日志。



好，我们最后一步来写 **Fluent Bit DaemonSet**，这样就能在节点上采集容器日志并发送到 Elasticsearch。

------

#### 5.3 创建 Fluent Bit DaemonSet

新建文件 **`fluent-bit-daemonset.yaml`**：

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluent-bit
  namespace: efk
  labels:
    app.kubernetes.io/name: fluent-bit
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: fluent-bit
  template:
    metadata:
      labels:
        app.kubernetes.io/name: fluent-bit
    spec:
      serviceAccountName: fluent-bit
      securityContext:
        runAsUser: 0
        runAsGroup: 0
        fsGroup: 0
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
      containers:
        - name: fluent-bit
          image: fluent/fluent-bit:2.9.9
          args: ["-c", "/fluent-bit/etc/fluent-bit.conf"]
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 500m
              memory: 256Mi
          volumeMounts:
            - name: varlog
              mountPath: /var/log
            - name: config
              mountPath: /fluent-bit/etc/
      terminationGracePeriodSeconds: 10
      volumes:
        - name: varlog
          hostPath:
            path: /var/log
            type: Directory
        - name: config
          configMap:
            name: fluent-bit-config
            defaultMode: 420

```

应用：

```
kubectl apply -f fluent-bit-daemonset.yaml
```

------

### 🔍 验证日志采集

1. 查看 Pod 是否正常运行：

```
kubectl -n efk get pods -o wide
```

1. 查看 Fluent Bit 日志确认输出到 ES：

```
kubectl -n efk logs -l app.kubernetes.io/name=fluent-bit
```

1. 检查 Elasticsearch 是否有新索引：

```
kubectl -n efk port-forward svc/elasticsearch 9200:9200 &
curl 'http://127.0.0.1:9200/_cat/indices?v'
```

应该能看到 `kubernetes-*` 开头的索引。

1. 打开 Kibana（http://<你的节点IP>:30601），在 **Stack Management → Index Patterns** 里添加 `kubernetes-*`，选择 `@timestamp` 字段，就能开始在 **Discover** 里查看日志了 🎉

------

✅ 到这里，一整套 **EFK 日志系统** 就部署完成了。



执行报`kubectl -n efk port-forward svc/elasticsearch 9200:9200 &`报错

``` shell
[root@k8s-master efk]# kubectl -n efk port-forward svc/elasticsearch 9200:9200 &
[1] 67634
[root@k8s-master efk]# Forwarding from 127.0.0.1:9200 -> 9200
Handling connection for 9200
E0825 16:44:40.755824   67634 portforward.go:424] "Unhandled Error" err="an error occurred forwarding 9200 -> 9200: error forwarding port 9200 to pod 95b8653b6a8b5d4382d72af972b42cdc3a967c0cb50429cbd00ca703b424a510, uid : unable to do port forwarding: socat not found"
error: lost connection to pod

```

解决方案：

``` shell
# 说明 Kubernetes 本地的 port-forward 功能需要 socat 来转发端口，但你的系统里没有安装它。
yum install -y socat
```

