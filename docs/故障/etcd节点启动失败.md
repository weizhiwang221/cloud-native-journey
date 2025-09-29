



## etcd配置文件

~~~ shell
[root@host-134-84-77-200 ~]# cat /etc/etcd/etcd.conf 
ETCD_NAME="etcd_77_200"
ETCD_DATA_DIR="/apps/etcd_data/etcd"

ETCD_CIPHER_SUITES=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256
ETCD_CERT_FILE=/etc/kubernetes/ssl/etcd_server.crt
ETCD_KEY_FILE=/etc/kubernetes/ssl/etcd_server.key
ETCD_TRUSTED_CA_FILE=/etc/kubernetes/ssl/ca.crt
ETCD_CLIENT_CERT_AUTH=true

ETCD_LISTEN_CLIENT_URLS="https://134.84.77.200:1159,https://127.0.0.1:1159"
ETCD_ADVERTISE_CLIENT_URLS="https://134.84.77.200:1159,https://127.0.0.1:1159"

ETCD_PEER_CERT_FILE=/etc/kubernetes/ssl/etcd_server.crt
ETCD_PEER_KEY_FILE=/etc/kubernetes/ssl/etcd_server.key
ETCD_PEER_TRUSTED_CA_FILE=/etc/kubernetes/ssl/ca.crt

ETCD_INITIAL_CLUSTER="etcd_77_200=https://134.84.77.200:2380,etcd_76_180=https://134.84.76.180:2380,etcd_78_84=https://134.84.78.84:2380"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="cc34c326-4694-48c6-afdf-c317f40c1847"
ETCD_LISTEN_PEER_URLS="https://134.84.77.200:2380"
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://134.84.77.200:2380"
[root@host-134-84-77-200 ~]# 
~~~

## etcd服务单元文件

~~~ shell
[root@host-134-84-77-200 ~]# cat /usr/lib/systemd/system/etcd.service
[Unit]
Description=Etcd Server
After=network.target

[Service]
Type=notify
WorkingDirectory=/apps/etcd_data/etcd
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/usr/bin/etcd
RestartSec=3
Restart=on-failure

[Install]
WantedBy=multi-user.target
[root@host-134-84-77-200 ~]# 
~~~

## etcd 服务状态

~~~ shell
[root@host-134-84-77-200 ~]# systemctl status etcd
● etcd.service - Etcd Server
   Loaded: loaded (/usr/lib/systemd/system/etcd.service; enabled; vendor preset: disabled)
   Active: inactive (dead) (Result: exit-code) since Thu 2025-01-23 22:49:49 CST; 8 months 1 days ago
 Main PID: 34358 (code=exited, status=1/FAILURE)

Sep 25 16:38:05 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:38:05 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:39:59 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:39:59 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:48:40 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:48:40 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:54:39 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:54:39 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 17:00:49 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 17:00:49 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
~~~

## etcd日志

~~~ shell
[root@host-134-84-77-200 ~]# journalctl -xe -u etcd
-- 
-- The job identifier is 51123310 and the job result is dependency.
Sep 25 16:16:23 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:22:35 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
-- Subject: A start job for unit etcd.service has failed
-- Defined-By: systemd
-- Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- A start job for unit etcd.service has finished with a failure.
-- 
-- The job identifier is 51123502 and the job result is dependency.
Sep 25 16:22:35 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:38:05 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
-- Subject: A start job for unit etcd.service has failed
-- Defined-By: systemd
-- Support: https://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- A start job for unit etcd.service has finished with a failure.
-- 
~~~



## etcd排查脚本

~~~ shell
#!/bin/bash
# check_etcd_node.sh
# 用于排查 etcd 节点启动问题

ETCD_CONF="/etc/etcd/etcd.conf"
ETCD_BIN="/usr/bin/etcd"
WORKDIR=$(grep "^ETCD_DATA_DIR" $ETCD_CONF | cut -d= -f2 | tr -d '"')
CERT=$(grep "^ETCD_CERT_FILE" $ETCD_CONF | cut -d= -f2 | tr -d '"')
KEY=$(grep "^ETCD_KEY_FILE" $ETCD_CONF | cut -d= -f2 | tr -d '"')
CA=$(grep "^ETCD_TRUSTED_CA_FILE" $ETCD_CONF | cut -d= -f2 | tr -d '"')

echo "===== 1. 检查网络服务 ====="
systemctl is-active network &>/dev/null && echo "network 服务正常" || echo "network 服务未启动"
systemctl is-active NetworkManager &>/dev/null && echo "NetworkManager 服务正常" || echo "NetworkManager 服务未启动"

echo "===== 2. 检查 etcd 服务状态 ====="
systemctl status etcd -l --no-pager

echo "===== 3. 检查 etcd 进程 ====="
ps -ef | grep [e]tcd

echo "===== 4. 检查数据目录 ====="
if [ -d "$WORKDIR" ]; then
    echo "数据目录存在: $WORKDIR"
    ls -ld "$WORKDIR"
else
    echo "数据目录不存在: $WORKDIR"
fi

echo "===== 5. 检查证书文件 ====="
for f in "$CERT" "$KEY" "$CA"; do
    if [ -f "$f" ]; then
        echo "证书文件存在: $f"
        ls -l "$f"
    else
        echo "证书文件缺失: $f"
    fi
done

echo "===== 6. 检查端口监听 ====="
ss -lntp | grep etcd || echo "etcd 端口未监听"

echo "===== 7. 尝试手动启动 etcd 检查错误 ====="
echo "==== 注意：这是测试启动，不会后台运行 ===="
$ETCD_BIN --config-file $ETCD_CONF

~~~

## etcd 脚本执行结果

~~~ shell
[root@host-134-84-77-200 ~]# sh check_etcd_node.sh 
===== 1. 检查网络服务 =====
network 服务未启动
NetworkManager 服务正常
===== 2. 检查 etcd 服务状态 =====
● etcd.service - Etcd Server
   Loaded: loaded (/usr/lib/systemd/system/etcd.service; enabled; vendor preset: disabled)
   Active: inactive (dead) (Result: exit-code) since Thu 2025-01-23 22:49:49 CST; 8 months 1 days ago
 Main PID: 34358 (code=exited, status=1/FAILURE)

Sep 25 16:38:05 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:38:05 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:39:59 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:39:59 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:48:40 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:48:40 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 16:54:39 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 16:54:39 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
Sep 25 17:00:49 host-134-84-77-200 systemd[1]: Dependency failed for Etcd Server.
Sep 25 17:00:49 host-134-84-77-200 systemd[1]: etcd.service: Job etcd.service/start failed with result 'dependency'.
===== 3. 检查 etcd 进程 =====
root      8468     1  4  2024 ?        16-05:08:06 /usr/bin/kube-apiserver --bind-address=0.0.0.0 --secure-port=6443 --authorization-mode=RBAC --anonymous-auth=false --etcd-servers=https://134.84.77.200:1159,https://134.84.76.180:1159,https://134.84.78.84:1159 --service-cluster-ip-range=169.169.0.0/16 --etcd-certfile=/etc/kubernetes/ssl/etcd_client.crt --etcd-keyfile=/etc/kubernetes/ssl/etcd_client.key --etcd-cafile=/etc/kubernetes/ssl/ca.crt --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/ssl/sa.pub --service-account-signing-key-file=/etc/kubernetes/ssl/sa.key --kubelet-client-certificate=/etc/kubernetes/ssl/client.crt --kubelet-client-key=/etc/kubernetes/ssl/client.key --enable-admission-plugins=NamespaceLifecycle,LimitRanger,ServiceAccount,ResourceQuota,NodeRestriction,MutatingAdmissionWebhook,ValidatingAdmissionWebhook --service-node-port-range=20000-32767 --client-ca-file=/etc/kubernetes/ssl/ca.crt --tls-cipher-suites=TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_GCM_SHA256 --tls-private-key-file=/etc/kubernetes/ssl/apiserver.key --tls-cert-file=/etc/kubernetes/ssl/apiserver.crt --v=0 --allow-privileged=true --event-ttl=48h0m0s --max-mutating-requests-inflight=500 --max-requests-inflight=1500 --default-watch-cache-size=10000 --apiserver-count=3 --endpoint-reconciler-type=lease --requestheader-client-ca-file=/etc/kubernetes/ssl/front-proxy-ca.crt --requestheader-allowed-names= --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --proxy-client-cert-file=/etc/kubernetes/ssl/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/ssl/front-proxy-client.key --enable-aggregator-routing=true --oidc-issuer-url=https://keycloak.sdpod-77-200-20030.4a.cmit.cloud:20129/auth/realms/kem --oidc-client-id=kubernetes --oidc-username-claim=preferred_username --oidc-username-prefix=- --oidc-groups-claim=groups --oidc-ca-file=/etc/kubernetes/pki/ca_ssl/tls.crt --audit-policy-file=/etc/kubernetes/audit-policy.yaml --audit-log-path=/apps/monitor/oblogs/kube-apiserver/audit.log --feature-gates=
aiox     12572 12538  0 May08 ?        09:59:59 /usr/local/bin/etcd
5000     33511 33473  0 17:11 ?        00:00:00 /usr/local/openresty//luajit/bin/luajit ./apisix/cli/apisix.lua init_etcd
root     33758 18036  0 17:11 pts/1    00:00:00 sh check_etcd_node.sh
===== 4. 检查数据目录 =====
数据目录存在: /apps/etcd_data/etcd
drwxr-xr-x 3 root root 20 Aug 27 18:20 /apps/etcd_data/etcd
===== 5. 检查证书文件 =====
证书文件存在: /etc/kubernetes/ssl/etcd_server.crt
-rw-r--r-- 1 root root 1367 Sep 19  2024 /etc/kubernetes/ssl/etcd_server.crt
证书文件存在: /etc/kubernetes/ssl/etcd_server.key
-rw-r--r-- 1 root root 1679 Sep 19  2024 /etc/kubernetes/ssl/etcd_server.key
证书文件存在: /etc/kubernetes/ssl/ca.crt
-rw-r--r-- 1 root root 1346 Sep 19  2024 /etc/kubernetes/ssl/ca.crt
===== 6. 检查端口监听 =====
etcd 端口未监听
===== 7. 尝试手动启动 etcd 检查错误 =====
==== 注意：这是测试启动，不会后台运行 ====
{"level":"info","ts":"2025-09-25T17:11:33.367+0800","caller":"etcdmain/etcd.go:73","msg":"Running: ","args":["/usr/bin/etcd","--config-file","/etc/etcd/etcd.conf"]}
{"level":"warn","ts":"2025-09-25T17:11:33.367+0800","caller":"etcdmain/etcd.go:75","msg":"failed to verify flags","error":"error unmarshaling JSON: while decoding JSON: json: cannot unmarshal string into Go value of type embed.configYAML"}
[root@host-134-84-77-200 ~]# 
~~~

## 检查etcd集群状态

~~~ shell
[root@host-134-84-77-200 ~]# cat check_etcd.sh 
 ETCDCTL_API=3 etcdctl   --endpoints=https://134.84.77.200:1159,https://134.84.76.180:1159,https://134.84.78.84:1159   --cert=/etc/kubernetes/ssl/etcd_server.crt   --key=/etc/kubernetes/ssl/etcd_server.key   --cacert=/etc/kubernetes/ssl/ca.crt  member list  -w table

  ETCDCTL_API=3 etcdctl   --endpoints=https://134.84.77.200:1159,https://134.84.76.180:1159,https://134.84.78.84:1159   --cert=/etc/kubernetes/ssl/etcd_server.crt   --key=/etc/kubernetes/ssl/etcd_server.key   --cacert=/etc/kubernetes/ssl/ca.crt  endpoint health  -w table

   ETCDCTL_API=3 etcdctl   --endpoints=https://134.84.77.200:1159,https://134.84.76.180:1159,https://134.84.78.84:1159   --cert=/etc/kubernetes/ssl/etcd_server.crt   --key=/etc/kubernetes/ssl/etcd_server.key   --cacert=/etc/kubernetes/ssl/ca.crt  endpoint status  -w table
[root@host-134-84-77-200 ~]# 
[root@host-134-84-77-200 ~]# sh check_etcd.sh 
+------------------+---------+-------------+----------------------------+---------------------------------------------------+------------+
|        ID        | STATUS  |    NAME     |         PEER ADDRS         |                   CLIENT ADDRS                    | IS LEARNER |
+------------------+---------+-------------+----------------------------+---------------------------------------------------+------------+
| 21bc8eac53683297 | started | etcd_77_200 | https://134.84.77.200:2380 | https://127.0.0.1:1159,https://134.84.77.200:1159 |      false |
| 5fe1cd5d0739c590 | started | etcd_76_180 | https://134.84.76.180:2380 | https://127.0.0.1:1159,https://134.84.76.180:1159 |      false |
| c36ef91fe0394790 | started |  etcd_78_84 |  https://134.84.78.84:2380 |  https://127.0.0.1:1159,https://134.84.78.84:1159 |      false |
+------------------+---------+-------------+----------------------------+---------------------------------------------------+------------+
{"level":"warn","ts":"2025-09-25T17:13:47.180+0800","logger":"client","caller":"v3/retry_interceptor.go:62","msg":"retrying of unary invoker failed","target":"etcd-endpoints://0xc0005901c0/134.84.77.200:1159","attempt":0,"error":"rpc error: code = DeadlineExceeded desc = latest balancer error: last connection error: connection error: desc = \"transport: Error while dialing dial tcp 134.84.77.200:1159: connect: connection refused\""}
+----------------------------+--------+--------------+---------------------------+
|          ENDPOINT          | HEALTH |     TOOK     |           ERROR           |
+----------------------------+--------+--------------+---------------------------+
| https://134.84.76.180:1159 |   true |  11.228944ms |                           |
|  https://134.84.78.84:1159 |   true |   11.46168ms |                           |
| https://134.84.77.200:1159 |  false | 5.002421269s | context deadline exceeded |
+----------------------------+--------+--------------+---------------------------+
Error: unhealthy cluster
{"level":"warn","ts":"2025-09-25T17:13:52.205+0800","logger":"etcd-client","caller":"v3/retry_interceptor.go:62","msg":"retrying of unary invoker failed","target":"etcd-endpoints://0xc00037ea80/134.84.77.200:1159","attempt":0,"error":"rpc error: code = DeadlineExceeded desc = latest balancer error: last connection error: connection error: desc = \"transport: Error while dialing dial tcp 134.84.77.200:1159: connect: connection refused\""}
Failed to get the status of endpoint https://134.84.77.200:1159 (context deadline exceeded)
+----------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|          ENDPOINT          |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+----------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| https://134.84.76.180:1159 | 5fe1cd5d0739c590 |   3.5.4 |   76 MB |      true |      false |       108 |  122835465 |          122835465 |        |
|  https://134.84.78.84:1159 | c36ef91fe0394790 |   3.5.4 |   76 MB |     false |      false |       108 |  122835465 |          122835465 |        |
+----------------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
[root@host-134-84-77-200 ~]# 


~~~

## NetworkManager状态

~~~ shell
[root@host-134-84-77-200 ~]# systemctl status NetworkManager
● NetworkManager.service - Network Manager
   Loaded: loaded (/usr/lib/systemd/system/NetworkManager.service; enabled; vendor preset: enabled)
  Drop-In: /usr/lib/systemd/system/NetworkManager.service.d
           └─NetworkManager-ovs.conf
   Active: active (running) since Thu 2025-09-25 16:38:22 CST; 39min ago
     Docs: man:NetworkManager(8)
 Main PID: 37777 (NetworkManager)
    Tasks: 4
   Memory: 4.9M
   CGroup: /system.slice/NetworkManager.service
           ├─37777 /usr/sbin/NetworkManager --no-daemon
           └─37797 /sbin/dhclient -d -q -sf /usr/libexec/nm-dhcp-helper -pf /var/run/NetworkManager/dhclient-enp4s3.pid -lf /var/lib/NetworkManager/dhclient-533eea9f-b33d-480b-828f-1ef3d511>

Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3411] manager: NetworkManager state is now CONNECTED_LOCAL
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3420] policy: set 'enp4s3' (enp4s3) as default for IPv4 routing and DNS
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3421] policy: set 'enp4s3' (enp4s3) as default for IPv6 routing and DNS
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3473] device (docker0): Activation: successful, device activated.
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3483] device (enp4s3): state change: ip-check -> secondaries (reason 'none', sys-iface-state: 'assume')
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3485] device (enp4s3): state change: secondaries -> activated (reason 'none', sys-iface-state: 'assume')
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3489] manager: NetworkManager state is now CONNECTED_SITE
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3496] device (enp4s3): Activation: successful, device activated.
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3502] manager: NetworkManager state is now CONNECTED_GLOBAL
Sep 25 16:38:22 host-134-84-77-200 NetworkManager[37777]: <info>  [1758789502.3512] manager: startup complete
[root@host-134-84-77-200 ~]# 
~~~

## 文件目录权限

~~~ shell
[root@host-134-84-77-200 ~]# ls -ltr /apps/etcd_data/etcd/
total 0
drwx------ 4 root root 29 Aug 27 18:20 member
[root@host-134-84-77-200 ~]# ls -ltr /apps/etcd_data/
total 0
drwxr-xr-x 3 root root 20 Aug 27 18:20 etcd
[root@host-134-84-77-200 ~]# ls -ltr /etc/etcd/etcd.conf 
-rw-r--r-- 1 root root 1225 Sep 25 16:55 /etc/etcd/etcd.conf
[root@host-134-84-77-200 ~]# 
~~~



## 使用`strace systemctl start etcd`命令

> 查看发现资源临时不可用

~~~ shell
ppoll([{fd=3, events=POLLIN}], 1, NULL, NULL, 8) = 1 ([{fd=3, revents=POLLIN}])
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\4\1\1\220\0\0\0\310\0\0\0\276\0\0\0\1\1o\0002\0\0\0", iov_len=24}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 24
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="/org/freedesktop/systemd1/unit/d"..., iov_len=328}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 328
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\4\1\1d\3\0\0\311\0\0\0\276\0\0\0\1\1o\0002\0\0\0", iov_len=24}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 24
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="/org/freedesktop/systemd1/unit/d"..., iov_len=1052}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 1052
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\4\1\1d\0\0\0\312\0\0\0\36\1\0\0\1\1o\0\220\0\0\0", iov_len=24}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 24
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="/org/freedesktop/systemd1/unit/d"..., iov_len=380}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 380
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="l\4\1\1d\3\0\0\313\0\0\0\36\1\0\0\1\1o\0\220\0\0\0", iov_len=24}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 24
recvmsg(3, {msg_name=NULL, msg_namelen=0, msg_iov=[{iov_base="/org/freedesktop/systemd1/unit/d"..., iov_len=1148}], msg_iovlen=1, msg_controllen=0, msg_flags=MSG_CMSG_CLOEXEC}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = 1148
recvmsg(3, {msg_namelen=0}, MSG_DONTWAIT|MSG_CMSG_CLOEXEC) = -1 EAGAIN (Resource temporarily unavailable)
~~~



## 解决方案

#### <font color="red">**重启宿主机发现etcd服务启动正常！！！**</font>

