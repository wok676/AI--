import { PrismaClient } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { MeService } from './me.service';
import { Role, Sex } from '../../common/domain/enums';
import { CurrentUserContext } from '../../common/auth/auth.types';

/**
 * 集成测试(SQLite dev.db):/me 横向归属 + profile upsert + 注销后旧 token 归一 404。
 * 对照 API.md §4.9、宪法 §6(横向鉴权 + 防 mass-assignment)。
 * 运行前需 DATABASE_URL,否则跳过(与其它 *.integration.spec 一致)。
 */
const HAS_DB = !!process.env.DATABASE_URL;
const d = HAS_DB ? describe : describe.skip;

d('Me integration (horizontal scope + profile upsert + post-delete 404)', () => {
  let prisma: PrismaService;
  let me: MeService;
  let c: PrismaClient;
  const userA: CurrentUserContext = { id: '', role: Role.USER };
  const userB: CurrentUserContext = { id: '', role: Role.USER };

  beforeAll(async () => {
    prisma = new PrismaService();
    await prisma.$connect();
    c = prisma as unknown as PrismaClient;
    me = new MeService(prisma);
  });

  afterAll(async () => {
    await prisma.$disconnect();
  });

  beforeEach(async () => {
    await c.profile.deleteMany();
    await c.user.deleteMany();
    const a = await c.user.create({ data: { username: 'a', email: 'a@x.com' } });
    const b = await c.user.create({ data: { username: 'b', email: 'b@x.com' } });
    userA.id = a.id;
    userB.id = b.id;
  });

  it('get: returns own profile shape (no passwordHash), default profile when none', async () => {
    const dto = await me.get(userA);
    expect(dto.id).toBe(userA.id);
    expect(dto.username).toBe('a');
    expect(dto.plan).toBe('FREE');
    expect(dto.profile.sex).toBe(Sex.UNSPECIFIED);
    expect(dto.profile.heightCm).toBeNull();
    expect(dto).not.toHaveProperty('passwordHash');
  });

  it('update: scalar prefs + nested profile upsert; reads back', async () => {
    const dto = await me.update(userA, {
      username: 'alice',
      locale: 'ja',
      unitEnergy: 'kj',
      notifyEnabled: true,
      profile: { sex: Sex.FEMALE, heightCm: 165, weightKg: 55 },
    });
    expect(dto.username).toBe('alice');
    expect(dto.locale).toBe('ja');
    expect(dto.unitEnergy).toBe('kj');
    expect(dto.notifyEnabled).toBe(true);
    expect(dto.profile.sex).toBe(Sex.FEMALE);
    expect(dto.profile.heightCm).toBe(165);
  });

  it('horizontal scope: updating A never touches B', async () => {
    await me.update(userA, { username: 'alice' });
    const b = await me.get(userB);
    expect(b.username).toBe('b'); // B unchanged
  });

  it('post-delete: stale token (user removed) → RESOURCE_NOT_FOUND on get', async () => {
    await c.user.delete({ where: { id: userA.id } });
    await expect(me.get(userA)).rejects.toMatchObject({ errorKey: 'RESOURCE_NOT_FOUND' });
  });

  it('post-delete: update on removed user → RESOURCE_NOT_FOUND (no crash)', async () => {
    await c.user.delete({ where: { id: userA.id } });
    await expect(me.update(userA, { username: 'x' })).rejects.toMatchObject({
      errorKey: 'RESOURCE_NOT_FOUND',
    });
  });
});
