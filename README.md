# Cloud Native Journey - 个人云原生知识库

[![最后提交](https://img.shields.io/github/last-commit/weizhiwang221/cloud-native-journey?style=flat-square)](https://github.com/weizhiwang221/cloud-native-journey/commits/main)
[![仓库大小](https://img.shields.io/github/repo-size/weizhiwang221/cloud-native-journey?style=flat-square)](https://github.com/weizhiwang221/cloud-native-journey)
[![MIT许可证](https://img.shields.io/github/license/weizhiwang221/cloud-native-journey?style=flat-square)](https://github.com/weizhiwang221/cloud-native-journey/blob/main/LICENSE)

> 一名云计算运维工程师的云原生学习与实践之旅。本仓库记录了关于 Kubernetes、DevOps、云平台及相关技术的知识总结、实践笔记和故障排查经验。

**[🌐 在线访问知识库网站](https://weizhiwang221.github.io/cloud-native-journey/)** | **📖 如何贡献**

------

## 📖 目录概览

<!-- TOC -->

- Kubernetes
- 云平台
- CI/CD
- 基础设施即代码
- 监控与日志
- 项目实践
- 故障排查
- 学习资源
- 如何贡献
- 许可证
- 联系方式

<!-- TOC -->

------

## 🚀 内容导航

### ☸️ Kubernetes

- [核心概念](https://01-kubernetes/01-核心概念.md) - Pods, Deployments, Services 等
- [网络详解](https://01-kubernetes/02-网络.md) - CNI, Service, Ingress, 网络策略
- [存储管理](https://01-kubernetes/03-存储.md) - PV, PVC, StorageClass, CSI
- [安全实践](https://01-kubernetes/04-安全.md) - RBAC, ServiceAccounts, 安全上下文
- [运维管理](https://01-kubernetes/05-运维.md) - Helm, Operator, 升级策略
- [高级调度](https://01-kubernetes/06-调度.md) - 亲和性/反亲和性, 污点与容忍

### ☁️ 云平台

- **AWS**
  - [EKS 实战](https://02-cloud-providers/AWS/01-EKS-实战.md)
  - [IAM 权限管理](https://02-cloud-providers/AWS/02-IAM-权限管理.md)
  - [RDS 与存储服务](https://02-cloud-providers/AWS/03-RDS与存储.md)
- **Azure**
  - [AKS 部署指南](https://02-cloud-providers/Azure/01-AKS-部署指南.md)
- **GCP**
  - [GKE 入门](https://02-cloud-providers/GCP/01-GKE-入门.md)

### 🔁 CI/CD

- [GitHub Actions 实战](https://03-ci-cd/01-GitHub-Actions-实战.md)
- [GitLab CI 完整流程](https://03-ci-cd/02-GitLab-CI-完整流程.md)
- [ArgoCD GitOps 实践](https://03-ci-cd/03-ArgoCD-GitOps-实践.md)
- [Jenkins Pipeline 进阶](https://03-ci-cd/04-Jenkins-Pipeline-进阶.md)

### 📜 基础设施即代码

- [Terraform 模块化实践](https://04-infrastructure-as-code/01-Terraform-模块化实践.md)
- [Ansible 最佳实践](https://04-infrastructure-as-code/02-Ansible-最佳实践.md)
- [Pulumi 与 Terraform 对比](https://04-infrastructure-as-code/03-PulumivsTerraform.md)

### 📊 监控与日志

- [Prometheus + Grafana 全方位监控](https://05-monitoring-logging/01-Prometheus-Grafana-全方位监控.md)
- [Loki 日志系统实战](https://05-monitoring-logging/02-Loki-日志系统实战.md)
- [告警配置与管理](https://05-monitoring-logging/03-告警配置与管理.md)

### 🛠️ 项目实践

- [项目一：基于K8s的微服务电商平台](https://06-projects/01-基于K8s的微服务电商平台.md)
- [项目二：Terraform自动化部署EKS集群](https://06-projects/02-Terraform自动化部署EKS集群.md)
- [项目三：GitOps流水线实战](https://06-projects/03-GitOps流水线实战.md)

### 🔧 故障排查

- [Kubernetes 常见问题排查](https://07-problem-solving/01-Kubernetes-常见问题排查.md)
- [网络问题排查指南](https://07-problem-solving/02-网络问题排查指南.md)
- [存储问题排查](https://07-problem-solving/03-存储问题排查.md)
- [性能调优案例](https://07-problem-solving/04-性能调优案例.md)

------

## 📚 学习资源

### 推荐书籍

- 《Kubernetes权威指南》
- 《云原生模式》
- 《Site Reliability Engineering》

### 在线课程

- [Kubernetes官方文档](https://kubernetes.io/docs/)
- [CNCF社区资源](https://www.cncf.io/)
- [Awesome Kubernetes](https://github.com/ramitsurana/awesome-kubernetes)

### 实用工具

- [k9s - Kubernetes CLI管理工具](https://github.com/derailed/k9s)
- [kubectl-aliases](https://github.com/ahmetb/kubectl-aliases)
- [Helm Charts](https://github.com/helm/charts)

------

## 🤝 贡献

欢迎任何形式的贡献！如果你有：

- 技术文章或笔记想分享
- 发现了文档中的错误或过时内容
- 有新的想法或建议

请遵循以下步骤：

1. Fork 本仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个Pull Request

请确保您的贡献符合我们的[行为准则](https://code_of_conduct.md/)。

------

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](https://license/) 文件了解详情。

------

## 📞 联系方式

魏志旺 - [@weizhiwang221](https://github.com/weizhiwang221) - [weizhiwang221@gmail.com](https://mailto:weizhiwang221@gmail.com/)

项目链接: https://github.com/weizhiwang221/cloud-native-journey

------

## 🙏 致谢

感谢所有开源社区和技术博客的作者，你们的分享是这本知识库的基石。

------

> **Note**: 本知识库持续更新中， star ⭐ 关注获取最新内容！
