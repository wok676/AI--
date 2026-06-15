# API 契约

> 状态:**TBD(待定题)**。由 `architect` 在前后端并行**之前**冻结。这是多 Agent 不打架的前提(见 `docs/WORKFLOW.md §2`)。

定题后本文件需冻结:

## 通用约定
- Base path:`/api`
- 鉴权:`Authorization: Bearer <accessToken>`
- 错误响应统一结构:`{ statusCode, code, messageKey, traceId, details? }`
- 登录返回结构:`{ accessToken, user: { id, username, role } }`

## 端点清单
| Method | Path | 鉴权 | 请求体 | 响应体 | 错误码 |
|---|---|---|---|---|---|
| _TBD_ | | | | | |

## 三处强耦合点(改任一处必须前后端同步)
1. messageKey —— 必须在 `locales/{zh,en}.json` 存在
2. 响应字段名/结构 —— 必须与 `app/src/api/types.ts` 逐字段对齐
3. JWT 返回结构 —— 见上
