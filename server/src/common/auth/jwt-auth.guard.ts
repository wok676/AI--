import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';
import { AppException } from '../errors/app.exception';
import { IS_PUBLIC_KEY } from './public.decorator';
import { CurrentUserContext, JwtPayload } from './auth.types';

/**
 * 强制校验 accessToken 及时效性(§6:所有接口强制校验 Token,防未授权越权)。
 * 公开端点(@Public)放行;其余必须携带有效 Bearer。失败统一 401(AUTH_UNAUTHORIZED)。
 * 校验通过后把 { id, role } 挂到 req.user,供 RolesGuard 与横向归属过滤使用。
 */
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const req = context.switchToHttp().getRequest<Request & { user?: CurrentUserContext }>();
    const token = this.extractBearer(req);
    if (!token) {
      throw new AppException('AUTH_UNAUTHORIZED');
    }

    const secret = this.config.get<string>('jwt.accessSecret');
    try {
      const payload = await this.jwtService.verifyAsync<JwtPayload>(token, { secret });
      // jwt 库已校验 exp 时效;此处再确保 sub/role 完整
      if (!payload.sub || !payload.role) {
        throw new AppException('AUTH_UNAUTHORIZED');
      }
      req.user = { id: payload.sub, role: payload.role };
      return true;
    } catch {
      // 过期/签名错误/篡改 → 统一 401,不区分原因(不暴露细节)
      throw new AppException('AUTH_UNAUTHORIZED');
    }
  }

  private extractBearer(req: Request): string | null {
    const header = req.headers.authorization;
    if (!header) return null;
    const [scheme, value] = header.split(' ');
    return scheme === 'Bearer' && value ? value : null;
  }
}
