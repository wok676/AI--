import { PrismaClient } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { MealsService } from './meals.service';
import { SummaryService } from '../summary/summary.service';
import { GoalService } from '../goal/goal.service';
import { Role, MealType, RecognitionSource } from '../../common/domain/enums';
import { CurrentUserContext } from '../../common/auth/auth.types';

/**
 * 集成测试(SQLite dev.db):meals CRUD 横向越权、summary 计算、注销后业务数据级联删除。
 * 对照宪法 §6(横向鉴权:改他人 id→404)+ PRD §4.2(注销不可逆)。
 *
 * 运行前需:DATABASE_URL=file:./prisma/dev.db 且已 prisma db push(SQLite dev schema)。
 */
const HAS_DB = !!process.env.DATABASE_URL;
const d = HAS_DB ? describe : describe.skip;

d('Meals/Summary integration (horizontal authz + summary + cascade)', () => {
  let prisma: PrismaService;
  let meals: MealsService;
  let summary: SummaryService;
  let goal: GoalService;
  let c: PrismaClient;

  const userA: CurrentUserContext = { id: '', role: Role.USER };
  const userB: CurrentUserContext = { id: '', role: Role.USER };

  beforeAll(async () => {
    prisma = new PrismaService();
    await prisma.$connect();
    c = prisma as unknown as PrismaClient;
    meals = new MealsService(prisma);
    goal = new GoalService(prisma);
    summary = new SummaryService(prisma, goal);
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  beforeEach(async () => {
    await c.recognitionAudit.deleteMany();
    await c.foodItem.deleteMany();
    await c.mealEntry.deleteMany();
    await c.dailyGoal.deleteMany();
    await c.recognitionUsage.deleteMany();
    await c.refreshToken.deleteMany();
    await c.profile.deleteMany();
    await c.authIdentity.deleteMany();
    await c.user.deleteMany();

    const a = await c.user.create({ data: { username: 'a', email: 'a@x.com' } });
    const b = await c.user.create({ data: { username: 'b', email: 'b@x.com' } });
    userA.id = a.id;
    userB.id = b.id;
  });

  const createMeal = (user: CurrentUserContext) =>
    meals.create(user, {
      mealType: MealType.LUNCH,
      consumedAt: '2026-06-16T12:30:00Z',
      localDate: '2026-06-16',
      source: RecognitionSource.PHOTO,
      items: [
        {
          name: 'Beef noodles',
          quantity: 1,
          unit: 'serving',
          kcal: 520,
          proteinG: 22,
          carbsG: 68,
          fatG: 16,
          confidence: 0.82,
          isManual: false,
        },
        {
          name: 'Apple',
          quantity: 1,
          unit: 'piece',
          kcal: 95,
          proteinG: 0,
          carbsG: 25,
          fatG: 0,
          isManual: true,
        },
      ],
    });

  it('create: computes totals from items; ownerId taken from auth ctx', async () => {
    const meal = await createMeal(userA);
    expect(meal.totalKcal).toBe(615); // 520 + 95
    expect(meal.totalProteinG).toBe(22);
    expect(meal.totalCarbsG).toBe(93);
    expect(meal.totalFatG).toBe(16);
    expect(meal.items).toHaveLength(2);
    const row = await c.mealEntry.findUnique({ where: { id: meal.id } });
    expect(row?.ownerId).toBe(userA.id);
  });

  it('horizontal authz: B cannot GET A meal → RESOURCE_NOT_FOUND (404, no existence leak)', async () => {
    const meal = await createMeal(userA);
    await expect(meals.getOne(userB, meal.id)).rejects.toMatchObject({
      errorKey: 'RESOURCE_NOT_FOUND',
    });
  });

  it('horizontal authz: B cannot PATCH A meal (id tampering) → 404', async () => {
    const meal = await createMeal(userA);
    await expect(meals.update(userB, meal.id, { mealType: MealType.DINNER })).rejects.toMatchObject(
      { errorKey: 'RESOURCE_NOT_FOUND' },
    );
    // A 的数据未被篡改
    const still = await c.mealEntry.findUnique({ where: { id: meal.id } });
    expect(still?.mealType).toBe('LUNCH');
  });

  it('horizontal authz: B cannot DELETE A meal → 404; A meal still exists', async () => {
    const meal = await createMeal(userA);
    await expect(meals.remove(userB, meal.id)).rejects.toMatchObject({
      errorKey: 'RESOURCE_NOT_FOUND',
    });
    expect(await c.mealEntry.count({ where: { id: meal.id } })).toBe(1);
  });

  it('update: items full-replace recomputes totals', async () => {
    const meal = await createMeal(userA);
    const updated = await meals.update(userA, meal.id, {
      items: [
        { name: 'Salad', quantity: 1, unit: 'bowl', kcal: 200, proteinG: 5, carbsG: 10, fatG: 12 },
      ],
    });
    expect(updated.totalKcal).toBe(200);
    expect(updated.items).toHaveLength(1);
    // 旧 items 已物理删除(全量替换)
    expect(await c.foodItem.count({ where: { mealEntryId: meal.id } })).toBe(1);
  });

  it('listByDate: only owner meals, scoped by localDate', async () => {
    await createMeal(userA);
    await createMeal(userB);
    const day = await meals.listByDate(userA, '2026-06-16');
    expect(day.entries).toHaveLength(1);
    expect(day.entries[0].totalKcal).toBe(615);
  });

  it('summary.daily: aggregates owner totals + compares goal (progress ring)', async () => {
    await createMeal(userA); // 615 kcal
    await goal.put(userA, { targetKcal: 2000, effectiveFrom: '2026-06-01' });
    const s = await summary.daily(userA, '2026-06-16');
    expect(s.consumedKcal).toBe(615);
    expect(s.goalKcal).toBe(2000);
    expect(s.remainingKcal).toBe(1385);
    expect(s.macros).toEqual({ proteinG: 22, carbsG: 93, fatG: 16 });
  });

  it('summary.daily: no goal → goalKcal/remaining null, still returns consumed', async () => {
    await createMeal(userA);
    const s = await summary.daily(userA, '2026-06-16');
    expect(s.goalKcal).toBeNull();
    expect(s.remainingKcal).toBeNull();
    expect(s.consumedKcal).toBe(615);
  });

  it('goal.getEffective: picks latest goal with effectiveFrom <= date', async () => {
    await goal.put(userA, { targetKcal: 1800, effectiveFrom: '2026-06-01' });
    await goal.put(userA, { targetKcal: 2200, effectiveFrom: '2026-06-10' });
    const onJun5 = await goal.getEffective(userA.id, '2026-06-05');
    const onJun16 = await goal.getEffective(userA.id, '2026-06-16');
    expect(onJun5?.targetKcal).toBe(1800);
    expect(onJun16?.targetKcal).toBe(2200);
  });

  it('cascade: deleting User physically removes meals/items/goals/usages (account deletion holds)', async () => {
    const meal = await createMeal(userA);
    await goal.put(userA, { targetKcal: 2000, effectiveFrom: '2026-06-16' });
    await c.recognitionUsage.create({
      data: { ownerId: userA.id, localDate: '2026-06-16', count: 3 },
    });
    await c.recognitionAudit.create({
      data: { ownerId: userA.id, source: 'PHOTO', success: true },
    });

    await c.user.delete({ where: { id: userA.id } });

    expect(await c.mealEntry.count({ where: { ownerId: userA.id } })).toBe(0);
    expect(await c.foodItem.count({ where: { mealEntryId: meal.id } })).toBe(0);
    expect(await c.foodItem.count({ where: { ownerId: userA.id } })).toBe(0);
    expect(await c.dailyGoal.count({ where: { ownerId: userA.id } })).toBe(0);
    expect(await c.recognitionUsage.count({ where: { ownerId: userA.id } })).toBe(0);
    // 审计去标识(SetNull),不物理删(唯一例外,DB §10)
    const audits = await c.recognitionAudit.findMany();
    expect(audits).toHaveLength(1);
    expect(audits[0].ownerId).toBeNull();
  });
});
