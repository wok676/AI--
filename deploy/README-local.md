# 本地 Dev 起栈 + 手机端到端联调 Runbook

> 适用范围:**仅本机开发联调**(localhost,明文 http 可接受)。
> **不含**公网域名 / TLS / 证书 / Nginx —— 那是后续完整部署(`CLAUDE.md §3.3`),本文不涉及。
> 栈:`db`(PostgreSQL 16,带 healthcheck + 数据卷) + `server`(NestJS,依赖 db healthy 后启动,跑迁移再起服务)。

---

## 0. 前置

- Docker + Docker Compose v2 可用(已验证 Docker 29.5 / Compose v5)。
- 手机已安装 Flutter debug APK(默认指向 `http://localhost:3000/api`)。
- 工作目录为仓库根 `d:\TestAI`,以下命令均在仓库根执行。

---

## 1. 填写 `deploy/.env`(密钥只在本机,绝不提交)

```bash
cp deploy/.env.example deploy/.env
```

然后编辑 `deploy/.env`,至少填好这几项(`.env` 已被 `.gitignore` 忽略):

| 变量 | 说明 |
|---|---|
| `POSTGRES_USER` / `POSTGRES_DB` | 本地库用户名/库名,默认 `testai` 即可 |
| `POSTGRES_PASSWORD` | 本地库口令,填任意强随机串(例:`openssl rand -hex 16`) |
| `JWT_ACCESS_SECRET` | **必填强随机值**(例:`openssl rand -base64 48`),否则签发的 token 不安全 |
| `ANTHROPIC_API_KEY` | **Claude 识别密钥**。**缺它则仅 `/recognition` 食物识别端点不可用**;注册/登录/记餐/汇总/目标等其余功能照常 |

> `DATABASE_URL`(容器内)由 compose 用 `POSTGRES_*` 三项自动拼成 `postgresql://USER:PASS@db:5432/DB`,**无需手填**;`.env` 里的 `DATABASE_URL` 仅供宿主机侧工具(本机 psql / prisma studio)参考。

---

## 2. 一键起栈

```bash
docker compose -f deploy/docker-compose.dev.yml up -d --build
```

- 首次会构建镜像(多阶段:install→build→runtime,非 root 运行)。
- `server` 容器启动时,entrypoint 自动跑 `prisma migrate deploy`(幂等;已应用的迁移自动跳过),
  并用 `migrate diff` 做安全网校验,确保 **9 张业务表 + 全部枚举/索引/外键** 齐全。
- `server` 依赖 `db` healthy 后才启动;`db` 数据存放在命名卷 `testai-dev_pgdata`,**重跑不丢数据**。

> 端口 `3000` 必须空闲。若报 `port ... already in use`,说明本机另有进程(常见:手动 `npm start` 起的 node)占用了 3000,先停掉它再起栈(本栈与外部进程二选一占用 3000)。

---

## 3. 验证健康检查

```bash
curl http://localhost:3000/api/v1/health
# 期望:{"status":"ok","time":"...."}
```

也可看容器健康状态与日志:

```bash
docker compose -f deploy/docker-compose.dev.yml ps
docker compose -f deploy/docker-compose.dev.yml logs -f server
```

确认 9 张表都在:

```bash
docker compose -f deploy/docker-compose.dev.yml exec db \
  psql -U testai -d testai -c "\dt"
# 期望看到:User / AuthIdentity / RefreshToken / Profile / MealEntry /
#           FoodItem / DailyGoal / RecognitionUsage / RecognitionAudit(+ _prisma_migrations）
```

---

## 4. 手机连本机后端(两种方式,二选一)

### 方式 ① 真机 USB(推荐,APK 无需重打)

APK 默认就指向 `http://localhost:3000/api`。用 `adb reverse` 把手机的 `localhost:3000` 转发到电脑的 `3000`:

```bash
adb devices            # 确认手机已连接且授权
adb reverse tcp:3000 tcp:3000
```

之后手机 App 直接走 `localhost:3000` 即命中本机后端。**每次重新插拔/重启 adb 需重跑 `adb reverse`**。

### 方式 ② Android 模拟器(需要重打 APK)

模拟器里 `localhost` 指向模拟器自身,宿主机要用特殊地址 `10.0.2.2`。重打 debug 包时注入基址:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
# 或 flutter build apk --debug --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

> 注意基址带 `/api` 前缀;后端完整前缀是 `/api/v1`,`v1` 由前端 api client 补齐(对齐 `docs/API.md §0`)。

---

## 5. 注册测试账号

App 内走注册流程,或直接命令行造一个(注册必须带同意标记,密码 ≥8 位含字母+数字):

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H 'Content-Type: application/json' -H 'Accept-Language: zh' \
  -d '{"email":"tester@example.com","password":"Abc12345","consentAccepted":true,"consentVersion":"1.0","locale":"zh"}'
# 返回 {accessToken, refreshToken, user:{id,username,role}}
```

登录:

```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"tester@example.com","password":"Abc12345"}'
```

---

## 6. 把某账号提成 ADMIN(管理后台/`/admin` 端点需要)

用上面注册的邮箱,直接改 `role`:

```bash
docker compose -f deploy/docker-compose.dev.yml exec db \
  psql -U testai -d testai \
  -c "UPDATE \"User\" SET role='ADMIN' WHERE email='tester@example.com';"
# 期望输出:UPDATE 1
```

校验:

```bash
docker compose -f deploy/docker-compose.dev.yml exec db \
  psql -U testai -d testai -tAc "SELECT email, role FROM \"User\" WHERE email='tester@example.com';"
# 期望:tester@example.com|ADMIN
```

> 改完角色后该用户需 **重新登录**(或刷新 token),新签发的 access token 才带 `role=ADMIN`。

---

## 7. 停栈 / 清理

```bash
# 停止并删除容器,保留数据卷(下次起栈数据还在)
docker compose -f deploy/docker-compose.dev.yml down

# 连数据一起清空(谨慎:删库)
docker compose -f deploy/docker-compose.dev.yml down -v
```

---

## 8. 常见问题

- **`port 3000 already in use`**:本机有别的进程占用 3000(常见为手动起的 node dev server)。停掉它,或临时改 compose 里 server 的 `ports` 为 `3001:3000` 联调(改了就用方式①时 `adb reverse tcp:3000 tcp:3001`,模拟器用 `10.0.2.2:3001`)。
- **识别端点报错/不可用**:多半是 `deploy/.env` 的 `ANTHROPIC_API_KEY` 没填。其余功能不受影响。
- **手机连不上后端**:真机确认 `adb reverse` 已执行;模拟器确认用了 `10.0.2.2` 且 APK 是带 `--dart-define` 重打的那个;确认 `curl http://localhost:3000/api/v1/health` 在电脑上本身正常。
- **报错信息是英文而非中文**:请求带上 `Accept-Language: zh`(后端按此渲染 messageKey;语言包从仓库根 `locales/` 只读挂载进容器)。
