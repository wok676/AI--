# 数据库模型(Prisma)· AI 饮食热量记录 v1

> 状态:**已冻结(FROZEN,2026-06-16)** —— 由 `architect` 据 `docs/PRD.md`(FROZEN）设计。上位法 `CLAUDE.md §6`。
> 对应 Prisma schema 落在 `server/prisma/schema.prisma`,由 `backend-engineer` 据本文件实现,字段名/类型逐字段对齐。
> 数据库:**PostgreSQL**(本地开发可 SQLite,部署切 Postgres)。ORM:**Prisma**。

---

## 0. 设计总则(对照宪法)

- **横向归属(§6 横向鉴权)**:所有业务实体均带 `ownerId`,后端数据层强制 `where { id, ownerId: currentUser.id }`,杜绝改 ID 越权。
- **纵向 RBAC(§6 纵向鉴权)**:`User.role ∈ {USER, ADMIN}`,守卫校验角色→端点。
- **零明文密码(§1.4 / §6)**:`passwordHash` 存 argon2id 哈希,绝不存明文;Apple `sub` 等第三方标识不可作为密码。
- **食物原图最小化留存(PRD §4.7)**:**长期数据库不存原图二进制,也不存可公网访问的原图 URL**。原图仅在识别处理期间临时存在(对象存储/临时目录),识别完成即删除;DB 仅落结构化结果。详见 §6。
- **账号注销彻底销毁(PRD §4.2)**:级联**物理删除**用户全部业务数据 + 凭证;审计/聚合表仅保留**不可逆匿名**计数,不含任何可定位个人的字段。详见 §7。
- **商业化预留**:`User.plan ∈ {FREE, PRO}`,v1 恒为 `FREE`,仅占位不启用任何付费 UI。

---

## 1. 枚举(enum）

```prisma
enum Role {
  USER
  ADMIN
}

enum Plan {
  FREE
  PRO
}

enum AuthProvider {
  EMAIL   // 邮箱密码
  APPLE   // Sign in with Apple
  GOOGLE  // 预留(Should/后续),v1 不启用
}

enum MealType {
  BREAKFAST
  LUNCH
  DINNER
  SNACK
}

enum Sex {
  MALE
  FEMALE
  UNSPECIFIED
}

enum ActivityLevel {
  SEDENTARY      // 久坐
  LIGHT          // 轻度活动
  MODERATE       // 中度
  ACTIVE         // 活跃
  VERY_ACTIVE    // 非常活跃
}

enum GoalType {
  LOSE      // 减重
  MAINTAIN  // 维持
  GAIN      // 增重
}

enum AccountStatus {
  ACTIVE
  BANNED      // 管理员封禁
  // 注:注销不是状态,而是物理删除整行;不保留软删墓碑(PRD §4.2 不可逆)
}

enum RecognitionSource {
  PHOTO    // 拍照
  GALLERY  // 相册选图
  TEXT     // 文字描述
}
```

---

## 2. User(账号 · 鉴权主体)

| 字段 | 类型 | 约束/默认 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | 用户唯一 ID,即横向鉴权 `ownerId` 来源 |
| `email` | `String? @unique` | 可空(纯 Apple 私密中继可能无可用邮箱) | 邮箱(小写归一化存储) |
| `emailVerified` | `Boolean @default(false)` | | 邮箱验证(A7,Should) |
| `passwordHash` | `String?` | 可空(第三方登录无密码) | argon2id 哈希,**绝不明文** |
| `username` | `String` | not null | 显示昵称;JWT `user.username` 来源。注册默认取邮箱前缀 |
| `role` | `Role @default(USER)` | | 纵向 RBAC |
| `plan` | `Plan @default(FREE)` | | 商业化预留,v1 恒 FREE |
| `status` | `AccountStatus @default(ACTIVE)` | | 封禁判定 |
| `avatarUrl` | `String?` | | 头像(非敏感) |
| `locale` | `String @default("en")` | | 用户语言偏好(12 种之一) |
| `unitEnergy` | `String @default("kcal")` | `kcal`/`kj` | 单位偏好(C6) |
| `unitMass` | `String @default("g")` | `g`/`oz` | 单位偏好(C6) |
| `notifyEnabled` | `Boolean @default(false)` | | 通知总开关(权限按需,默认关) |
| `consentAcceptedAt` | `DateTime?` | | 知情同意时间戳(§4.1 留痕,合规证据) |
| `consentVersion` | `String?` | | 同意时的协议版本号 |
| `createdAt` | `DateTime @default(now())` | | |
| `updatedAt` | `DateTime @updatedAt` | | |

关系:`authIdentities AuthIdentity[]`、`profile Profile?`、`dailyGoals DailyGoal[]`、`mealEntries MealEntry[]`、`refreshTokens RefreshToken[]`、`recognitionUsages RecognitionUsage[]`。

索引:`@@index([email])`(unique 已建)、`@@index([status])`(管理后台筛选)。

> 敏感:`email` 在日志中必须脱敏(§6 日志脱敏)。`passwordHash` 永不出现在任何 API 响应。

---

## 3. AuthIdentity(第三方/多渠道登录身份)

> 把"登录渠道"与 User 解耦:同一 User 可绑定邮箱 + Apple。Apple 登录核心标识是 `providerUserId = Apple sub`。

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `userId` | `String` | FK→User, `onDelete: Cascade` | 归属 |
| `provider` | `AuthProvider` | | EMAIL/APPLE/GOOGLE |
| `providerUserId` | `String` | | Apple `sub` / Google `sub`;EMAIL 渠道存 email |
| `createdAt` | `DateTime @default(now())` | | |

约束:`@@unique([provider, providerUserId])`、`@@index([userId])`。

> 注销级联:`onDelete: Cascade` —— User 删除时该用户所有身份随删,等同撤销第三方关联(PRD §4.2「撤销关联授权」配合后端调用 Apple revoke 接口)。

---

## 4. RefreshToken(刷新令牌 · 安全存储)

> accessToken 短时效(JWT,无状态,不入库);refreshToken **入库可吊销**,登出/注销即删除。客户端 refreshToken 存 `flutter_secure_storage`(禁明文)。

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `userId` | `String` | FK→User, `onDelete: Cascade` | |
| `tokenHash` | `String @unique` | | refreshToken 的 sha256 哈希,**不存原文** |
| `expiresAt` | `DateTime` | | 过期时间(建议 30d) |
| `revokedAt` | `DateTime?` | | 主动吊销(登出) |
| `createdAt` | `DateTime @default(now())` | | |
| `userAgent` | `String?` | | 设备指纹(脱敏,排障用) |

索引:`@@index([userId])`、`@@index([expiresAt])`(定时清理过期)。

---

## 5. Profile(个人资料 · 目标估算输入)

> 1:1 于 User。身高体重等**仅用于本人热量估算**(PRD §4.6),纳入隐私政策;不收集疾病史等特殊健康数据。

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `userId` | `String @unique` | FK→User, `onDelete: Cascade` | 归属 |
| `sex` | `Sex @default(UNSPECIFIED)` | | |
| `birthYear` | `Int?` | | 仅存年份,降低敏感度(用于年龄推算) |
| `heightCm` | `Float?` | | 身高(统一存厘米,展示按 unitMass 换算) |
| `weightKg` | `Float?` | | 体重(统一存千克) |
| `activityLevel` | `ActivityLevel?` | | 活动量(S4 估算输入) |
| `goalType` | `GoalType?` | | 减/维持/增 |
| `updatedAt` | `DateTime @updatedAt` | | |

索引:`@@index([userId])`(unique 已建)。

---

## 6. MealEntry + FoodItem(核心业务:饮食记录)

### 6.1 MealEntry(一次"记录一餐",按餐归类)

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `ownerId` | `String` | FK→User, `onDelete: Cascade` | **横向归属字段**(§6) |
| `mealType` | `MealType` | | 早/午/晚/加餐(F7) |
| `consumedAt` | `DateTime` | | 进食时间(用户可改,默认 now) |
| `localDate` | `String` | not null | 用户本地日期 `YYYY-MM-DD`,**每日汇总聚合键**(避免时区漂移) |
| `source` | `RecognitionSource` | | PHOTO/GALLERY/TEXT(来源审计) |
| `note` | `String?` | | 备注 |
| `totalKcal` | `Float` | `@default(0)` | 冗余合计(由 items 求和,写时计算,读时免聚合) |
| `totalProteinG` | `Float` | `@default(0)` | 冗余合计 |
| `totalCarbsG` | `Float` | `@default(0)` | 冗余合计 |
| `totalFatG` | `Float` | `@default(0)` | 冗余合计 |
| `createdAt` | `DateTime @default(now())` | | |
| `updatedAt` | `DateTime @updatedAt` | | |

关系:`items FoodItem[]`(`onDelete: Cascade`)、`owner User`。

索引:`@@index([ownerId, localDate])`(日视图 / 每日汇总热点)、`@@index([ownerId, consumedAt])`(趋势)。

> **原图不落库**:MealEntry **无 imageUrl / imageBlob 字段**。原图仅在识别期间临时存在,识别后删除(PRD §4.7)。如未来需展示缩略图,属 Pro 版另议,v1 不存。

### 6.2 FoodItem(餐内单条食物项 · AI 识别结果或手动添加)

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `mealEntryId` | `String` | FK→MealEntry, `onDelete: Cascade` | 归属餐 |
| `ownerId` | `String` | FK→User, `onDelete: Cascade` | **冗余横向归属**(支持直接查/改单项时免 join 校验) |
| `name` | `String` | not null | 食物名(用户可改,F5) |
| `quantity` | `Float` | `@default(1)` | 份量数值(F5) |
| `unit` | `String @default("serving")` | | 单位:serving/g/ml/piece 等 |
| `kcal` | `Float` | `@default(0)` | 热量 |
| `proteinG` | `Float` | `@default(0)` | 蛋白(g) |
| `carbsG` | `Float` | `@default(0)` | 碳水(g) |
| `fatG` | `Float` | `@default(0)` | 脂肪(g) |
| `confidence` | `Float?` | 0..1 | AI 置信度;`< 0.5` 前端加低置信标记(F9) |
| `isManual` | `Boolean @default(false)` | | true=用户手动添加而非 AI 识别 |
| `createdAt` | `DateTime @default(now())` | | |

索引:`@@index([mealEntryId])`、`@@index([ownerId])`。

> 数值校验在后端 class-validator(非负、上限合理),避免脏数据污染汇总。

---

## 7. DailyGoal(每日热量目标)

> 每日目标可随时间变化,按 `localDate` 取"当日生效"目标;无当日记录时取最近一条。手动目标(S3,Must)或估算采用(S4,Should)都落这张表。

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `ownerId` | `String` | FK→User, `onDelete: Cascade` | **横向归属** |
| `targetKcal` | `Int` | not null | 每日目标热量 |
| `effectiveFrom` | `String` | not null | 生效起始本地日期 `YYYY-MM-DD` |
| `source` | `String @default("manual")` | `manual`/`estimated` | 手动 / Mifflin-St Jeor 估算采用 |
| `createdAt` | `DateTime @default(now())` | | |

索引:`@@unique([ownerId, effectiveFrom])`(同一天只一条生效目标,upsert)、`@@index([ownerId])`。

> 目标估算(Mifflin-St Jeor)是**纯计算端点**,不强制落库;用户"一键采用"才写 DailyGoal。

---

## 8. RecognitionUsage(每日识别次数限流 · 成本控制)

> 支撑 F10「每日识别次数软限制」。**v1 建议上限:30 次/自然日/用户**(理由见选型报告)。

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `ownerId` | `String` | FK→User, `onDelete: Cascade` | 归属 |
| `localDate` | `String` | not null | 计数自然日 `YYYY-MM-DD`(按用户时区) |
| `count` | `Int @default(0)` | | 当日已用识别次数 |
| `updatedAt` | `DateTime @updatedAt` | | |

约束:`@@unique([ownerId, localDate])`(原子 upsert + increment)、`@@index([ownerId, localDate])`。

> 限流实现:每次识别前在事务内 `upsert + increment`,超过上限返回 `recognize.limit.reached`。详见选型报告 §3 AI 编排。

---

## 9. RecognitionAudit(AI 调用审计 · 脱敏聚合,管理后台用)

> 支撑 PRD §2.6「AI 识别调用审计(用量/失败率)」。**严禁含原图、原图 URL、可定位个人的明细**;`ownerId` 可保留用于按用户限流复盘,但管理后台只读聚合视图(最小可见原则)。

| 字段 | 类型 | 约束 | 说明 |
|---|---|---|---|
| `id` | `String @id @default(cuid())` | PK | |
| `ownerId` | `String?` | FK→User, `onDelete: SetNull` | **注销时置 NULL**(去标识化保留聚合统计) |
| `source` | `RecognitionSource` | | |
| `success` | `Boolean` | | 识别是否成功 |
| `latencyMs` | `Int?` | | 调用耗时(质量监控) |
| `model` | `String?` | | 调用的 Claude 模型标识 |
| `errorCode` | `String?` | | 失败错误码(非 PII) |
| `createdAt` | `DateTime @default(now())` | | |

索引:`@@index([createdAt])`、`@@index([success])`。

> **注销策略例外**:本表用 `onDelete: SetNull` 而非 Cascade —— 注销后行仍在但 `ownerId=NULL`,**不可逆去标识化**,仅作聚合统计(DAU/调用量/失败率),不含任何可还原个人的字段,符合 PRD §4.2「不可逆匿名化」与 §2.6「不含可识别个人的原图明细」。这是全表中**唯一**不物理删除的例外,且已去标识。

---

## 10. 账号注销级联策略(PRD §4.2 红线汇总)

注销 `DELETE /api/account` 在**单事务**内执行:

| 表 | onDelete 行为 | 结果 |
|---|---|---|
| AuthIdentity | Cascade | 物理删除(+ 后端额外调用 Apple `revoke` 撤销授权) |
| RefreshToken | Cascade | 物理删除(凭证失效) |
| Profile | Cascade | 物理删除(身高体重等隐私) |
| MealEntry | Cascade | 物理删除(饮食记录) |
| FoodItem | Cascade | 物理删除(经 MealEntry + 直接 ownerId 双保险) |
| DailyGoal | Cascade | 物理删除 |
| RecognitionUsage | Cascade | 物理删除 |
| **RecognitionAudit** | **SetNull** | **ownerId 置 NULL,去标识保留聚合(唯一例外)** |
| User 行本身 | 事务末 delete | 物理删除 |
| 临时原图缓存 | 应用层主动清 | 注销前若有残留临时图一并删(正常识别后即删) |

> 后端实现要点:用 Prisma `$transaction`,先 revoke 第三方,再删依赖,最后删 User。删除后客户端清 `flutter_secure_storage` 凭证 + 本地缓存,回登录页。返回 `account.delete.success`。
> 物理删除即满足"彻底不可逆";RecognitionAudit 已去标识,不构成个人数据。

---

## 11. 索引与查询热点小结

| 查询场景 | 命中索引 |
|---|---|
| 登录(邮箱) | `User.email @unique` |
| Apple 登录(sub) | `AuthIdentity @@unique([provider, providerUserId])` |
| 每日汇总 / 日视图 | `MealEntry @@index([ownerId, localDate])` |
| 周趋势(7 天) | `MealEntry @@index([ownerId, consumedAt])` |
| 每日识别限流 | `RecognitionUsage @@unique([ownerId, localDate])` |
| 当日生效目标 | `DailyGoal @@unique([ownerId, effectiveFrom])` |
| 管理后台用户筛选 | `User @@index([status])` |

---

## 12. 与三处强耦合点的对齐

- **JWT 结构来源**:`{ accessToken, user: { id: User.id, username: User.username, role: User.role } }` —— 见 `docs/API.md §JWT`。
- **横向归属字段**:统一为 `ownerId`(MealEntry/FoodItem/DailyGoal/RecognitionUsage)+ `userId`(1:1/凭证类)。
- **messageKey**:DB 层校验失败 → 后端转 `common.error.*` / 业务 `*.error.*`,key 须在 `locales/*.json` 存在(见 API.md 错误码表)。
