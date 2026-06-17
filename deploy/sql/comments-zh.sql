-- ============================================================
-- TestAI · 数据库中文注释(表 + 字段)
-- 用途:在 pgAdmin / DBeaver 等图形工具里以中文显示每张表与字段含义。
-- 这些是 PostgreSQL COMMENT 元数据,不影响数据与结构,可重复执行(幂等)。
-- 表名/字段名为 Prisma 默认命名(PascalCase 表 / camelCase 列),故需双引号。
-- 应用:docker compose -f deploy/docker-compose.dev.yml exec -T db \
--          psql -U testai -d testai -f - < deploy/sql/comments-zh.sql
-- ============================================================

-- ---------------- User 用户账号(鉴权主体)----------------
COMMENT ON TABLE "User" IS '用户账号表:登录鉴权主体,一行一个注册用户';
COMMENT ON COLUMN "User"."id" IS '用户唯一ID(cuid)';
COMMENT ON COLUMN "User"."email" IS '邮箱(小写归一,唯一;纯Apple登录可能为空)';
COMMENT ON COLUMN "User"."emailVerified" IS '邮箱是否已验证';
COMMENT ON COLUMN "User"."passwordHash" IS '密码的argon2id哈希(绝不存明文;第三方登录无密码)';
COMMENT ON COLUMN "User"."username" IS '用户名/昵称';
COMMENT ON COLUMN "User"."role" IS '角色:USER普通 / ADMIN管理员(纵向鉴权)';
COMMENT ON COLUMN "User"."plan" IS '套餐:FREE免费 / PRO付费(为商业化预留)';
COMMENT ON COLUMN "User"."status" IS '账号状态:ACTIVE正常 / BANNED封禁(注销为物理删除,不在此体现)';
COMMENT ON COLUMN "User"."avatarUrl" IS '头像URL';
COMMENT ON COLUMN "User"."locale" IS '界面语言(如 zh / en)';
COMMENT ON COLUMN "User"."unitEnergy" IS '能量单位:kcal / kj';
COMMENT ON COLUMN "User"."unitMass" IS '质量单位:g / oz';
COMMENT ON COLUMN "User"."notifyEnabled" IS '是否开启通知';
COMMENT ON COLUMN "User"."consentAcceptedAt" IS '知情同意时间(隐私合规证据)';
COMMENT ON COLUMN "User"."consentVersion" IS '同意的隐私政策版本号';
COMMENT ON COLUMN "User"."createdAt" IS '创建时间';
COMMENT ON COLUMN "User"."updatedAt" IS '更新时间';

-- ---------------- AuthIdentity 登录身份(多渠道)----------------
COMMENT ON TABLE "AuthIdentity" IS '登录身份表:一个用户可绑定多种登录方式(邮箱/Apple/Google)';
COMMENT ON COLUMN "AuthIdentity"."id" IS '身份唯一ID';
COMMENT ON COLUMN "AuthIdentity"."userId" IS '所属用户ID(外键→User)';
COMMENT ON COLUMN "AuthIdentity"."provider" IS '登录渠道:EMAIL/APPLE/GOOGLE';
COMMENT ON COLUMN "AuthIdentity"."providerUserId" IS '渠道内用户标识(Apple/Google的sub;邮箱渠道存email)';
COMMENT ON COLUMN "AuthIdentity"."createdAt" IS '绑定时间';

-- ---------------- RefreshToken 刷新令牌(可吊销)----------------
COMMENT ON TABLE "RefreshToken" IS '刷新令牌表:用于续签登录态,可吊销(登出/注销)';
COMMENT ON COLUMN "RefreshToken"."id" IS '令牌记录唯一ID';
COMMENT ON COLUMN "RefreshToken"."userId" IS '所属用户ID(外键→User)';
COMMENT ON COLUMN "RefreshToken"."tokenHash" IS 'refreshToken的sha256哈希(不存原文)';
COMMENT ON COLUMN "RefreshToken"."expiresAt" IS '过期时间';
COMMENT ON COLUMN "RefreshToken"."revokedAt" IS '吊销时间(登出/注销时写入)';
COMMENT ON COLUMN "RefreshToken"."createdAt" IS '签发时间';
COMMENT ON COLUMN "RefreshToken"."userAgent" IS '设备指纹(脱敏)';

-- ---------------- Profile 个人资料(1:1)----------------
COMMENT ON TABLE "Profile" IS '个人资料表:与User一对一,用于热量目标估算';
COMMENT ON COLUMN "Profile"."id" IS '资料唯一ID';
COMMENT ON COLUMN "Profile"."userId" IS '所属用户ID(唯一,外键→User)';
COMMENT ON COLUMN "Profile"."sex" IS '性别:MALE/FEMALE/UNSPECIFIED';
COMMENT ON COLUMN "Profile"."birthYear" IS '出生年份(仅存年份降低敏感度)';
COMMENT ON COLUMN "Profile"."heightCm" IS '身高(厘米)';
COMMENT ON COLUMN "Profile"."weightKg" IS '体重(千克)';
COMMENT ON COLUMN "Profile"."activityLevel" IS '活动量:久坐/轻度/中度/活跃/非常活跃';
COMMENT ON COLUMN "Profile"."goalType" IS '目标:LOSE减重/MAINTAIN保持/GAIN增重';
COMMENT ON COLUMN "Profile"."updatedAt" IS '更新时间';

-- ---------------- MealEntry 餐次记录(核心)----------------
COMMENT ON TABLE "MealEntry" IS '餐次记录表:一条=一餐(早/午/晚/加餐),含该餐营养合计';
COMMENT ON COLUMN "MealEntry"."id" IS '餐次唯一ID';
COMMENT ON COLUMN "MealEntry"."ownerId" IS '归属用户ID(横向鉴权字段,外键→User)';
COMMENT ON COLUMN "MealEntry"."mealType" IS '餐类型:BREAKFAST早/LUNCH午/DINNER晚/SNACK加餐';
COMMENT ON COLUMN "MealEntry"."consumedAt" IS '进食时间';
COMMENT ON COLUMN "MealEntry"."localDate" IS '用户本地日期YYYY-MM-DD(每日汇总聚合键)';
COMMENT ON COLUMN "MealEntry"."source" IS '录入来源:PHOTO拍照/GALLERY相册/TEXT文字';
COMMENT ON COLUMN "MealEntry"."note" IS '备注';
COMMENT ON COLUMN "MealEntry"."totalKcal" IS '该餐总热量(千卡,各食物项求和冗余)';
COMMENT ON COLUMN "MealEntry"."totalProteinG" IS '该餐总蛋白质(克)';
COMMENT ON COLUMN "MealEntry"."totalCarbsG" IS '该餐总碳水(克)';
COMMENT ON COLUMN "MealEntry"."totalFatG" IS '该餐总脂肪(克)';
COMMENT ON COLUMN "MealEntry"."createdAt" IS '创建时间';
COMMENT ON COLUMN "MealEntry"."updatedAt" IS '更新时间';

-- ---------------- FoodItem 食物明细 ----------------
COMMENT ON TABLE "FoodItem" IS '食物明细表:一条=一餐里的一个食物项(如小米粥/红烧肉)';
COMMENT ON COLUMN "FoodItem"."id" IS '食物项唯一ID';
COMMENT ON COLUMN "FoodItem"."mealEntryId" IS '所属餐次ID(外键→MealEntry)';
COMMENT ON COLUMN "FoodItem"."ownerId" IS '归属用户ID(冗余横向鉴权,免join)';
COMMENT ON COLUMN "FoodItem"."name" IS '食物名称';
COMMENT ON COLUMN "FoodItem"."quantity" IS '数量';
COMMENT ON COLUMN "FoodItem"."unit" IS '单位(碗/个/克/份…)';
COMMENT ON COLUMN "FoodItem"."kcal" IS '热量(千卡)';
COMMENT ON COLUMN "FoodItem"."proteinG" IS '蛋白质(克)';
COMMENT ON COLUMN "FoodItem"."carbsG" IS '碳水化合物(克)';
COMMENT ON COLUMN "FoodItem"."fatG" IS '脂肪(克)';
COMMENT ON COLUMN "FoodItem"."confidence" IS 'AI识别置信度0~1(手动录入为空)';
COMMENT ON COLUMN "FoodItem"."isManual" IS '是否手动录入(true=人工,false=AI识别)';
COMMENT ON COLUMN "FoodItem"."createdAt" IS '创建时间';

-- ---------------- DailyGoal 每日目标 ----------------
COMMENT ON TABLE "DailyGoal" IS '每日热量目标表:每个用户某日起生效的目标热量';
COMMENT ON COLUMN "DailyGoal"."id" IS '目标唯一ID';
COMMENT ON COLUMN "DailyGoal"."ownerId" IS '归属用户ID(横向鉴权,外键→User)';
COMMENT ON COLUMN "DailyGoal"."targetKcal" IS '目标热量(千卡/天)';
COMMENT ON COLUMN "DailyGoal"."effectiveFrom" IS '生效起始本地日期YYYY-MM-DD';
COMMENT ON COLUMN "DailyGoal"."source" IS '来源:manual手动 / estimated公式估算';
COMMENT ON COLUMN "DailyGoal"."createdAt" IS '创建时间';

-- ---------------- RecognitionUsage 每日识别用量(限流)----------------
COMMENT ON TABLE "RecognitionUsage" IS '每日AI识别用量表:按自然日计数,用于限流(默认30次/天)';
COMMENT ON COLUMN "RecognitionUsage"."id" IS '记录唯一ID';
COMMENT ON COLUMN "RecognitionUsage"."ownerId" IS '归属用户ID(外键→User)';
COMMENT ON COLUMN "RecognitionUsage"."localDate" IS '计数自然日YYYY-MM-DD';
COMMENT ON COLUMN "RecognitionUsage"."count" IS '当日已用识别次数';
COMMENT ON COLUMN "RecognitionUsage"."updatedAt" IS '更新时间';

-- ---------------- RecognitionAudit AI调用审计(脱敏聚合)----------------
COMMENT ON TABLE "RecognitionAudit" IS 'AI识别调用审计表:脱敏聚合统计用(调用量/失败率);注销后ownerId置NULL去标识,是唯一不物理删除的例外';
COMMENT ON COLUMN "RecognitionAudit"."id" IS '审计唯一ID';
COMMENT ON COLUMN "RecognitionAudit"."ownerId" IS '归属用户ID(注销后置NULL去标识,外键→User)';
COMMENT ON COLUMN "RecognitionAudit"."source" IS '识别来源:PHOTO/GALLERY/TEXT';
COMMENT ON COLUMN "RecognitionAudit"."success" IS '是否识别成功';
COMMENT ON COLUMN "RecognitionAudit"."latencyMs" IS '耗时(毫秒)';
COMMENT ON COLUMN "RecognitionAudit"."model" IS '使用的AI模型';
COMMENT ON COLUMN "RecognitionAudit"."errorCode" IS '失败错误码(非个人隐私)';
COMMENT ON COLUMN "RecognitionAudit"."createdAt" IS '调用时间';
