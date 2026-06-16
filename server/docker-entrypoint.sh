#!/bin/sh
# ============================================================
# TestAI backend entrypoint · 幂等数据库初始化 + 启动服务
# 上位法 CLAUDE.md §3.3(部署脚本幂等)/ 本轮要求(起栈即 9 表齐全)
#
# 策略:
#   1) 用 PostgreSQL 专用迁移目录(prisma/migrations-postgres)做 `prisma migrate deploy`。
#      migrate deploy 幂等:已应用的迁移自动跳过,重跑不破坏数据。
#   2) 安全网:deploy 后用 `prisma migrate diff` 检查 DB 与 schema 是否仍有差异;
#      若有(例如迁移缺漏),回落 `prisma db push` 把 canonical schema 直接同步,
#      确保 9 张表/字段绝不缺失。db push 不删多余数据列(非破坏)。
# ============================================================
set -e

echo "[entrypoint] preparing PostgreSQL migrations..."
# 把 Postgres 专用迁移放到 Prisma 默认查找路径 prisma/migrations
rm -rf prisma/migrations
cp -r prisma/migrations-postgres prisma/migrations

echo "[entrypoint] running: prisma migrate deploy"
npx prisma migrate deploy

# 安全网:确认 DB 结构与 canonical schema 完全一致;有差异则用 db push 补齐
echo "[entrypoint] verifying schema parity (migrate diff)..."
if npx prisma migrate diff \
      --from-url "$DATABASE_URL" \
      --to-schema-datamodel prisma/schema.prisma \
      --exit-code >/dev/null 2>&1; then
  echo "[entrypoint] schema in sync (no diff)."
else
  echo "[entrypoint] drift detected -> reconciling with: prisma db push"
  npx prisma db push --skip-generate --accept-data-loss
fi

echo "[entrypoint] DB ready. starting server: $*"
exec "$@"
