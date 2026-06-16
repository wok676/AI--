import { SetMetadata } from '@nestjs/common';
import { Role } from '../domain/enums';

export const ROLES_KEY = 'roles';

/**
 * 纵向 RBAC(§6):标注端点所需角色,RolesGuard 校验当前角色是否有权调用。
 * 例:@Roles(Role.ADMIN) 仅管理后台端点。
 */
export const Roles = (...roles: Role[]) => SetMetadata(ROLES_KEY, roles);
