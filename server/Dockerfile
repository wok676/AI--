# ============================================================
# TestAI backend (NestJS + Prisma) · 多阶段构建
# 上位法 CLAUDE.md §3.3(Docker 多阶段)/ §6(非 root、最小权限)
# 目标:install → build → runtime,产物精简,非 root 运行。
# ============================================================

# ---------- Stage 1: deps (全量依赖,含 devDependencies 供构建) ----------
FROM node:22-bookworm-slim AS deps
WORKDIR /app
# 仅拷贝清单,最大化利用层缓存
COPY package.json package-lock.json ./
# prisma postinstall 需要 schema;先放进来
COPY prisma ./prisma
RUN npm ci

# ---------- Stage 2: build (编译 TS + 生成 Prisma Client) ----------
FROM node:22-bookworm-slim AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# 生成 Prisma Client(基于 canonical PostgreSQL schema.prisma)
RUN npx prisma generate
RUN npm run build
# 裁剪为仅生产依赖(node_modules 重装为 prod-only)
RUN npm prune --omit=dev

# ---------- Stage 3: runtime (精简运行时,非 root) ----------
FROM node:22-bookworm-slim AS runtime
ENV NODE_ENV=production
WORKDIR /app

# openssl 为 Prisma 引擎运行所需;curl 供 compose healthcheck 使用
RUN apt-get update \
  && apt-get install -y --no-install-recommends openssl curl \
  && rm -rf /var/lib/apt/lists/*

# 仅拷贝运行所需产物(prod node_modules + 编译结果 + prisma 资产 + 清单)
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma
COPY --from=build /app/package.json ./package.json
COPY docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

# 非 root 运行(node 镜像自带 uid/gid 1000 的 node 用户)
RUN chown -R node:node /app
USER node

EXPOSE 3000

# entrypoint 负责:迁移 DB(确保 9 表齐全)后再启动服务
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["node", "dist/main.js"]
