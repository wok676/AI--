import { Role } from '../domain/enums';

/**
 * accessToken JWT payload(API.md §1 强耦合点③):{ sub, role, iat, exp }。
 */
export interface JwtPayload {
  sub: string;
  role: Role;
  iat?: number;
  exp?: number;
}

/**
 * 请求上下文中的当前用户(供横向归属过滤 where { ownerId: currentUser.id })。
 */
export interface CurrentUserContext {
  id: string;
  role: Role;
}
