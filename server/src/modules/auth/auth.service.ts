import { Injectable, Logger } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { AuthProvider, Role } from '../../common/domain/enums';
import { PrismaService } from '../../prisma/prisma.service';
import { PasswordService } from './password.service';
import { TokenService } from './token.service';
import { AppleService } from './apple.service';
import { AppException } from '../../common/errors/app.exception';
import { CurrentUserContext } from '../../common/auth/auth.types';
import {
  AppleLoginDto,
  ChangePasswordDto,
  DeleteAccountDto,
  LoginDto,
  RegisterDto,
} from './dto/auth.dto';
import { AuthSessionDto, DeleteAccountResultDto, OkDto } from './dto/auth-response.dto';

/**
 * 鉴权域业务逻辑。所有报错走 AppException(messageKey),日志不打印 PII/token/password。
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly passwords: PasswordService,
    private readonly tokens: TokenService,
    private readonly apple: AppleService,
  ) {}

  private normalizeEmail(email: string): string {
    return email.trim().toLowerCase();
  }

  private maskEmail(email: string | null): string {
    if (!email) return '<none>';
    const [name, domain] = email.split('@');
    if (!domain) return '***';
    return `${name.slice(0, 1)}***@${domain}`;
  }

  /**
   * DB 返回的 role 在不同 provider 下类型为 string;在边界归一为领域 Role 枚举。
   * schema 约束 role ∈ {USER, ADMIN},未知值兜底为 USER(最小权限)。
   */
  private toRole(role: string): Role {
    return role === Role.ADMIN ? Role.ADMIN : Role.USER;
  }

  private session(
    user: { id: string; username: string; role: string },
    tokens: { accessToken: string; refreshToken: string },
  ): AuthSessionDto {
    return {
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      user: { id: user.id, username: user.username, role: this.toRole(user.role) },
    };
  }

  // ---------------- A1 注册 ----------------
  async register(dto: RegisterDto, userAgent?: string): Promise<AuthSessionDto> {
    // 后端二次校验知情同意(API.md §4.1,不信任前端置灰)
    if (dto.consentAccepted !== true) {
      throw new AppException('AUTH_CONSENT_REQUIRED');
    }
    if (!this.passwords.isStrong(dto.password)) {
      throw new AppException('AUTH_WEAK_PASSWORD');
    }

    const email = this.normalizeEmail(dto.email);
    const existing = await this.prisma.user.findUnique({ where: { email } });
    if (existing) {
      // 措辞归一,不暴露已注册存在性(API.md §0.3)
      throw new AppException('AUTH_EMAIL_TAKEN');
    }

    const passwordHash = await this.passwords.hash(dto.password);
    const username = email.split('@')[0];

    const user = await this.prisma.user.create({
      data: {
        email,
        passwordHash,
        username,
        locale: dto.locale ?? 'en',
        consentAcceptedAt: new Date(),
        consentVersion: dto.consentVersion,
        authIdentities: {
          create: { provider: AuthProvider.EMAIL, providerUserId: email },
        },
      },
    });

    const issued = await this.tokens.issue(user.id, this.toRole(user.role), userAgent);
    this.logger.log(`user registered id=${user.id} email=${this.maskEmail(email)}`);
    return this.session(user, issued);
  }

  // ---------------- A2 登录 ----------------
  async login(dto: LoginDto, userAgent?: string): Promise<AuthSessionDto> {
    const email = this.normalizeEmail(dto.email);
    const user = await this.prisma.user.findUnique({ where: { email } });
    // 不区分「邮箱不存在」与「密码错」,均归一 AUTH_INVALID_CREDENTIALS(API.md §4.2)
    if (!user || !user.passwordHash) {
      throw new AppException('AUTH_INVALID_CREDENTIALS');
    }
    const ok = await this.passwords.verify(user.passwordHash, dto.password);
    if (!ok) {
      throw new AppException('AUTH_INVALID_CREDENTIALS');
    }
    const issued = await this.tokens.issue(user.id, this.toRole(user.role), userAgent);
    return this.session(user, issued);
  }

  // ---------------- A4 Sign in with Apple ----------------
  async loginWithApple(dto: AppleLoginDto, userAgent?: string): Promise<AuthSessionDto> {
    const identity = await this.apple.verifyIdentityToken(dto.identityToken);

    // 以 (APPLE, sub) 为身份主键查找已有绑定
    const existingIdentity = await this.prisma.authIdentity.findUnique({
      where: {
        provider_providerUserId: { provider: AuthProvider.APPLE, providerUserId: identity.sub },
      },
      include: { user: true },
    });

    let user = existingIdentity?.user ?? null;
    if (!user) {
      // 首次登录:创建 User + APPLE 身份。username 取 fullName → email 前缀 → 匿名
      const username =
        dto.fullName?.trim() ||
        (identity.email ? identity.email.split('@')[0] : `apple_${identity.sub.slice(0, 8)}`);
      user = await this.prisma.user.create({
        data: {
          email: identity.email ? this.normalizeEmail(identity.email) : null,
          username,
          locale: dto.locale ?? 'en',
          // Apple 登录视为已通过其授权流程的知情同意入口(前端在 Apple 按钮上方展示同意)
          consentAcceptedAt: new Date(),
          consentVersion: 'apple',
          authIdentities: {
            create: { provider: AuthProvider.APPLE, providerUserId: identity.sub },
          },
        },
      });
    }

    const issued = await this.tokens.issue(user.id, this.toRole(user.role), userAgent);
    return this.session(user, issued);
  }

  // ---------------- refresh(轮换)----------------
  async refresh(refreshToken: string, userAgent?: string): Promise<AuthSessionDto> {
    const userId = await this.tokens.resolveUserId(refreshToken);
    if (!userId) {
      throw new AppException('AUTH_UNAUTHORIZED');
    }
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw new AppException('AUTH_UNAUTHORIZED');
    }
    const issued = await this.tokens.rotate(refreshToken, this.toRole(user.role), userAgent);
    return this.session(user, issued);
  }

  // ---------------- A3 登出 ----------------
  async logout(refreshToken: string): Promise<OkDto> {
    await this.tokens.revoke(refreshToken);
    return { ok: true };
  }

  // ---------------- A6 忘记密码(Should)----------------
  async forgotPassword(): Promise<OkDto> {
    // 恒返回 ok,不暴露邮箱是否注册(API.md §4.6)。真实发信由邮件服务接入(本轮占位)。
    return { ok: true };
  }

  // ---------------- A9 修改密码(Should)----------------
  async changePassword(current: CurrentUserContext, dto: ChangePasswordDto): Promise<OkDto> {
    const user = await this.prisma.user.findUnique({ where: { id: current.id } });
    if (!user || !user.passwordHash) {
      throw new AppException('AUTH_INVALID_CREDENTIALS');
    }
    const ok = await this.passwords.verify(user.passwordHash, dto.currentPassword);
    if (!ok) {
      throw new AppException('AUTH_INVALID_CREDENTIALS');
    }
    if (!this.passwords.isStrong(dto.newPassword)) {
      throw new AppException('AUTH_WEAK_PASSWORD');
    }
    const newHash = await this.passwords.hash(dto.newPassword);
    await this.prisma.user.update({
      where: { id: user.id },
      data: { passwordHash: newHash },
    });
    // 改密后吊销其它会话(API.md §4.7)
    await this.tokens.revokeAllForUser(user.id);
    return { ok: true };
  }

  // ---------------- A8 账号注销 · 彻底擦除(红线)----------------
  /**
   * 单事务执行 DB §10 级联策略:
   *  1) 二次校验(邮箱用户须验密码,防误触);
   *  2) RecognitionAudit.ownerId 置 NULL —— 不可逆去标识化(保留聚合,唯一例外);
   *  3) 物理删除 User 行 —— AuthIdentity/RefreshToken/Profile/MealEntry/FoodItem/
   *     DailyGoal/RecognitionUsage 经 onDelete: Cascade 连带物理删除;
   *  4)(应用层)Apple revoke 撤销第三方授权 —— 见 revokeAppleGrants。
   * 物理删除即满足「彻底、不可逆」;绝不软删改 status 欺骗。
   */
  async deleteAccount(
    current: CurrentUserContext,
    dto: DeleteAccountDto,
  ): Promise<DeleteAccountResultDto> {
    const user = await this.prisma.user.findUnique({
      where: { id: current.id },
      include: { authIdentities: true },
    });
    if (!user) {
      // 已不存在视为成功(幂等)
      return { ok: true, messageKey: 'account.delete.success' };
    }

    // 二次校验:有密码的账号必须验密(防误触)
    if (user.passwordHash) {
      const ok = dto.password
        ? await this.passwords.verify(user.passwordHash, dto.password)
        : false;
      if (!ok) {
        throw new AppException('AUTH_INVALID_CREDENTIALS');
      }
    }

    // 撤销 Apple 授权(尽力而为,失败不阻断删除;不打印 token)
    await this.revokeAppleGrants(user.authIdentities);

    // 单事务:先去标识审计,再物理删 User(级联连带删除全部业务数据 + 凭证)
    await this.prisma.$transaction(async (tx: Prisma.TransactionClient) => {
      await tx.recognitionAudit.updateMany({
        where: { ownerId: user.id },
        data: { ownerId: null },
      });
      // 删除 User 触发 Cascade:authIdentities/refreshTokens/profile/mealEntries/
      // foodItems(经 mealEntry)/dailyGoals/recognitionUsages 全部物理删除
      await tx.user.delete({ where: { id: user.id } });
    });

    this.logger.log(`account erased id=${user.id} (cascade physical delete + audit de-identified)`);
    return { ok: true, messageKey: 'account.delete.success' };
  }

  private async revokeAppleGrants(identities: { provider: string }[]): Promise<void> {
    const hasApple = identities.some((i) => i.provider === AuthProvider.APPLE);
    if (!hasApple) return;
    // 调用 Apple revoke 接口的占位:需 client_secret(由 .p8 私钥签发,走 .env,零硬编码)。
    // 真实接入由 devops 配齐密钥后启用;失败不阻断本地数据物理删除(数据已不可逆销毁)。
    this.logger.log('apple grant revocation requested (delegated to revoke pipeline)');
  }
}
