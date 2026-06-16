# TestAI · server (NestJS)

AI 饮食热量记录后端。本轮交付:**鉴权域(T2)** + 共享语言包(T1,见仓库根 `/locales`)。
契约基准:`docs/API.md`(FROZEN)、`docs/DB-Schema.md`(FROZEN)、`docs/PRD.md`。上位法 `CLAUDE.md`。

## 已实现端点(鉴权域,API.md §3)

| Method | Path | 鉴权 | 说明 |
|---|---|---|---|
| POST | `/api/v1/auth/register` | Guest | 邮箱注册(后端二次校验 consentAccepted + 密码强度) |
| POST | `/api/v1/auth/login` | Guest | 邮箱登录(凭证错误归一,不暴露存在性) |
| POST | `/api/v1/auth/apple` | Guest | Sign in with Apple(验签 identityToken) |
| POST | `/api/v1/auth/refresh` | Guest | 刷新(refreshToken 轮换 + 旧 token 吊销) |
| POST | `/api/v1/auth/logout` | User | 登出(吊销 refreshToken) |
| POST | `/api/v1/auth/forgot-password` | Guest | 发起重置(恒 ok,不暴露邮箱) |
| POST | `/api/v1/auth/change-password` | User | 改密 + 吊销其它会话 |
| DELETE | `/api/v1/account` | User | **账号注销 · 单事务彻底擦除** |
| GET | `/api/v1/health` | Guest | 健康检查 |

accessToken JWT 15min;refreshToken 不透明串、服务端只存 sha256、30d。密码 **argon2id**。

## 安全与合规要点

- 全局 `JwtAuthGuard`(默认需 Bearer,`@Public` 放行)+ `RolesGuard`(纵向 RBAC)+ 横向归属基础设施 `ownedBy/assertOwned`(越权归一 404)。
- 全局异常过滤器统一 `{ statusCode, code, messageKey, traceId, details }`,**绝不泄露堆栈**;按 `Accept-Language` 渲染、回退 en。
- `ValidationPipe` whitelist + forbidNonWhitelisted;Helmet;CORS 白名单;全局限流。
- 日志脱敏:不打印密码/token/原始邮箱(邮箱仅打掩码 `a***@domain`)。
- 零硬编码密钥:全部走 `.env`(样板见 `.env.example`),生产强制校验 JWT 密钥强度。

## 本地开发(数据库)

契约基准 schema 是 **PostgreSQL**:`prisma/schema.prisma`。
本地无 Postgres 时,用 SQLite 跑通迁移与测试(`CLAUDE.md §3.2` 允许):

```bash
npm install
npm run prisma:generate            # 生成 Postgres 客户端(生产/CI 默认)

# —— 本地 SQLite 开发/测试(可选)——
node scripts/gen-sqlite-schema.cjs # 由 Postgres schema 降级出 SQLite 版(enum→String)
DATABASE_URL="file:./dev.db" npx prisma migrate dev --schema prisma/schema.sqlite.prisma
DATABASE_URL="file:./dev.db" npx prisma generate --schema prisma/schema.sqlite.prisma
DATABASE_URL="file:./dev.db" npm test
```

> `prisma/schema.sqlite.prisma`、`prisma/migrations/`、`dev.db` 均为本地产物,已 `.gitignore`,不入库。
> 正式 PostgreSQL 迁移由 devops 据 `prisma/schema.prisma` 生成。

## 质量门禁

```bash
npm run typecheck   # tsc --noEmit
npm run lint        # eslint(禁 any)
npm test            # jest(需先备好 DATABASE_URL 指向 SQLite/Postgres)
```
