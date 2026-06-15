# 模板 06 · 部署(Docker / Nginx / SSL)

> 用途:阶段 5 工程部署。驱动 AI 编写部署脚本并上线。
> 对应:工程部署与可用性 —— 公网可访问是硬指标。

---

**角色 Role**:你是 devops-release-manager。

**目标 Goal**:将后端 + 管理后台部署到云服务器,实现公网域名 HTTPS 访问。

**环境信息 Env**(填写):
- 服务器:【IP / SSH 用户】
- 域名:【落地页 / API / 管理后台 子域】
- 证书:Let's Encrypt(certbot)

**约束 Constraints**:
- 全自动/半自动脚本,幂等可重跑。
- 密钥走 `.env` / CI Secrets,不写进脚本。
- 全站 HTTPS。

**输出 Output**:
1. `Dockerfile`(多阶段)+ `docker-compose.yml`。
2. `deploy/nginx.conf`(反代 + SSL)。
3. `deploy/deploy.sh`(SSH 自动化部署)。
4. 健康检查端点 + 部署文档(含访问地址)。

**验收 Acceptance**:
- [ ] `docker-compose up` 一键起全栈。
- [ ] 公网域名 HTTPS 可访问,前端连通线上后端。
- [ ] 重跑脚本不破坏现有数据。
