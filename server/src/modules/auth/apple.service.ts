import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createRemoteJWKSet, jwtVerify } from 'jose';
import { AppException } from '../../common/errors/app.exception';

export interface AppleIdentity {
  sub: string;
  email: string | null;
}

/**
 * Sign in with Apple:校验 identityToken(验签 against Apple JWKS + iss + aud)。
 * 取 sub 作为稳定身份标识(API.md §4.3),email 可空(私密中继可能无可用邮箱)。
 * 校验失败一律 AUTH_INVALID_CREDENTIALS,不外泄具体原因。
 */
@Injectable()
export class AppleService {
  private readonly logger = new Logger(AppleService.name);
  private readonly jwks = createRemoteJWKSet(new URL('https://appleid.apple.com/auth/keys'));

  constructor(private readonly config: ConfigService) {}

  async verifyIdentityToken(identityToken: string): Promise<AppleIdentity> {
    const audience = this.config.get<string>('apple.audience');
    const issuer = this.config.get<string>('apple.issuer');
    try {
      const { payload } = await jwtVerify(identityToken, this.jwks, {
        issuer,
        audience: audience || undefined,
      });
      if (!payload.sub) {
        throw new AppException('AUTH_INVALID_CREDENTIALS');
      }
      const email = typeof payload.email === 'string' ? payload.email : null;
      return { sub: payload.sub, email };
    } catch (err) {
      if (err instanceof AppException) throw err;
      // 验签/过期/aud 不符 → 归一为凭证无效(不打印 token)
      this.logger.warn(`apple identity token verification failed: ${(err as Error).name}`);
      throw new AppException('AUTH_INVALID_CREDENTIALS');
    }
  }
}
