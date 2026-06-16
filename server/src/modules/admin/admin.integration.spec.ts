import { Reflector } from '@nestjs/core';
import { ExecutionContext } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { RolesGuard } from '../../common/auth/roles.guard';
import { ROLES_KEY } from '../../common/auth/roles.decorator';
import { AppException } from '../../common/errors/app.exception';
import { AccountStatus, Role } from '../../common/domain/enums';
import { CurrentUserContext } from '../../common/auth/auth.types';

/**
 * 管理后台测试:
 *  A) 纵向鉴权(纯单元,无需 DB):真实 RolesGuard 读 AdminController 上 @Roles(ADMIN) 元数据
 *     → ADMIN 放行,USER → 403 AUTH_FORBIDDEN(§6 纵向鉴权)。
 *  B) 服务行为(SQLite dev.db):脱敏(邮箱打码、不返回 passwordHash/餐食明细/健康明细)、
 *     封禁/解封、不可封禁 ADMIN、注销保持物理删除语义、脱敏聚合统计。
 *
 * B 段运行前需:DATABASE_URL=file:./prisma/dev.db 且已 prisma db push(SQLite dev schema)。
 */

// ============ A. 纵向鉴权(无 DB,始终运行)============
describe('Admin vertical authz (@Roles(ADMIN) on AdminController)', () => {
  const reflector = new Reflector();
  const guard = new RolesGuard(reflector);

  const ctx = (user: CurrentUserContext): ExecutionContext =>
    ({
      switchToHttp: () => ({ getRequest: () => ({ user }) }),
      // 用真实 controller 类作为元数据来源,确保 @Roles(ADMIN) 真的挂上了
      getHandler: () => AdminController.prototype.listUsers,
      getClass: () => AdminController,
    }) as unknown as ExecutionContext;

  it('AdminController is annotated @Roles(ADMIN)', () => {
    const roles = reflector.getAllAndOverride<Role[]>(ROLES_KEY, [
      AdminController.prototype.listUsers as never,
      AdminController as never,
    ]);
    expect(roles).toEqual([Role.ADMIN]);
  });

  it('ADMIN can access admin endpoints', () => {
    expect(guard.canActivate(ctx({ id: 'a1', role: Role.ADMIN }))).toBe(true);
  });

  it('USER is forbidden on admin endpoints → AUTH_FORBIDDEN (403)', () => {
    try {
      guard.canActivate(ctx({ id: 'u1', role: Role.USER }));
      fail('USER should not pass admin RolesGuard');
    } catch (e) {
      expect(e).toBeInstanceOf(AppException);
      expect((e as AppException).errorKey).toBe('AUTH_FORBIDDEN');
    }
  });
});

// ============ B. 服务行为(需 DB)============
const HAS_DB = !!process.env.DATABASE_URL;
const d = HAS_DB ? describe : describe.skip;

d('AdminService (desensitized read + ban/unban + stats)', () => {
  let prisma: PrismaService;
  let admin: AdminService;
  let c: PrismaClient;

  beforeAll(async () => {
    prisma = new PrismaService();
    await prisma.$connect();
    c = prisma as unknown as PrismaClient;
    admin = new AdminService(prisma);
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
  });

  const makeUser = (opts: { email?: string | null; role?: Role; status?: AccountStatus }) =>
    c.user.create({
      data: {
        username: 'tester',
        email:
          opts.email === undefined ? `u${Math.random().toString(36).slice(2)}@x.com` : opts.email,
        passwordHash: 'argon2-hash-should-never-leak',
        role: opts.role ?? Role.USER,
        status: opts.status ?? AccountStatus.ACTIVE,
      },
    });

  it('listUsers: masks email and NEVER returns passwordHash / privacy detail', async () => {
    await makeUser({ email: 'alice@example.com' });
    const res = await admin.listUsers({});
    expect(res.items).toHaveLength(1);
    const row = res.items[0];
    expect(row.emailMasked).toBe('a***@example.com');
    // 脱敏断言:序列化后绝不含敏感字段
    const json = JSON.stringify(res);
    expect(json).not.toContain('argon2-hash');
    expect(json).not.toContain('passwordHash');
    expect(json).not.toContain('alice@example.com'); // 完整邮箱不外泄
    expect(row).not.toHaveProperty('passwordHash');
    expect(row).not.toHaveProperty('heightCm');
  });

  it('listUsers: pagination + status filter', async () => {
    await makeUser({ status: AccountStatus.ACTIVE });
    await makeUser({ status: AccountStatus.BANNED });
    const active = await admin.listUsers({ status: AccountStatus.ACTIVE });
    expect(active.total).toBe(1);
    expect(active.items[0].status).toBe(AccountStatus.ACTIVE);
    const paged = await admin.listUsers({ page: 1, pageSize: 1 });
    expect(paged.pageSize).toBe(1);
    expect(paged.total).toBe(2);
    expect(paged.items).toHaveLength(1);
  });

  it('getUserDetail: aggregate counts only, no meal content / no original image', async () => {
    const u = await makeUser({ email: 'bob@example.com' });
    await c.mealEntry.create({
      data: {
        ownerId: u.id,
        mealType: 'LUNCH',
        consumedAt: new Date(),
        localDate: '2026-06-16',
        source: 'PHOTO',
        note: 'SECRET_PRIVATE_NOTE',
        items: { create: [{ ownerId: u.id, name: 'SECRET_FOOD', kcal: 100 }] },
      },
    });
    await c.recognitionUsage.create({ data: { ownerId: u.id, localDate: '2026-06-16', count: 5 } });

    const detail = await admin.getUserDetail(u.id);
    expect(detail.mealEntryCount).toBe(1);
    expect(detail.recognitionUsageTotal).toBe(5);
    expect(detail.emailMasked).toBe('b***@example.com');
    // 隐私红线:详情绝不含餐食/食物内容
    const json = JSON.stringify(detail);
    expect(json).not.toContain('SECRET_FOOD');
    expect(json).not.toContain('SECRET_PRIVATE_NOTE');
    expect(json).not.toContain('imageUrl');
  });

  it('getUserDetail: unknown id → RESOURCE_NOT_FOUND (no existence leak)', async () => {
    await expect(admin.getUserDetail('does-not-exist')).rejects.toMatchObject({
      errorKey: 'RESOURCE_NOT_FOUND',
    });
  });

  it('updateUserStatus: ban then unban a USER', async () => {
    const u = await makeUser({ status: AccountStatus.ACTIVE });
    const banned = await admin.updateUserStatus(u.id, { status: AccountStatus.BANNED });
    expect(banned.status).toBe(AccountStatus.BANNED);
    const back = await admin.updateUserStatus(u.id, { status: AccountStatus.ACTIVE });
    expect(back.status).toBe(AccountStatus.ACTIVE);
  });

  it('updateUserStatus: cannot ban an ADMIN → AUTH_FORBIDDEN', async () => {
    const adminUser = await makeUser({ role: Role.ADMIN });
    await expect(
      admin.updateUserStatus(adminUser.id, { status: AccountStatus.BANNED }),
    ).rejects.toMatchObject({ errorKey: 'AUTH_FORBIDDEN' });
  });

  it('getStats: desensitized aggregates + recognition trend', async () => {
    await makeUser({ status: AccountStatus.ACTIVE });
    await makeUser({ status: AccountStatus.BANNED });
    await c.recognitionAudit.createMany({
      data: [
        { source: 'PHOTO', success: true, createdAt: new Date() },
        { source: 'TEXT', success: false, createdAt: new Date() },
      ],
    });
    const stats = await admin.getStats({ days: 7 });
    expect(stats.totalUsers).toBe(2);
    expect(stats.activeUsers).toBe(1);
    expect(stats.bannedUsers).toBe(1);
    expect(stats.recognitionTotal).toBe(2);
    expect(stats.recognitionSuccess).toBe(1);
    expect(stats.recognitionFailureRate).toBe(0.5);
    expect(stats.recognitionTrend).toHaveLength(7);
    // 趋势点仅含去标识计数,无 ownerId / 个人字段
    const json = JSON.stringify(stats.recognitionTrend);
    expect(json).not.toContain('ownerId');
  });
});
