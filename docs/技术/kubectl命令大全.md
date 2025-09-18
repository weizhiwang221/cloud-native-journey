# kubectl 命令大全

**管理资源**:

| 命令               | 描述                               |
| ------------------ | ---------------------------------- |
| `kubectl create`   | 创建资源对象，如Pod、Deployment等  |
| `kubectl apply`    | 应用配置文件或资源对象的更改       |
| `kubectl get`      | 获取资源对象的信息                 |
| `kubectl describe` | 显示资源对象的详细信息             |
| `kubectl edit`     | 编辑资源对象的配置                 |
| `kubectl delete`   | 删除资源对象                       |
| `kubectl replace`  | 用新的资源对象替换现有的资源对象   |
| `kubectl scale`    | 调整Deployment或ReplicaSet的副本数 |
| `kubectl rollout`  | 管理滚动升级Deployment的过程       |

**查看资源**:

| 命令                   | 描述                            |
| ---------------------- | ------------------------------- |
| `kubectl get`          | 获取资源对象的信息              |
| `kubectl describe`     | 显示资源对象的详细信息          |
| `kubectl logs`         | 查看Pod的日志                   |
| `kubectl port-forward` | 将本地端口映射到Pod上的端口     |
| `kubectl top`          | 查看资源使用情况（CPU、内存等） |

**故障排除和诊断**:

| 命令               | 描述                                   |
| ------------------ | -------------------------------------- |
| `kubectl exec`     | 在Pod内部执行命令                      |
| `kubectl attach`   | 连接到Pod并查看其输出                  |
| `kubectl cp`       | 从Pod复制文件到本地，或从本地复制到Pod |
| `kubectl describe` | 显示资源对象的详细信息（用于排查问题） |
| `kubectl logs`     | 查看Pod的日志（用于排查问题）          |

**集群管理**:

| 命令                   | 描述                                 |
| ---------------------- | ------------------------------------ |
| `kubectl cluster-info` | 查看集群信息                         |
| `kubectl config`       | 管理Kubernetes配置文件               |
| `kubectl version`      | 查看Kubernetes客户端和服务器版本信息 |
| `kubectl proxy`        | 启动本地代理以访问Kubernetes API     |
| `kubectl taint`        | 添加或移除节点的污点                 |
| `kubectl uncordon`     | 使节点重新可调度                     |
| `kubectl drain`        | 驱逐节点上的Pod以维护节点            |
| `kubectl cordon`       | 阻止节点调度新的Pod                  |

**安全性和身份验证**:

| 命令                            | 描述               |
| ------------------------------- | ------------------ |
| `kubectl auth`                  | 管理身份验证和授权 |
| `kubectl create serviceaccount` | 创建服务账号       |
| `kubectl create role`           | 创建角色           |
| `kubectl create rolebinding`    | 创建角色绑定       |

**其他**:

| 命令               | 描述                                   |
| ------------------ | -------------------------------------- |
| `kubectl label`    | 为资源对象添加标签或修改标签           |
| `kubectl annotate` | 为资源对象添加注释或修改注释           |
| `kubectl rollout`  | 管理滚动升级Deployment的过程           |
| `kubectl explain`  | 查看Kubernetes资源对象的定义和字段含义 |

请注意，这只是一些常见的kubectl命令，Kubernetes有很多功能和资源类型，因此还有其他命令和选项可供使用。您可以使用`kubectl --help`查看kubectl的全局选项以及各个子命令的选项和用法。