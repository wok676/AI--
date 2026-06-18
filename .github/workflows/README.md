# CI / CD 工作流

> 对照宪法 §13(Definition of Done)与 §6(密钥安全)。两条流水线分层:
> **per-PR 快速门禁** 与 **发布前识别闭环 e2e**。

## `ci.yml` — 每次 push(main)/ PR 的快速门禁

并行 4 个 Job,均**不需真机、不需密钥**:

| Job | 内容 |
|---|---|
| `server` | postgres:16 服务 → `npm ci` → `prisma migrate deploy` → `lint` → `typecheck` → `test`(含纵向/横向鉴权用例,需真 DB)→ `build` |
| `admin` | `npm ci` → `lint` → `typecheck` → `build` |
| `app` | `flutter analyze` → `flutter test test/`(单元/组件;**不含** `integration_test/`) |
| `secret-scan` | gitleaks 扫描,杜绝密钥/明文入库 |

> `app` 暂未做 `dart format` 强制门禁:现有代码尚未全量格式化(约 39/62 文件),
> 需先一次性 `dart format` 后再加 `--set-exit-if-changed`,以免首日即红。

## `e2e-android.yml` — 识别闭环端到端(手动 / 每日)

真 Android 模拟器 + 真后端 + **真实 AI 识别**,跑
`integration_test/recognition_smoke_test.dart`:注册→记一餐→文字→识别→确认→保存→注销自清理。

- **触发**:`workflow_dispatch`(手动)或每日定时(UTC 18:07)。
- **为何不进 per-PR**:真实调用 AI 有成本、延迟波动、需密钥——作发布前回归闸更合适。
- **必需 Secrets**(Settings → Secrets and variables → Actions):
  - `ANTHROPIC_API_KEY` — 识别密钥(中转站或官方)
  - `ANTHROPIC_BASE_URL` — Anthropic 兼容网关(如 `https://ai.deepthink.works`)
  - `ANTHROPIC_MODEL` — 可选,默认 `claude-opus-4-8`
- 缺 `ANTHROPIC_API_KEY` 时该工作流**快速失败并明确报错**,不静默跳过。

> 后端侧 `ANTHROPIC_TIMEOUT_MS` 在 e2e 中放宽到 60s;客户端识别接收超时也已放宽到 60s
> ([app/lib/config/app_config.dart](../../app/lib/config/app_config.dart)),与 AI 延迟波动匹配。
