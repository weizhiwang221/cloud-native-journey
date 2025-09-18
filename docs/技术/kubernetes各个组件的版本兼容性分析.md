###### **一、calico与kubernetes兼容性对照表**

| ***\*calico版本\**** | ***\*kubernetes版本\****            | ***\*calico官网地址\****                                     |
| :------------------- | :---------------------------------- | ------------------------------------------------------------ |
| v3.12                | v1.14<br>v1.15<br/>v1.16<br/>v1.17  | https://docs.tigera.io/archive/v3.12/getting-started/kubernetes/requirements |
| v.3.13               | v1.15<br/>v1.16<br/>v1.17           | https://docs.tigera.io/archive/v3.13/getting-started/kubernetes/requirements |
| v3.14                | v1.16<br/>v1.17<br/>v1.18           | https://docs.tigera.io/archive/v3.14/getting-started/kubernetes/requirements |
| v3.15                | v1.16<br/>v1.17<br/>v1.18           | https://docs.tigera.io/archive/v3.15/getting-started/kubernetes/requirements |
| v3.16                | v1.16<br/>v1.17<br/>v1.18<br/>v1.19 | https://docs.tigera.io/archive/v3.16/getting-started/kubernetes/requirements |
| v3.17                | v1.17<br/>v1.18<br/>v1.19           | https://docs.tigera.io/archive/v3.17/getting-started/kubernetes/requirements |
| v3.18                | v1.18<br/>v1.19<br/>v1.20           | https://docs.tigera.io/archive/v3.18/getting-started/kubernetes/requirements |
| v3.19                | v1.19<br/>v1.20<br/>v1.21           | https://docs.tigera.io/archive/v3.19/getting-started/kubernetes/requirements |
| v3.20                | v1.19<br/>v1.20<br/>v1.21           | https://docs.tigera.io/archive/v3.20/getting-started/kubernetes/requirements |
| v3.21                | v1.20<br/>v1.21<br/>v1.22           | https://docs.tigera.io/archive/v3.21/getting-started/kubernetes/requirements |
| v3.22                | v1.21<br/>v1.22<br/>v1.23           | https://docs.tigera.io/archive/v3.22/getting-started/kubernetes/requirements |
| v3.23                | v1.21<br/>v1.22<br/>v1.23           | https://docs.tigera.io/archive/v3.23/getting-started/kubernetes/requirements |
| v3.24                | v1.22<br/>v1.23<br/>v1.24<br/>v1.25 | https://docs.tigera.io/calico/3.24/getting-started/kubernetes/requirements |
| v3.25                | v1.23<br/>v1.24<br/>v1.25<br/>v1.26 | https://docs.tigera.io/calico/3.25/getting-started/kubernetes/requirements |
| v3.26                | v1.24<br/>v1.25<br/>v1.26<br/>v1.27 | https://docs.tigera.io/calico/latest/getting-started/kubernetes/requirements |

###### **二****、****docker****与kubernetes兼容性对照表**

| ***\*k8s版本\**** | ***\*docker版本\****                                     | ***\*查看地址\****                                           |
| ----------------- | -------------------------------------------------------- | ------------------------------------------------------------ |
| v1.15             | 1.13.1<br/>17.03<br/>17.06<br/>17.09<br/>18.06<br/>18.09 | https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.15.md#server-binaries |
| v1.16             | 1.13.1<br/>17.03<br/>17.06<br/>17.09<br/>18.06<br/>18.09 | https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.16.md |
| v1.17             | 19.03                                                    | https://www.cnblogs.com/jinzhenshui/p/16724379.html          |
| v1.18             | 19.03或更高                                              | https://zhuanlan.zhihu.com/p/121100475                       |
| v1.19             | 19.03或更高                                              |                                                              |
| v1.20             | 19.03或更高                                              | https://blog.csdn.net/alwaysbefine/article/details/119658708 |
| v1.21             | 20.10或更高                                              | https://www.cnblogs.com/superlinux/p/14676959.html           |
| v1.22             | 20.10或更高                                              | https://blog.csdn.net/qq_30614345/article/details/131334199?spm=1001.2101.3001.6650.2&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EYuanLiJiHua%7EPosition-2-131334199-blog-119430082.235%5Ev38%5Epc_relevant_default_base&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EYuanLiJiHua%7EPosition-2-131334199-blog-119430082.235%5Ev38%5Epc_relevant_default_base&utm_relevant_index=3 |
| v1.23             | 20.10或更高                                              | https://blog.csdn.net/yy8623977/article/details/124685772    |
| v1.24             | 20.10或更高                                              | ***\*k8s v1.24以后需要额外安装cri-dockerd, k8s才能够正常识别到Docker。\**** |
| v1.25             | 20.10或更高                                              | https://blog.51cto.com/dayu/5825840                          |
| v1.26             | 20.10或更高                                              |                                                              |
| v1.27             | 20.10或更高                                              | https://blog.csdn.net/zo2k123/article/details/130328617      |

###### **三、etcd与kubernetes兼容性对照表**

| ***\*etcd版本\**** | ***\*kubernetes版本\****                                | ***\*查看地址\****                                           |
| ------------------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| 3.2.x              | v1.11<br/>v1.12                                         | https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.22.md |
| 3.3.x              | v1.13<br/>v1.14<br/>v1.15<br/>v1.16                     |                                                              |
| 3.4.x              | v1.17<br/>v1.18<br/>v1.19<br/>v1.20<br/>v1.21           |                                                              |
| 3.5.x              | v1.22<br/>v1.23<br/>v1.24<br/>v1.25<br/>v1.26<br/>v1.27 |                                                              |

###### **四、coredns与kubernetes兼容性对照表**

| ***\*coredns版本\**** | ***\*kubernetes版本\**** | ***\*查看地址\****                                           |
| --------------------- | ------------------------ | ------------------------------------------------------------ |
| 1.0.1                 | v1.09                    | https://github.com/coredns/deployment/blob/master/kubernetes/CoreDNS-k8s_version.md |
| 1.0.6                 | v1.10                    |                                                              |
| 1.1.3                 | v1.11                    |                                                              |
| 1.2.2                 | v1.12                    |                                                              |
| 1.2.6                 | v1.13                    |                                                              |
| 1.3.1                 | v1.14<br/>v1.15          |                                                              |
| 1.6.2                 | v1.16                    |                                                              |
| 1.6.5                 | v1.17                    |                                                              |
| 1.6.7                 | v1.18                    |                                                              |
| 1.7.0                 | v1.19<br/>v1.20          |                                                              |
| 1.8.0                 | v1.21                    |                                                              |
| 1.8.4                 | v1.22                    |                                                              |
| 1.8.6                 | v1.23                    |                                                              |
| 1.9.3                 | v1.25<br/>v1.26          |                                                              |
| 1.10.1                | v1.27                    |                                                              |

 

 