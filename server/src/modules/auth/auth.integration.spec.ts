import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { PrismaClient } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { PasswordService } from './password.service';
import { TokenService } from './token.service';
import { AppleService } from './apple.service';
import { AuthService } from './auth.service';
import { Role } from '../../common/domain/enums';
import { AppException } from '../../common/errors/app.exception';

/**
 * 集成测试(SQLite dev.db):注册/登录/越权/注销级联物理删除。
 * 对照宪法 §6(鉴权/零明文)+ PRD §4.2(注销不可逆)。
 *
 * 运行前需:DATABASE_URL=file:./dev.db 且已 prisma migrate(SQLite dev schema)。
 */
const HAS_DB = !!process.env.DATABASE_URL;
const d = HAS_DB ? describe : describe.skip;

d('AuthService integration (auth + authz + account deletion cascade)', () => {
  let prisma: PrismaService;
  let auth: AuthService;

  const config = {
    get: (key: string): unknown => {
      const map: Record<string, unknown> = {
        'jwt.accessSecret': 'test-secret',
        'jwt.accessTtl': '15m',
        refreshTokenTtlDays: 30,
        'apple.audience': 'com.testai.app',
        'apple.issuer': 'https://appleid.apple.com',
      };
      return map[key];
    },
  } as unknown as ConfigService;

  beforeAll(async () => {
    prisma = new PrismaService();
    await prisma.$connect();
    const passwords = new PasswordService();
    const tokens = new TokenService(new JwtService({}), config, prisma);
    const apple = new AppleService(config);
    auth = new AuthService(prisma, passwords, tokens, apple);
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  beforeEach(async () => {
    // 清库(顺序无所谓,Cascade 由删 User 处理,但测试隔离直接全清)
    const c = prisma as unknown as PrismaClient;
    await c.recognitionAudit.deleteMany();
    await c.foodItem.deleteMany();
    await c.mealEntry.deleteMany();
    await c.dailyGoal.deleteMany();
    await c.recognitionUsage.deleteMany();
    await c.refreshToken.deleteMany();
    await c.profile.deleteMany();
    await c.authIdentity.deleteMany();
    await c.user.deleteMany();
  });

  const register = () =>
    auth.register({
      email: 'alice@example.com',
      password: 'Abc12345',
      consentAccepted: true,
      consentVersion: '1.0',
      locale: 'en',
    });

  it('register: rejects without consent (AUTH_CONSENT_REQUIRED)', async () => {
    await expect(
      auth.register({
        email: 'no-consent@example.com',
        password: 'Abc12345',
        consentAccepted: false,
        consentVersion: '1.0',
      }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_CONSENT_REQUIRED' });
  });

  it('register: rejects weak password', async () => {
    await expect(
      auth.register({
        email: 'weak@example.com',
        password: 'weak',
        consentAccepted: true,
        consentVersion: '1.0',
      }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_WEAK_PASSWORD' });
  });

  it('register: stores argon2id hash, never plaintext; returns JWT structure', async () => {
    const session = await register();
    expect(session.accessToken).toBeTruthy();
    expect(session.refreshToken).toBeTruthy();
    expect(session.user).toEqual({
      id: expect.any(String),
      username: 'alice',
      role: 'USER',
    });
    const c = prisma as unknown as PrismaClient;
    const row = await c.user.findUnique({ where: { id: session.user.id } });
    expect(row?.passwordHash).toBeTruthy();
    expect(row?.passwordHash).not.toContain('Abc12345');
    expect(row?.passwordHash?.startsWith('$argon2id$')).toBe(true);
    expect(row?.consentAcceptedAt).toBeTruthy();
  });

  it('login: wrong password → AUTH_INVALID_CREDENTIALS (no existence leak)', async () => {
    await register();
    await expect(
      auth.login({ email: 'alice@example.com', password: 'WrongPass1' }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_INVALID_CREDENTIALS' });
    // 不存在的邮箱也给同样错误码,不区分
    await expect(
      auth.login({ email: 'ghost@example.com', password: 'Abc12345' }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_INVALID_CREDENTIALS' });
  });

  it('refresh: rotates token; old refreshToken is revoked', async () => {
    const session = await register();
    const rotated = await auth.refresh(session.refreshToken);
    expect(rotated.refreshToken).not.toBe(session.refreshToken);
    // 旧 token 已吊销,再次 refresh 失败
    await expect(auth.refresh(session.refreshToken)).rejects.toMatchObject({
      errorKey: 'AUTH_UNAUTHORIZED',
    });
  });

  it('logout: revokes refreshToken', async () => {
    const session = await register();
    await auth.logout(session.refreshToken);
    await expect(auth.refresh(session.refreshToken)).rejects.toMatchObject({
      errorKey: 'AUTH_UNAUTHORIZED',
    });
  });

  it('deleteAccount: requires correct password (anti-misclick)', async () => {
    const session = await register();
    await expect(
      auth.deleteAccount({ id: session.user.id, role: Role.USER }, { password: 'WrongPass1' }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_INVALID_CREDENTIALS' });
  });

  it('deleteAccount: cascade physical-deletes all PII; audit is de-identified (ownerId=NULL)', async () => {
    const session = await register();
    const userId = session.user.id;
    const c = prisma as unknown as PrismaClient;

    // 制造关联业务数据 + 审计
    const meal = await c.mealEntry.create({
      data: {
        ownerId: userId,
        mealType: 'LUNCH',
        consumedAt: new Date(),
        localDate: '2026-06-16',
        source: 'PHOTO',
        items: { create: { ownerId: userId, name: 'Beef noodles', kcal: 520 } },
      },
    });
    await c.dailyGoal.create({
      data: { ownerId: userId, targetKcal: 2000, effectiveFrom: '2026-06-16' },
    });
    await c.recognitionUsage.create({
      data: { ownerId: userId, localDate: '2026-06-16', count: 3 },
    });
    await c.profile.create({ data: { userId, heightCm: 175, weightKg: 70 } });
    await c.recognitionAudit.create({
      data: { ownerId: userId, source: 'PHOTO', success: true },
    });

    // 执行注销
    const result = await auth.deleteAccount(
      { id: userId, role: Role.USER },
      { password: 'Abc12345' },
    );
    expect(result).toEqual({ ok: true, messageKey: 'account.delete.success' });

    // 全部 PII 物理删除
    expect(await c.user.findUnique({ where: { id: userId } })).toBeNull();
    expect(await c.authIdentity.count({ where: { userId } })).toBe(0);
    expect(await c.refreshToken.count({ where: { userId } })).toBe(0);
    expect(await c.profile.count({ where: { userId } })).toBe(0);
    expect(await c.mealEntry.count({ where: { ownerId: userId } })).toBe(0);
    expect(await c.foodItem.count({ where: { id: meal.id } })).toBe(0);
    expect(await c.foodItem.count({ where: { ownerId: userId } })).toBe(0);
    expect(await c.dailyGoal.count({ where: { ownerId: userId } })).toBe(0);
    expect(await c.recognitionUsage.count({ where: { ownerId: userId } })).toBe(0);

    // 审计行仍在,但 ownerId 去标识为 NULL(不可逆匿名化,唯一例外)
    const audits = await c.recognitionAudit.findMany();
    expect(audits.length).toBe(1);
    expect(audits[0].ownerId).toBeNull();

    // 注销后原账号无法登录
    await expect(
      auth.login({ email: 'alice@example.com', password: 'Abc12345' }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_INVALID_CREDENTIALS' });
  });

  it('horizontal authz: user A cannot reach user B meal via where{ownerId}', async () => {
    const a = await register();
    const b = await auth.register({
      email: 'bob@example.com',
      password: 'Abc12345',
      consentAccepted: true,
      consentVersion: '1.0',
    });
    const c = prisma as unknown as PrismaClient;
    const bMeal = await c.mealEntry.create({
      data: {
        ownerId: b.user.id,
        mealType: 'DINNER',
        consumedAt: new Date(),
        localDate: '2026-06-16',
        source: 'TEXT',
      },
    });
    // A 用自己的 ownerId 过滤查 B 的 meal → 查不到(归一 404 的数据层基础)
    const leaked = await c.mealEntry.findFirst({
      where: { id: bMeal.id, ownerId: a.user.id },
    });
    expect(leaked).toBeNull();
  });
});

// 静态引用以避免 lint 误报未使用
void AppException;
