// ============================================================
// TestAI · Prisma seed(本机测试数据,可重复跑,幂等)
// 上位法 CLAUDE.md §1.4 / §6:密码一律 argon2id 哈希,绝不存明文。
// 仅用于本地测试环境灌入可读数据,供 pgAdmin 查看 / App / 管理后台登录验证。
//
// 运行:在带完整依赖(含 ts-node / prisma client + linux argon2)的容器内
//   DATABASE_URL=postgresql://...@db:5432/testai npx ts-node prisma/seed.ts
//
// 幂等策略:
//   - User 以 email 唯一键 upsert;
//   - Profile / RecognitionUsage 以唯一键 upsert;
//   - DailyGoal 以 @@unique([ownerId, effectiveFrom]) upsert;
//   - MealEntry / FoodItem 无自然唯一键 → 先按 owner 清空再重建,保证重复跑不堆叠。
// ============================================================

import { PrismaClient, MealType, RecognitionSource, Role, Sex, ActivityLevel, GoalType } from '@prisma/client';
import * as argon2 from 'argon2';

const prisma = new PrismaClient();

// argon2id 参数对齐后端 password.service.ts(OWASP 推荐下限档)
const ARGON2_OPTS: argon2.Options = {
  type: argon2.argon2id,
  memoryCost: 19456,
  timeCost: 2,
  parallelism: 1,
};

function hash(plain: string): Promise<string> {
  return argon2.hash(plain, ARGON2_OPTS);
}

// 测试账号清单(明文密码仅本地测试用,已写入 README;库内只存哈希)
interface SeedUser {
  email: string;
  password: string;
  username: string;
  role: Role;
  locale: string;
  profile: { sex: Sex; birthYear: number; heightCm: number; weightKg: number; activityLevel: ActivityLevel; goalType: GoalType };
  targetKcal: number;
  recognitionCount: number;
}

const SEED_USERS: SeedUser[] = [
  {
    email: 'admin@testai.local',
    password: 'Admin12345',
    username: '管理员',
    role: 'ADMIN',
    locale: 'zh',
    profile: { sex: 'MALE', birthYear: 1990, heightCm: 178, weightKg: 75, activityLevel: 'MODERATE', goalType: 'MAINTAIN' },
    targetKcal: 2400,
    recognitionCount: 5,
  },
  {
    email: 'alice@testai.local',
    password: 'Alice12345',
    username: '小红',
    role: 'USER',
    locale: 'zh',
    profile: { sex: 'FEMALE', birthYear: 1995, heightCm: 165, weightKg: 58, activityLevel: 'LIGHT', goalType: 'LOSE' },
    targetKcal: 1600,
    recognitionCount: 12,
  },
  {
    email: 'bob@testai.local',
    password: 'Bob123456',
    username: '大壮',
    role: 'USER',
    locale: 'zh',
    profile: { sex: 'MALE', birthYear: 1988, heightCm: 182, weightKg: 88, activityLevel: 'ACTIVE', goalType: 'GAIN' },
    targetKcal: 2800,
    recognitionCount: 3,
  },
  {
    email: 'carol@testai.local',
    password: 'Carol12345',
    username: '小美',
    role: 'USER',
    locale: 'zh',
    profile: { sex: 'FEMALE', birthYear: 2000, heightCm: 170, weightKg: 62, activityLevel: 'SEDENTARY', goalType: 'MAINTAIN' },
    targetKcal: 1900,
    recognitionCount: 0,
  },
];

// 每个用户的三餐示例(食物项含宏量营养素;totals 由 items 求和写入冗余字段)
interface SeedFood {
  name: string;
  quantity: number;
  unit: string;
  kcal: number;
  proteinG: number;
  carbsG: number;
  fatG: number;
  confidence: number | null;
  isManual: boolean;
}
interface SeedMeal {
  mealType: MealType;
  source: RecognitionSource;
  note: string | null;
  hour: number;
  items: SeedFood[];
}

const SAMPLE_MEALS: SeedMeal[] = [
  {
    mealType: 'BREAKFAST',
    source: 'PHOTO',
    note: '中式早餐',
    hour: 8,
    items: [
      { name: '小米粥', quantity: 1, unit: '碗', kcal: 150, proteinG: 5, carbsG: 27, fatG: 3, confidence: 0.92, isManual: false },
      { name: '茶叶蛋', quantity: 1, unit: '个', kcal: 78, proteinG: 6.3, carbsG: 0.6, fatG: 5.3, confidence: 0.88, isManual: false },
      { name: '豆浆', quantity: 1, unit: '杯', kcal: 60, proteinG: 3.5, carbsG: 5, fatG: 1.9, confidence: null, isManual: true },
    ],
  },
  {
    mealType: 'LUNCH',
    source: 'GALLERY',
    note: null,
    hour: 12,
    items: [
      { name: '红烧肉', quantity: 150, unit: '克', kcal: 360, proteinG: 18, carbsG: 6, fatG: 30, confidence: 0.95, isManual: false },
      { name: '米饭', quantity: 200, unit: '克', kcal: 260, proteinG: 5.4, carbsG: 57, fatG: 0.6, confidence: 0.9, isManual: false },
      { name: '清炒西兰花', quantity: 100, unit: '克', kcal: 54, proteinG: 2.8, carbsG: 7, fatG: 2.4, confidence: 0.41, isManual: false },
    ],
  },
  {
    mealType: 'DINNER',
    source: 'TEXT',
    note: '清淡晚餐',
    hour: 19,
    items: [
      { name: '清蒸鲈鱼', quantity: 120, unit: '克', kcal: 130, proteinG: 24, carbsG: 0, fatG: 3.5, confidence: 0.87, isManual: false },
      { name: '凉拌黄瓜', quantity: 1, unit: '份', kcal: 60, proteinG: 1.5, carbsG: 5, fatG: 4, confidence: 0.6, isManual: false },
      { name: '紫菜蛋花汤', quantity: 1, unit: '碗', kcal: 70, proteinG: 4, carbsG: 4, fatG: 4, confidence: 0.55, isManual: false },
    ],
  },
  {
    mealType: 'SNACK',
    source: 'TEXT',
    note: '下午茶',
    hour: 16,
    items: [
      { name: '酸奶', quantity: 150, unit: '克', kcal: 130, proteinG: 15, carbsG: 8, fatG: 4, confidence: null, isManual: true },
      { name: '苹果', quantity: 1, unit: '个', kcal: 95, proteinG: 0.5, carbsG: 25, fatG: 0.3, confidence: 0.9, isManual: false },
    ],
  },
];

function localDateStr(d: Date): string {
  return d.toISOString().slice(0, 10);
}

function sum(items: SeedFood[], key: keyof Pick<SeedFood, 'kcal' | 'proteinG' | 'carbsG' | 'fatG'>): number {
  return Math.round(items.reduce((acc, it) => acc + (it[key] as number), 0) * 10) / 10;
}

async function main(): Promise<void> {
  const today = new Date();
  const todayStr = localDateStr(today);

  for (const u of SEED_USERS) {
    const passwordHash = await hash(u.password);

    // 1) User upsert(email 唯一键;重复跑刷新哈希/角色,保持幂等)
    const user = await prisma.user.upsert({
      where: { email: u.email },
      update: {
        passwordHash,
        username: u.username,
        role: u.role,
        locale: u.locale,
        status: 'ACTIVE',
        consentAcceptedAt: new Date(),
        consentVersion: '1.0',
      },
      create: {
        email: u.email,
        emailVerified: true,
        passwordHash,
        username: u.username,
        role: u.role,
        locale: u.locale,
        consentAcceptedAt: new Date(),
        consentVersion: '1.0',
      },
    });

    // 2) EMAIL 登录身份(provider+providerUserId 唯一)
    await prisma.authIdentity.upsert({
      where: { provider_providerUserId: { provider: 'EMAIL', providerUserId: u.email } },
      update: { userId: user.id },
      create: { userId: user.id, provider: 'EMAIL', providerUserId: u.email },
    });

    // 3) Profile(userId 唯一)
    await prisma.profile.upsert({
      where: { userId: user.id },
      update: { ...u.profile },
      create: { userId: user.id, ...u.profile },
    });

    // 4) DailyGoal(ownerId + effectiveFrom 唯一)
    await prisma.dailyGoal.upsert({
      where: { ownerId_effectiveFrom: { ownerId: user.id, effectiveFrom: todayStr } },
      update: { targetKcal: u.targetKcal, source: 'manual' },
      create: { ownerId: user.id, targetKcal: u.targetKcal, effectiveFrom: todayStr, source: 'manual' },
    });

    // 5) RecognitionUsage(ownerId + localDate 唯一)
    await prisma.recognitionUsage.upsert({
      where: { ownerId_localDate: { ownerId: user.id, localDate: todayStr } },
      update: { count: u.recognitionCount },
      create: { ownerId: user.id, localDate: todayStr, count: u.recognitionCount },
    });

    // 6) MealEntry + FoodItem:无自然唯一键 → 先删该用户旧餐(级联删 items)再重建,保证幂等不堆叠
    await prisma.mealEntry.deleteMany({ where: { ownerId: user.id } });

    // carol 故意不造餐记录,演示"空数据"用户(三态 UI 验证用)
    const mealsForUser = u.email === 'carol@testai.local' ? SAMPLE_MEALS.slice(0, 0) : SAMPLE_MEALS;

    for (const m of mealsForUser) {
      const consumedAt = new Date(today);
      consumedAt.setHours(m.hour, 0, 0, 0);
      await prisma.mealEntry.create({
        data: {
          ownerId: user.id,
          mealType: m.mealType,
          consumedAt,
          localDate: todayStr,
          source: m.source,
          note: m.note,
          totalKcal: sum(m.items, 'kcal'),
          totalProteinG: sum(m.items, 'proteinG'),
          totalCarbsG: sum(m.items, 'carbsG'),
          totalFatG: sum(m.items, 'fatG'),
          items: {
            create: m.items.map((it) => ({
              ownerId: user.id,
              name: it.name,
              quantity: it.quantity,
              unit: it.unit,
              kcal: it.kcal,
              proteinG: it.proteinG,
              carbsG: it.carbsG,
              fatG: it.fatG,
              confidence: it.confidence,
              isManual: it.isManual,
            })),
          },
        },
      });
    }

    // 7) 识别审计聚合(脱敏,管理后台用)— 仅给有识别用量的用户造几条
    if (u.recognitionCount > 0) {
      await prisma.recognitionAudit.deleteMany({ where: { ownerId: user.id } });
      await prisma.recognitionAudit.createMany({
        data: [
          { ownerId: user.id, source: 'PHOTO', success: true, latencyMs: 1200, model: 'claude-opus-4', createdAt: today },
          { ownerId: user.id, source: 'TEXT', success: false, latencyMs: 800, model: 'claude-opus-4', errorCode: 'recognize.parse.failed', createdAt: today },
        ],
      });
    }

    // eslint-disable-next-line no-console
    console.log(`[seed] upserted user ${u.email} (role=${u.role}, meals=${mealsForUser.length})`);
  }

  // 汇总打印(不含密码/哈希)
  const userCount = await prisma.user.count();
  const mealCount = await prisma.mealEntry.count();
  const foodCount = await prisma.foodItem.count();
  // eslint-disable-next-line no-console
  console.log(`[seed] done. users=${userCount} meals=${mealCount} foodItems=${foodCount}`);
}

main()
  .catch((e) => {
    // eslint-disable-next-line no-console
    console.error('[seed] failed:', e);
    process.exit(1);
  })
  .finally(() => {
    void prisma.$disconnect();
  });
