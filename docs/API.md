# API 契约 · AI 饮食热量记录 v1

> 状态:**已冻结(FROZEN,2026-06-16)** —— 由 `architect` 在前后端并行**之前**冻结。多 Agent 不打架的前提(`docs/WORKFLOW.md §2`)。
> 上位法 `CLAUDE.md §5/§6/§7`。后端 NestJS 据此实现并出 OpenAPI/Swagger;前端 Flutter 据此写 `app/lib/api/` 与 mock。
> 契约冻结后:前端对 mock 写,后端对 schema 写,各自独立推进;改任一强耦合点须前后端同步。

---

## 0. 通用约定

- **Base path**:`/api`,版本前缀 `/api/v1`(完整:`/api/v1/...`)。
- **传输**:全链路 HTTPS/TLS(§5)。
- **鉴权头**:`Authorization: Bearer <accessToken>`(无状态 JWT)。
- **内容类型**:`application/json`(图片识别用 `multipart/form-data`,见 §4)。
- **国际化**:请求头 `Accept-Language: <locale>`(12 种之一);后端报错按此渲染 `messageKey`,落在 12 种之外回退 `en`(§7)。
- **链路追踪**:每响应含 `traceId`(日志关联,排障用,不含 PII)。

### 0.1 统一成功响应
业务数据**直接返回 DTO**(不强制包一层 envelope),便于前端类型对齐。分页用 `{ items, total, page, pageSize }`。

### 0.2 统一错误响应(§5 全局异常过滤器)
```jsonc
{
  "statusCode": 401,            // HTTP 状态
  "code": "AUTH_INVALID_CREDENTIALS", // 机器可读业务码(SCREAMING_SNAKE)
  "messageKey": "auth.error.invalidCredentials", // i18n key,前端 t() 渲染
  "traceId": "req_01HXXX...",   // 链路 ID
  "details": null               // 可选:校验失败时的字段级信息(脱敏)
}
```
> **绝不返回堆栈**(§5)。失败统一 401/403 + i18n,不暴露资源是否存在(§6)。

### 0.3 错误码 ↔ messageKey ↔ HTTP 对照表(强耦合点①)

| code | messageKey | HTTP | 场景 |
|---|---|---|---|
| `VALIDATION_FAILED` | `common.error.generic`(字段级用 `details`) | 400 | 入参校验失败(ValidationPipe whitelist) |
| `AUTH_INVALID_CREDENTIALS` | `auth.error.invalidCredentials` | 401 | 邮箱/密码错误 |
| `AUTH_UNAUTHORIZED` | `errors.unauthorized`(token 失效) | 401 | 无/失效 token |
| `AUTH_FORBIDDEN` | `errors.forbidden` | 403 | 纵向/横向鉴权不通过 |
| `AUTH_CONSENT_REQUIRED` | `auth.consent.required` | 400 | 注册未带同意标记 |
| `AUTH_EMAIL_TAKEN` | `auth.email.invalid`(归一提示,不暴露已注册) | 409 | 邮箱已注册(措辞不暴露存在性) |
| `AUTH_WEAK_PASSWORD` | `auth.password.weak` | 400 | 密码强度不足 |
| `AUTH_EMAIL_INVALID` | `auth.email.invalid` | 400 | 邮箱格式错误 |
| `RECOGNIZE_FAILED` | `recognize.error.failed` | 422 | AI 无法识别/解析 |
| `RECOGNIZE_LIMIT_REACHED` | `recognize.limit.reached` | 429 | 当日识别次数达上限 |
| `RESOURCE_NOT_FOUND` | `errors.notFound` | 404 | 资源不存在或非本人(归一,不暴露存在性) |
| `TIMEOUT` | `common.error.timeout` | 504 | 上游(Claude)超时 |
| `NETWORK_ERROR` | `common.error.network` | 503 | 上游不可用 |
| `INTERNAL_ERROR` | `common.error.generic` | 500 | 兜底 |

> **新增 messageKey 须先加进 `locales/*.json`(12 个 locale,en 为基准)再用。** 下列 key 在 PRD §6 已登记或需补登:`auth.error.invalidCredentials`、`auth.consent.required`、`auth.password.weak`、`auth.email.invalid`、`recognize.error.failed`、`recognize.limit.reached`、`common.error.generic/network/timeout`。`errors.unauthorized/forbidden/notFound` 已在现有 `locales/en.json` 存在。

---

## 1. JWT 结构(强耦合点③ · 不可改)

登录/注册/Apple 登录/刷新 成功统一返回:
```jsonc
{
  "accessToken": "<JWT, 15min>",
  "refreshToken": "<opaque, 30d>",   // 客户端存 flutter_secure_storage,禁明文
  "user": {
    "id": "ckuser...",
    "username": "alice",
    "role": "USER"                   // USER | ADMIN
  }
}
```
- accessToken JWT payload:`{ sub: user.id, role, iat, exp }`(15 分钟)。
- refreshToken 不透明字符串,服务端存 sha256 哈希可吊销(见 DB §4)。
- **前端共享类型** `app/lib/api/types.dart` 的 `AuthSession` / `AuthUser` 必须与此逐字段对齐(强耦合点②)。

---

## 2. 鉴权模型(RBAC + 横向归属)

- **纵向**:`@Roles(USER)` / `@Roles(ADMIN)` 守卫;管理后台端点仅 ADMIN。
- **横向**:所有业务查询/写入强制 `where { id, ownerId: req.user.id }`;不归属本人 → 返回 `RESOURCE_NOT_FOUND`(404,不暴露存在性),非 403。
- **公开端点(Guest)**:`POST /auth/register`、`POST /auth/login`、`POST /auth/apple`、`POST /auth/refresh`、`POST /auth/forgot-password`、健康检查。其余均需 Bearer。

---

## 3. 端点清单总览

| # | Method | Path | 鉴权 | 说明 | PRD |
|---|---|---|---|---|---|
| 1 | POST | `/api/v1/auth/register` | Guest | 邮箱密码注册(须带同意标记) | A1 |
| 2 | POST | `/api/v1/auth/login` | Guest | 邮箱密码登录 | A2 |
| 3 | POST | `/api/v1/auth/apple` | Guest | Sign in with Apple | A4 |
| 4 | POST | `/api/v1/auth/refresh` | Guest(带 refreshToken) | 刷新 access | — |
| 5 | POST | `/api/v1/auth/logout` | User | 登出(吊销 refresh) | A3 |
| 6 | POST | `/api/v1/auth/forgot-password` | Guest | 发起重置(Should) | A6 |
| 7 | POST | `/api/v1/auth/change-password` | User | 修改密码(Should) | A9 |
| 8 | DELETE | `/api/v1/account` | User | **账号注销·彻底擦除** | A8 |
| 9 | GET | `/api/v1/me` | User | 当前用户 + profile | C1 |
| 10 | PATCH | `/api/v1/me` | User | 更新资料/偏好/locale/单位 | C1/C2/C6 |
| 11 | POST | `/api/v1/recognition` | User | **AI 食物识别(图/文)** | F1/F2/F3 |
| 12 | POST | `/api/v1/meals` | User | 保存一餐(确认后入库) | F5/F7 |
| 13 | GET | `/api/v1/meals` | User | 按日期列餐(日视图) | S2 |
| 14 | GET | `/api/v1/meals/:id` | User | 餐次详情 | S2 |
| 15 | PATCH | `/api/v1/meals/:id` | User | 编辑餐次/条目 | S2/F5 |
| 16 | DELETE | `/api/v1/meals/:id` | User | 删除餐次 | S2 |
| 17 | GET | `/api/v1/summary/daily` | User | 每日汇总(进度环) | S1 |
| 18 | GET | `/api/v1/summary/trend` | User | 近 N 天趋势 | S5 |
| 19 | GET | `/api/v1/goal` | User | 当前生效目标 | S3 |
| 20 | PUT | `/api/v1/goal` | User | 设/改每日目标 | S3 |
| 21 | POST | `/api/v1/goal/estimate` | User | Mifflin-St Jeor 估算(纯计算) | S4 |
| 22 | GET | `/api/v1/health` | Guest | 健康检查 | §8 部署 |
| A | GET | `/api/v1/admin/users` | Admin | 用户列表(脱敏聚合) | §2.6 |
| A | PATCH | `/api/v1/admin/users/:id` | Admin | 封禁/解封 | §2.6 |

> 管理后台仅 2 个最小端点示意,详细运营统计端点由 backend 在 Admin 模块内扩展,**严禁返回原图/餐食明细等敏感隐私**(§2.6 最小可见)。

---

## 4. 端点详细契约

### 4.1 POST /auth/register
请求:
```jsonc
{ "email": "a@b.com", "password": "Abc12345", "consentAccepted": true, "consentVersion": "1.0", "locale": "en" }
```
- `consentAccepted` 必须为 `true`,否则 `AUTH_CONSENT_REQUIRED`(§4.1 知情同意,后端二次校验,不信任前端置灰)。
- 密码强度:≥8 位含字母+数字,否则 `AUTH_WEAK_PASSWORD`。
- 响应:**JWT 结构**(§1)。后端落 `consentAcceptedAt/consentVersion`。

### 4.2 POST /auth/login
请求:`{ "email": "a@b.com", "password": "..." }`
响应:JWT 结构。失败 `AUTH_INVALID_CREDENTIALS`(不区分邮箱不存在/密码错)。

### 4.3 POST /auth/apple
请求:`{ "identityToken": "<Apple JWT>", "authorizationCode": "...", "fullName": "...?", "locale": "en" }`
- 后端校验 Apple identityToken(验签 + aud + nonce),取 `sub`;首次登录创建 User + AuthIdentity(APPLE),回写 username(取 fullName 或 email 前缀或匿名)。
- Apple 私密中继邮箱:`email` 可空,以 `sub` 为主键身份。
- 响应:JWT 结构。

### 4.4 POST /auth/refresh
请求:`{ "refreshToken": "..." }`
响应:JWT 结构(轮换 refreshToken,旧的吊销)。失效 → `AUTH_UNAUTHORIZED`。

### 4.5 POST /auth/logout
请求:`{ "refreshToken": "..." }`(或从 Bearer 关联)。吊销该 refreshToken。响应:`{ "ok": true }`。

### 4.6 POST /auth/forgot-password(Should)
请求:`{ "email": "..." }`。响应恒 `{ "ok": true }`(不暴露邮箱是否注册)。发送重置邮件。

### 4.7 POST /auth/change-password(Should)
请求:`{ "currentPassword": "...", "newPassword": "..." }`。响应:`{ "ok": true }`,吊销其它 refreshToken。

### 4.8 DELETE /account(账号注销 · 彻底擦除 · 红线)
请求:`{ "password": "..." }`(邮箱用户须二次验证;Apple 用户用 re-auth token 或近期会话校验)。
- 后端单事务执行 DB §10 级联策略:revoke Apple 授权 → Cascade 删全部业务数据 → RecognitionAudit `ownerId=NULL` 去标识 → 删 User 行。
- 响应:`{ "ok": true, "messageKey": "account.delete.success" }`。
- 客户端收到后清 `flutter_secure_storage` + 本地缓存,回登录页。
- **网页端注销通道**(Apple 要求,PRD §4.2):同一 `DELETE /account` 由公网网页前端(身份验证后)调用;URL 收录商店元数据,由 `aso-operator`/`devops` 落地。

### 4.9 GET /me · PATCH /me
GET 响应:
```jsonc
{
  "id": "...", "email": "a@b.com", "username": "alice", "role": "USER", "plan": "FREE",
  "avatarUrl": null, "locale": "en", "unitEnergy": "kcal", "unitMass": "g", "notifyEnabled": false,
  "profile": { "sex": "UNSPECIFIED", "birthYear": null, "heightCm": null, "weightKg": null,
               "activityLevel": null, "goalType": null }
}
```
PATCH 请求(任意子集):`{ "username"?, "avatarUrl"?, "locale"?, "unitEnergy"?, "unitMass"?, "notifyEnabled"?, "profile"?: { "sex"?, "birthYear"?, "heightCm"?, "weightKg"?, "activityLevel"?, "goalType"? } }`。响应同 GET。

### 4.10 POST /recognition(AI 识别 · 核心)
两种请求形态:
- **图片**(F1/F2):`multipart/form-data`,字段 `image`(jpeg/png,后端限大小如 ≤8MB)+ `source`(`PHOTO`/`GALLERY`)。
- **文字**(F3):`application/json`,`{ "text": "一碗牛肉面 + 一个煎蛋", "source": "TEXT" }`。

后端流程(详见选型报告 §3):限流 upsert → 调用 Claude 视觉/文本 → 解析结构化 → **立即删临时原图** → 落 RecognitionAudit → 返回。

响应(**未入库**,供结果确认页编辑,F4/F5):
```jsonc
{
  "items": [
    { "name": "Beef noodles", "quantity": 1, "unit": "serving",
      "kcal": 520, "proteinG": 22, "carbsG": 68, "fatG": 16, "confidence": 0.82 },
    { "name": "Fried egg", "quantity": 1, "unit": "piece",
      "kcal": 90, "proteinG": 6, "carbsG": 1, "fatG": 7, "confidence": 0.91 }
  ],
  "suggestedMealType": "LUNCH",   // 按当前时间智能推荐(F7)
  "disclaimerKey": "recognize.disclaimer"  // 前端固定展示免责声明(F6)
}
```
错误:无法识别 `RECOGNIZE_FAILED`(422,前端走兜底手动添加 F8);超限 `RECOGNIZE_LIMIT_REACHED`(429);超时 `TIMEOUT`(504)。

> **原图最小化留存**:响应**不含原图 URL**;后端不长期保存原图(PRD §4.7)。

### 4.11 POST /meals(保存一餐)
请求(用户在确认页编辑后的最终结果):
```jsonc
{
  "mealType": "LUNCH",
  "consumedAt": "2026-06-16T12:30:00Z",
  "localDate": "2026-06-16",
  "source": "PHOTO",
  "note": null,
  "items": [
    { "name": "Beef noodles", "quantity": 1, "unit": "serving", "kcal": 520,
      "proteinG": 22, "carbsG": 68, "fatG": 16, "confidence": 0.82, "isManual": false },
    { "name": "Apple", "quantity": 1, "unit": "piece", "kcal": 95,
      "proteinG": 0, "carbsG": 25, "fatG": 0, "isManual": true }
  ]
}
```
- 后端写时计算 `totalKcal/totalProteinG/...`(items 求和),`ownerId = req.user.id`。
- 响应:完整 `MealEntry`(含 id、totals、items[].id、createdAt)。

### 4.12 GET /meals?date=YYYY-MM-DD(日视图)
响应:`{ "date": "2026-06-16", "entries": [ MealEntry... ] }`(按 mealType/consumedAt 排序)。

### 4.13 GET /meals/:id · PATCH /meals/:id · DELETE /meals/:id
- 全部强制横向 `where { id, ownerId }`;非本人 → `RESOURCE_NOT_FOUND`。
- PATCH 请求:可改 `mealType/consumedAt/note/items`(items 全量替换,重算 totals)。
- 响应:更新后 MealEntry / `{ "ok": true }`。

### 4.14 GET /summary/daily?date=YYYY-MM-DD(进度环)
响应:
```jsonc
{
  "date": "2026-06-16",
  "goalKcal": 2000,
  "consumedKcal": 1230,
  "remainingKcal": 770,
  "macros": { "proteinG": 65, "carbsG": 140, "fatG": 38 },
  "streakDays": 5   // Should;无 streak 时省略或 0
}
```

### 4.15 GET /summary/trend?days=7(趋势,Should)
响应:`{ "days": [ { "date": "...", "consumedKcal": 1800, "goalKcal": 2000, "proteinG":.., "carbsG":.., "fatG":.. }, ... ] }`(最多 7/30,Pro 才长)。

### 4.16 GET /goal · PUT /goal
GET 响应:`{ "targetKcal": 2000, "effectiveFrom": "2026-06-16", "source": "manual" }`(无则 `null`)。
PUT 请求:`{ "targetKcal": 2000, "effectiveFrom": "2026-06-16", "source": "manual" }`。upsert by `(ownerId, effectiveFrom)`。响应同 GET。

### 4.17 POST /goal/estimate(Mifflin-St Jeor,Should · 纯计算不落库)
请求:`{ "sex": "MALE", "birthYear": 1995, "heightCm": 175, "weightKg": 70, "activityLevel": "MODERATE", "goalType": "MAINTAIN" }`
响应:
```jsonc
{ "estimatedKcal": 2350, "disclaimerKey": "goal.disclaimer" }
```
> 措辞为"建议参考值",前端固定展示 `goal.disclaimer`(PRD §4.6 医疗红线)。用户"采用"才调 PUT /goal。

### 4.18 GET /health
响应:`{ "status": "ok", "time": "..." }`(部署健康检查,§8)。

---

## 5. 三处强耦合点(改任一处必须前后端同步)

1. **messageKey(i18n)**:见 §0.3 错误码表;新增 key 先入 `locales/*.json`(12 locale,en 基准),前端 `t(messageKey)` 渲染。
2. **API 响应字段名/结构**:本文件所有 DTO 即冻结结构;前端 `app/lib/api/types.dart` 逐字段对齐,后端 NestJS DTO/Swagger 一致。
3. **JWT 返回结构**:见 §1,`{ accessToken, refreshToken, user: { id, username, role } }`,不可改。

---

## 6. 合规技术约束(落到 API 层)

- 注册必带 `consentAccepted=true` 后端二次校验(§4.1)。
- `DELETE /account` 彻底级联删除(DB §10),不可逆(§4.2)。
- `/recognition` 不持久化原图、响应不含原图 URL(§4.7)。
- 所有报错走 `messageKey`,按 `Accept-Language` 渲染(§7)。
- 横向越权一律归一为 404,不暴露资源存在性(§6)。
