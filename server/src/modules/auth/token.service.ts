import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { createHash, randomBytes } from 'crypto';
import { Role } from '../../common/domain/enums';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtPayload } from '../../common/auth/auth.types';
import { AppException } from '../../common/errors/app.exception';

export interface IssuedTokens {
  accessToken: string;
  refreshToken: string;
}

/**
 * 令牌服务:
 * - accessToken:JWT 15min,payload { sub, role }(API.md §1)。
 * - refreshToken:不透明随机串(返回前端),服务端只存 sha256 哈希(DB §4),可吊销、轮换。
 */
@Injectable()
export class TokenService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly config: ConfigService,
    private readonly prisma: PrismaService,
  ) {}

  private hashToken(raw: string): string {
    return createHash('sha256').update(raw).digest('hex');
  }

  private async signAccessToken(userId: string, role: Role): Promise<string> {
    const payload: JwtPayload = { sub: userId, role };
    return this.jwtService.signAsync(payload, {
      secret: this.config.get<string>('jwt.accessSecret'),
      expiresIn: this.config.get<string>('jwt.accessTtl'),
    });
  }

  /**
   * 颁发一对令牌,并把 refreshToken 哈希入库(可吊销)。
   */
  async issue(userId: string, role: Role, userAgent?: string): Promise<IssuedTokens> {
    const accessToken = await this.signAccessToken(userId, role);
    const refreshRaw = randomBytes(48).toString('base64url');
    const ttlDays = this.config.get<number>('refreshTokenTtlDays') ?? 30;
    const expiresAt = new Date(Date.now() + ttlDays * 24 * 60 * 60 * 1000);

    await this.prisma.refreshToken.create({
      data: {
        userId,
        tokenHash: this.hashToken(refreshRaw),
        expiresAt,
        userAgent: userAgent ?? null,
      },
    });

    return { accessToken, refreshToken: refreshRaw };
  }

  /**
   * 刷新:校验 refreshToken 有效(存在/未吊销/未过期)→ 吊销旧的 → 颁发新一对(轮换)。
   * 失效统一 AUTH_UNAUTHORIZED(API.md §4.4)。
   */
  async rotate(refreshRaw: string, role: Role, userAgent?: string): Promise<IssuedTokens> {
    const tokenHash = this.hashToken(refreshRaw);
    const record = await this.prisma.refreshToken.findUnique({ where: { tokenHash } });
    if (!record || record.revokedAt || record.expiresAt.getTime() < Date.now()) {
      throw new AppException('AUTH_UNAUTHORIZED');
    }
    // 轮换:吊销旧 token,颁发新对
    await this.prisma.refreshToken.update({
      where: { id: record.id },
      data: { revokedAt: new Date() },
    });
    return this.issue(record.userId, role, userAgent);
  }

  /**
   * 解析 refreshToken 对应的 userId(供 refresh 端点取角色;不校验时效,时效在 rotate 内校验)。
   */
  async resolveUserId(refreshRaw: string): Promise<string | null> {
    const tokenHash = this.hashToken(refreshRaw);
    const record = await this.prisma.refreshToken.findUnique({ where: { tokenHash } });
    return record?.userId ?? null;
  }

  /**
   * 登出:吊销指定 refreshToken(幂等,不存在也返回 ok)。
   */
  async revoke(refreshRaw: string): Promise<void> {
    const tokenHash = this.hashToken(refreshRaw);
    await this.prisma.refreshToken.updateMany({
      where: { tokenHash, revokedAt: null },
      data: { revokedAt: new Date() },
    });
  }

  /**
   * 吊销某用户全部 refreshToken(改密后用,API.md §4.7)。
   */
  async revokeAllForUser(userId: string, exceptTokenRaw?: string): Promise<void> {
    const except = exceptTokenRaw ? this.hashToken(exceptTokenRaw) : undefined;
    await this.prisma.refreshToken.updateMany({
      where: {
        userId,
        revokedAt: null,
        ...(except ? { tokenHash: { not: except } } : {}),
      },
      data: { revokedAt: new Date() },
    });
  }
}
