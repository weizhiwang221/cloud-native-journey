# Docker 常用命令

## 1、仓库相关
| 命令             | 描述                                   |
| ---------------- | -------------------------------------- |
| `docker search ` | Docker仓库查询镜像                     |
| `docker login`   | 登录到docker镜像仓库                   |
| `docker logout`  | 登出docker镜像仓库                     |
| `docker pull `   | Docker仓库下载镜像                     |
| `docker push`    | 从本地上传镜像到Docker仓库             |
| `docker info`    | 显示 Docker 系统信息，包括镜像和容器数 |
| `docker version` | 显示 Docker 版本信息                   |

## 2、镜像相关

本地镜像管理

| 命令                | 描述                                |
| ------------------- | ----------------------------------- |
| `docker images`     | 列出本地镜像                        |
| `docker rmi   `     | 删除本地一个或多个镜像              |
| `docker tag    `    | 标记本地镜像，将其归入某一仓库      |
| `docker build   `   | 用于使用 Dockerfile 创建镜像        |
| `docker history  `  | 查看指定镜像的创建历史              |
| `docker save      ` | 将指定镜像保存成 tar 归档文件       |
| `docker load `      | 导入使用 docker save 命令导出的镜像 |
| `docker import  `   | 从归档文件中创建镜像                |

## 3、容器相关

容器生命周期管理

| 命令                          | 描述                   |
| ----------------------------- | ---------------------- |
| `docker run                 ` | 创建并启动容器         |
| `docker create              ` | 创建一个容器，但不启用 |
| `docker start/stop/restart  ` | 启动/停止/重启容器     |
| `docker kill                ` | 杀死容器               |
| `docker rm                  ` | 移除容器               |
| `docker pause               ` | 暂停容器中所有进程     |
| `docker unpause             ` | 恢复容器中所有进程     |
| `docker exec                ` | 在运行的容器中执行命令 |

## 4、容器操作

| 命令             | 描述                                                         |
| ---------------- | ------------------------------------------------------------ |
| `docker ps     ` | 列出容器                                                     |
| `docker inspect` | 获取容器/镜像的元数据                                        |
| `docker top    ` | 查看容器中运行的进程信息，支持 ps 命令参数                   |
| `docker attach ` | 连接到正在运行中的容器                                       |
| `docker events ` | 从服务器获取实时事件                                         |
| `docker logs   ` | 获取容器的日志                                               |
| `docker wait   ` | 阻塞运行直到容器停止，然后打印出退出代码                     |
| `docker export ` | 将文件系统作为一个tar归档文件导出到STDOUT                    |
| `docker port   ` | 列出指定的容器的端口映射，或者查找将PRIVATE_PORT NAT到面向公众的端口 |

## 5、容器rootfs命令

| 命令            | 描述                         |
| --------------- | ---------------------------- |
| `docker commit` | 从容器创建一个新的镜像       |
| `docker cp `    | 用于容器与主机之间的数据拷贝 |
| `docker diff`   | 检查容器里文件结构的更改     |

