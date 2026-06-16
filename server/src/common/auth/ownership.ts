import { AppException } from '../errors/app.exception';

/**
 * 横向归属基础设施(§6):统一构造 where { id, ownerId } 过滤条件,
 * 杜绝改 ID 越权;命中不到(不存在或非本人)一律归一为 404,不暴露资源存在性。
 *
 * 用法:
 *   const meal = await prisma.mealEntry.findFirst({ where: ownedBy(id, user.id) });
 *   assertOwned(meal); // 为空则抛 RESOURCE_NOT_FOUND(404)
 */
export function ownedBy(id: string, ownerId: string): { id: string; ownerId: string } {
  return { id, ownerId };
}

/**
 * 断言资源归属本人且存在;否则统一 404(横向越权不暴露存在性)。
 */
export function assertOwned<T>(resource: T | null | undefined): T {
  if (resource === null || resource === undefined) {
    throw new AppException('RESOURCE_NOT_FOUND');
  }
  return resource;
}
