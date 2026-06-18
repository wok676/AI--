# CI / CD 工作流

> 对照宪法 §13(Definition of Done)与 §6(密钥安全)。两条流水线分层:
> **per-PR 快速门禁** 与 **发布前识别闭环 e2e**。

## `ci.yml` — 每次 push(main)/ PR 的快速门禁

并行 4 个 Job,均**不需真机、不需密钥**:

| Job | 内容 |
|---|---|
| `server` | postgres:16 服务 → `npm ci` → `prisma migrate deploy` → `lint` → `typecheck` → `test`(含纵向/横向鉴权用例,需真 DB)→ `build` |
| `admin` | `npm ci` → `lint` → `typecheck` → `build` |
| `app` | `dart format --set-exit-if-changed`(格式门禁)→ `flutter analyze` → `flutter test test/`(单元/组件;**不含** `integration_test/`) |
| `secret-scan` | gitleaks 扫描,杜绝密钥/明文入库 |

> 全量代码已一次性 `dart format`,格式门禁(`lib`/`test`/`integration_test`)已开启。

## `e2e-android.yml` — 识别闭环端到端(手动 / 每日)

真 Android 模拟器 + 真后端,跑 **`integration_test/` 全量**:
- `trivial_test`(纯渲染冒烟)
- `auth_smoke_test`(注册→登录→注销,**无需 AI**)
- `recognition_smoke_test`(注册→记一餐→文字→**真实 AI 识别**→确认→保存→注销自清理)

- **触发**:`workflow_dispatch`(手动)或每日定时(UTC 18:07)。
- **为何不进 per-PR**:真实调用 AI 有成本、延迟波动、需密钥——作发布前回归闸更合适。
- **必需 Secrets**(Settings → Secrets and variables → Actions):
  - `ANTHROPIC_API_KEY` — 识别密钥(中转站或官方)
  - `ANTHROPIC_BASE_URL` — Anthropic 兼容网关(如 `https://ai.deepthink.works`)
  - `ANTHROPIC_MODEL` — 可选,默认 `claude-opus-4-8`
- 缺 `ANTHROPIC_API_KEY` 时该工作流**快速失败并明确报错**,不静默跳过。

> 后端侧 `ANTHROPIC_TIMEOUT_MS` 在 e2e 中放宽到 60s;客户端识别接收超时也已放宽到 60s
> ([app/lib/config/app_config.dart](../../app/lib/config/app_config.dart)),与 AI 延迟波动匹配。

## `cd.yml` — 后端镜像持续交付(push main / 手动)

- `build-image`:多阶段构建 `server/Dockerfile` → 推送 **GHCR**
  (`ghcr.io/<repo>-server`,tag:`sha` / 分支名 / `latest`)。仅用 `GITHUB_TOKEN`,无需外部 Secret;
  构建本身即验证 Dockerfile 可用。`push: server/**` 或手动触发。
- `deploy`(可选,**仅手动** `workflow_dispatch` 且勾选 `deploy=true`):SSH 到生产主机
  `git pull` + `docker compose -f deploy/docker-compose.prod.yml up -d --build`。
  需 Secrets:`DEPLOY_SSH_HOST` / `DEPLOY_SSH_USER` / `DEPLOY_SSH_KEY` / `DEPLOY_APP_DIR`;
  缺失则该 Job 快速失败,不静默跳过。无服务器时忽略此 Job 即可,`build-image` 仍独立可用。
