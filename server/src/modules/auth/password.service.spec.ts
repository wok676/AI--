import { PasswordService } from './password.service';

/**
 * 验证:argon2id 哈希、绝不明文、密码强度规则。
 */
describe('PasswordService', () => {
  const svc = new PasswordService();

  it('hashes with argon2id and never stores plaintext', async () => {
    const plain = 'Abc12345';
    const hash = await svc.hash(plain);
    expect(hash).not.toContain(plain); // 哈希串不含明文
    expect(hash.startsWith('$argon2id$')).toBe(true); // 确为 argon2id
  });

  it('verifies correct password and rejects wrong one', async () => {
    const hash = await svc.hash('Abc12345');
    await expect(svc.verify(hash, 'Abc12345')).resolves.toBe(true);
    await expect(svc.verify(hash, 'wrong-password')).resolves.toBe(false);
  });

  it('returns false (not throw) on corrupted hash', async () => {
    await expect(svc.verify('not-a-hash', 'whatever')).resolves.toBe(false);
  });

  it('enforces strength: >=8 chars, letters + digits', () => {
    expect(svc.isStrong('Abc12345')).toBe(true);
    expect(svc.isStrong('short1')).toBe(false); // 太短
    expect(svc.isStrong('abcdefgh')).toBe(false); // 无数字
    expect(svc.isStrong('12345678')).toBe(false); // 无字母
  });
});
