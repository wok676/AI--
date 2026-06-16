import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { Request } from 'express';
import { CurrentUserContext } from './auth.types';

/**
 * 注入当前已鉴权用户(JwtAuthGuard 挂在 req.user)。
 * service 层据此做横向归属过滤 where { ownerId: user.id }。
 */
export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): CurrentUserContext => {
    const req = ctx.switchToHttp().getRequest<Request & { user?: CurrentUserContext }>();
    // JwtAuthGuard 保证非公开端点必有 user;此处断言其存在
    return req.user as CurrentUserContext;
  },
);
