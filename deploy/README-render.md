# Render 免费部署后端(公网可访问 + HTTPS)

> 目标:把 NestJS 后端跑到公网,满足宪法铁律 6「可线上部署且公网可访问」。
> 免费、不需服务器、不需备案。Render 自带 HTTPS 与 `*.onrender.com` 域名。
>
> **密钥不写进本文件**(§6 零硬编码密钥):`JWT_ACCESS_SECRET` 自己生成、`ANTHROPIC_*`
> 用中转站那套,填进 Render 网页的 Environment,绝不提交进仓库。

---

## 架构(Render 上的形态)

- Render 自带 HTTPS 终止与路由,**不需要我们自己的 Nginx**,只部署 NestJS 服务 + 托管 Postgres。
- 后端用 `server/Dockerfile` 构建;容器启动跑 `docker-entrypoint.sh` → `prisma migrate deploy`
  (用 `prisma/migrations-postgres`,已入库、Postgres 方言)→ 自动建全 9 表 → 起服务。
- 端口:Render 注入 `PORT`,代码 `config.get('port')` 已读取,无需手填。

---

## 第 1 步 · 建 Postgres 数据库

1. Render 控制台 → **New** → **Postgres**(或 Create a new Service → New Postgres)。
2. 填:
   - **Name**:`testai-db`
   - **Region**:`Singapore`(记住此区,后端要选同一个)
   - **Plan**:**Free**
3. **Create Database**,等状态变 `Available`。
4. 进数据库页 → **Connect** → 复制 **Internal Database URL**(形如
   `postgresql://user:pass@dpg-xxx-a.singapore-postgres.render.com/dbname`)。下一步用。
   > 用 **Internal**(内网,同区服务用),不是 External。

---

## 第 2 步 · 建后端 Web Service

1. **New** → **Web Service** → 连接 GitHub 仓库 `wok676/AI--`(首次需授权 Render 访问该仓库)。
2. 配置:

   | 字段 | 值 |
   |---|---|
   | Name | `testai-server` |
   | Region | **与数据库同区(Singapore)** |
   | Branch | `main` |
   | **Root Directory** | `server` ←(Dockerfile 在 server/,必填) |
   | Runtime | **Docker**(自动识别 server/Dockerfile) |
   | Instance Type | **Free** |
   | Health Check Path | `/api/v1/health` |

3. **Environment Variables**(逐个 Add):

   | Key | Value |
   |---|---|
   | `DATABASE_URL` | 第 1 步复制的 Internal Database URL |
   | `JWT_ACCESS_SECRET` | 一长串随机字符串(自己生成,见对话给的) |
   | `ANTHROPIC_API_KEY` | 中转站 key(同 GitHub Secret) |
   | `ANTHROPIC_BASE_URL` | `https://ai.deepthink.works` |
   | `ANTHROPIC_MODEL` | `claude-opus-4-8` |
   | `ANTHROPIC_TIMEOUT_MS` | `60000` |
   | `NODE_ENV` | `production` |

   > `PORT` 不要填——Render 自动注入,代码会读。

4. **Create Web Service** → Render 开始构建 Docker 镜像(几分钟),日志能看到
   `[entrypoint] running: prisma migrate deploy` → `TestAI server listening on :PORT`。

---

## 第 3 步 · 验证(公网可访问)

部署成功后,服务页顶部有公网地址 `https://testai-server-xxxx.onrender.com`。

```
# 健康检查(浏览器或 curl 都行)
https://testai-server-xxxx.onrender.com/api/v1/health
```

返回正常即达成「公网可访问 + HTTPS」。

> 免费档闲置 15 分钟会休眠,下次访问冷启动 ~30 秒;演示前先点一下唤醒。
> 免费 Postgres 90 天到期需重建(数据清空),比赛周期内够用。

---

## 第 4 步(可选)· 让 App 连上线后端

给真机/评委的包,把 API 地址指向 Render:

```
flutter build apk --release \
  --dart-define=API_BASE_URL=https://testai-server-xxxx.onrender.com/api
```

（注意 `/api`,客户端会再拼 `/v1`。）

---

## 排错

- **build 失败**:看 Render 日志;多为 Root Directory 没填 `server`,或 Dockerfile 路径不对。
- **部署成功但 502/超时**:多为没监听 Render 的 `PORT`(本项目已读 `process.env.PORT`,正常);或健康检查路径填错(应为 `/api/v1/health`)。
- **数据库连不上**:确认 `DATABASE_URL` 用的是 **Internal** URL 且服务与库**同区**。
- **识别报错**:确认 `ANTHROPIC_*` 三个变量已填且 key 有效。
