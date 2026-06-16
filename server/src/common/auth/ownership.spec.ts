import { assertOwned, ownedBy } from './ownership';
import { AppException } from '../errors/app.exception';

/**
 * 横向鉴权(§6):where { id, ownerId } 模式 + 越权归一 404(不暴露存在性)。
 */
describe('ownership (horizontal authz)', () => {
  it('builds where clause with both id and ownerId (anti-IDOR)', () => {
    expect(ownedBy('meal-1', 'owner-1')).toEqual({ id: 'meal-1', ownerId: 'owner-1' });
  });

  it('returns resource when owned', () => {
    const meal = { id: 'meal-1', ownerId: 'owner-1' };
    expect(assertOwned(meal)).toBe(meal);
  });

  it('throws RESOURCE_NOT_FOUND (404) when not found / not owned', () => {
    // 横向越权:查询带 ownerId 后查不到 → null → 归一 404,不暴露资源是否存在
    for (const empty of [null, undefined]) {
      try {
        assertOwned(empty);
        fail('should have thrown');
      } catch (e) {
        expect(e).toBeInstanceOf(AppException);
        expect((e as AppException).errorKey).toBe('RESOURCE_NOT_FOUND');
      }
    }
  });
});
