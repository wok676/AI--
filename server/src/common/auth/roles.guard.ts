import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '../domain/enums';
import { Request } from 'express';
import { AppException } from '../errors/app.exception';
import { ROLES_KEY } from './roles.decorator';
import { CurrentUserContext } from './auth.types';

/**
 * 纵向鉴权(§6):校验当前用户角色是否在端点允许的角色集合内。
 * 未标注 @Roles 的端点默认仅需登录(JwtAuthGuard 已校验)。
 * 角色不足 → 统一 403(AUTH_FORBIDDEN),不暴露资源是否存在。
 */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<Role[] | undefined>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredRoles || requiredRoles.length === 0) return true;

    const req = context.switchToHttp().getRequest<Request & { user?: CurrentUserContext }>();
    const user = req.user;
    if (!user || !requiredRoles.includes(user.role)) {
      throw new AppException('AUTH_FORBIDDEN');
    }
    return true;
  }
}
