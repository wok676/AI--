# 生产部署模板 + 本地→生产切换清单

> 状态:**模板就绪,未真实部署**。当前无云服务器/域名,选题虽已落地(食物识别记餐),
> 但任何上公网/不可逆动作都要先过《发布确认清单》(本文末)并得到人类明确"通过"。
> 上位法:`CLAUDE.md §3.3`(Docker/Nginx/SSL 全站 HTTPS)、`§6`(密钥只走 .env)。

本地与生产**共用同一套代码**,差异**只**落在环境变量里的「地址 / 域名 / 密钥」三类。
切生产无需改任何代码。

---

## 1. 文件清单(本目录)

| 文件 | 作用 | 含真值? |
|---|---|---|
| `docker-compose.dev.yml` | 本地 dev 起栈(db+server+pgadmin,明文 http localhost) | 否(读 `.env`) |
| `docker-compose.prod.yml` | 生产起栈(nginx+server+db,TLS only,backup profile) | 否(读 `.env.production`) |
| `nginx/prod.conf` | 反代 + 强制 HTTPS + 仅 TLS1.2/1.3 + HSTS | 否(占位 `__DOMAIN__`) |
| `.env.example` | 本地 dev 变量样板 | 否(占位) |
| `.env.production.example` | 生产变量样板 | 否(占位) |
| `.env` / `.env.production` | 真实值,**已 .gitignore,严禁提交** | 是(仅本机/部署机) |
| `nginx/certs/` `nginx/acme-challenge/` `backups/` | 证书/ACME/加密备份目录,**已 .gitignore** | 是(部署机本地) |

---

## 2. 本地 → 生产:到底改哪几个变量

把 `deploy/.env.production.example` 复制成 `deploy/.env.production`,只改下面这些(其余沿用默认):

### A. 地址 / 域名(决定"切到哪")
| 变量 | 本地 dev | 生产改成 |
|---|---|---|
| `DOMAIN` | (无,走 localhost) | 真实域名,例 `api.testai.example.com` |
| `nginx/prod.conf` 里的 `__DOMAIN__` | — | 同上(手改或 envsubst) |
| `CORS_ORIGINS` | 留空(放行所有,便于联调) | 收紧到真实前端/后台来源 `https://...`,**禁止留空** |
| 客户端 `API_BASE_URL`(Flutter `--dart-define`) | `http://localhost:3000/api` 或局域网 IP | `https://<DOMAIN>/api` |
| 管理后台 `VITE_API_BASE_URL`(admin/.env) | 留空走 vite 代理 | `https://<DOMAIN>/api/v1` |

### B. 密钥 / 凭据(生产必须全新强随机,勿复用 dev)
| 变量 | 说明 |
|---|---|
| `POSTGRES_PASSWORD` | 强随机;同步 `DATABASE_URL` 里的口令 |
| `JWT_ACCESS_SECRET` | `openssl rand -base64 48`,全新 |
| `ANTHROPIC_API_KEY` | 真实 Claude 密钥(识别功能需要) |
| `BACKUP_GPG_PASSPHRASE` | 每日加密备份口令,强随机 |

### C. 证书(TLS,文件不入库)
- 放到 `deploy/nginx/certs/{fullchain.pem,privkey.pem}`。
- 来源二选一:certbot(Let's Encrypt,http-01 走 `nginx/acme-challenge/`)或 Cloudflare Origin Cert。

> 代码侧无需改动:`server` 的连库地址、CORS、密钥全部从 `.env.production` 注入;
> `app_config.dart` / `admin/src/api/client.ts` / `admin/vite.config.ts` 均已 env 驱动(本轮已核对,无硬编码地址)。

---

## 3. 生产起栈(部署机,确认门通过后)

```bash
cp deploy/.env.production.example deploy/.env.production   # 填真值
# 证书就位 deploy/nginx/certs/{fullchain.pem,privkey.pem};把 prod.conf 的 __DOMAIN__ 改成真域名
docker compose -f deploy/docker-compose.prod.yml --env-file deploy/.env.production up -d --build
# 健康检查(经 nginx TLS):
curl https://<DOMAIN>/api/v1/health        # 期望 {"status":"ok",...}
# 验证仅 TLS1.2/1.3(1.0/1.1 应握手失败):
curl -sv --tlsv1.1 --tls-max 1.1 https://<DOMAIN>/api/v1/health   # 应失败
# 每日加密备份(可挂 cron/systemd timer 调用):
docker compose -f deploy/docker-compose.prod.yml --env-file deploy/.env.production --profile backup run --rm backup
```

DB 从空库自动建表与 dev 同机制:`server` entrypoint 跑 `prisma migrate deploy` + migrate diff 安全网(已在本地实测,9 表齐全)。

幂等:重跑 `up -d` 不重建数据卷;迁移已应用则跳过;`down`(不带 `-v`)保留数据。

---

## 4. 上公网前的《发布确认清单》(必须人类拍板"通过")

逐项确认,未过不执行任何对外动作:

- 目标环境与访问地址:`https://<DOMAIN>` —— ❓ 域名未定,待人类提供
- 云服务器 / 安全组:仅放行 80/443(+ SSH 限源),db/server 不暴露 —— ❓ 服务器未采购
- 本次发布内容与版本号 —— ❓ 待定题冻结后填
- TLS 证书就位(`certs/*.pem`)+ 仅 TLS1.2/1.3 + HSTS —— ❓ 证书未签发
- 密钥就位(JWT/DB/ANTHROPIC/备份口令,全新强随机,不复用 dev)—— ❓ 待生成
- `CORS_ORIGINS` 已收紧到真实来源,非留空 —— ❓ 待前端/后台域名定
- 健康检查通过 `curl https://<DOMAIN>/api/v1/health` —— ❓ 部署后验
- 每日加密备份与监控告警就位 —— ❓ cron/告警渠道待定
- 回滚方案:`docker compose ... down` + 上一版镜像 tag;数据卷不动 —— ✅ 机制已具备
- 双端商店包与表单(Data Safety / App Privacy)—— ❓ 上架阶段单独走

> 得到人类明确"通过"前,只做准备(模板/文档/本地验证),不触发任何真实部署或商店提交。
