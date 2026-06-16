import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { AppException } from '../../common/errors/app.exception';
import { AccountStatus, Plan, Role } from '../../common/domain/enums';
import { recentLocalDates, toLocalDateUTC } from '../../common/util/local-date';
import { ListUsersQueryDto, StatsQueryDto, UpdateUserStatusDto } from './dto/admin.dto';
import {
  AdminStatsDto,
  AdminUserDetailDto,
  AdminUserListDto,
  AdminUserRow,
  RecognitionTrendPoint,
} from './dto/admin-response.dto';

const DEFAULT_PAGE_SIZE = 20;
const MAX_PAGE_SIZE = 100;

/**
 * 管理后台服务(PRD §2.5/§2.6 · API.md §3 A)。最小可见 + 脱敏:
 * - 绝不读取/返回 MealEntry/FoodItem 内容、原图、Profile 健康明细、passwordHash、refreshToken;
 * - 仅返回账号管理必需字段 + 去标识聚合统计;
 * - 邮箱在出库前脱敏(§6 日志/响应脱敏)。
 */
@Injectable()
export class AdminService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * 邮箱脱敏:保留首字符 + 域名,中间打码(a***@b.com)。
   * 纯 Apple 私密中继无邮箱用户返回 null。绝不返回完整邮箱明文。
   */
  private maskEmail(email: string | null): string | null {
    if (!email) return null;
    const at = email.indexOf('@');
    if (at <= 0) return '***';
    const local = email.slice(0, at);
    const domain = email.slice(at + 1);
    const head = local.charAt(0);
    return `${head}***@${domain}`;
  }

  /** 用户列表:分页 + 搜索(用户名/邮箱)+ 状态筛选。命中 User @@index([status])。 */
  async listUsers(query: ListUsersQueryDto): Promise<AdminUserListDto> {
    const page = query.page && query.page > 0 ? query.page : 1;
    const pageSize = Math.min(query.pageSize ?? DEFAULT_PAGE_SIZE, MAX_PAGE_SIZE);

    const where: Prisma.UserWhereInput = {};
    if (query.status) where.status = query.status;
    if (query.search) {
      const term = query.search.trim();
      // 仅按用户名/邮箱模糊匹配;不暴露其它隐私字段
      where.OR = [{ username: { contains: term } }, { email: { contains: term.toLowerCase() } }];
    }

    const [rows, total] = await this.prisma.$transaction([
      this.prisma.user.findMany({
        where,
        // 显式 select:绝不取 passwordHash 等敏感列
        select: {
          id: true,
          username: true,
          email: true,
          role: true,
          plan: true,
          status: true,
          createdAt: true,
        },
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * pageSize,
        take: pageSize,
      }),
      this.prisma.user.count({ where }),
    ]);

    const items: AdminUserRow[] = rows.map((u) => ({
      id: u.id,
      username: u.username,
      emailMasked: this.maskEmail(u.email),
      role: u.role as Role,
      plan: u.plan as Plan,
      status: u.status as AccountStatus,
      createdAt: u.createdAt.toISOString(),
    }));

    return { items, total, page, pageSize };
  }

  /** 用户详情(脱敏聚合)。仅计数级聚合,绝不读取餐食内容/原图/健康明细。 */
  async getUserDetail(id: string): Promise<AdminUserDetailDto> {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        username: true,
        email: true,
        role: true,
        plan: true,
        status: true,
        locale: true,
        notifyEnabled: true,
        consentAcceptedAt: true,
        consentVersion: true,
        createdAt: true,
        updatedAt: true,
        authIdentities: { select: { provider: true } }, // 仅渠道名,不取 providerUserId
        _count: { select: { mealEntries: true } }, // 仅行数,不取内容
      },
    });
    // 不存在 → 归一为 404,不暴露存在性(§6)
    if (!user) throw new AppException('RESOURCE_NOT_FOUND');

    // 累计识别次数:聚合 RecognitionUsage.count(成本/活跃参考,非内容)
    const usageAgg = await this.prisma.recognitionUsage.aggregate({
      where: { ownerId: id },
      _sum: { count: true },
    });

    return {
      id: user.id,
      username: user.username,
      emailMasked: this.maskEmail(user.email),
      role: user.role as Role,
      plan: user.plan as Plan,
      status: user.status as AccountStatus,
      locale: user.locale,
      notifyEnabled: user.notifyEnabled,
      consentAcceptedAt: user.consentAcceptedAt?.toISOString() ?? null,
      consentVersion: user.consentVersion ?? null,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
      mealEntryCount: user._count.mealEntries,
      recognitionUsageTotal: usageAgg._sum.count ?? 0,
      authProviders: user.authIdentities.map((a) => a.provider as string),
    };
  }

  /**
   * 封禁/解封(PATCH /admin/users/:id)。仅切换 ACTIVE/BANNED。
   * 绝不允许管理员把状态置为「注销」——注销是物理删除,只能由本人走 DELETE /account(PRD §4.2)。
   * 不允许封禁 ADMIN 账号(防误操作锁死后台)。
   */
  async updateUserStatus(id: string, dto: UpdateUserStatusDto): Promise<AdminUserDetailDto> {
    const target = await this.prisma.user.findUnique({
      where: { id },
      select: { id: true, role: true },
    });
    if (!target) throw new AppException('RESOURCE_NOT_FOUND');
    if (target.role === Role.ADMIN) {
      // 不暴露细节:管理员账号不可被封禁,归一为 403(纵向保护)
      throw new AppException('AUTH_FORBIDDEN');
    }

    await this.prisma.user.update({
      where: { id },
      data: { status: dto.status },
    });
    return this.getUserDetail(id);
  }

  /**
   * 脱敏聚合看板(PRD §2.6)。全部为计数/比率,去标识(RecognitionAudit ownerId 注销后为 NULL)。
   * 绝不返回任何个人可定位明细。
   */
  async getStats(query: StatsQueryDto): Promise<AdminStatsDto> {
    const days = query.days ?? 7;
    const today = toLocalDateUTC();
    const startOfToday = new Date(`${today}T00:00:00.000Z`);

    const [
      totalUsers,
      activeUsers,
      bannedUsers,
      newUsersToday,
      recognitionTotal,
      recognitionSuccess,
    ] = await this.prisma.$transaction([
      this.prisma.user.count(),
      this.prisma.user.count({ where: { status: AccountStatus.ACTIVE } }),
      this.prisma.user.count({ where: { status: AccountStatus.BANNED } }),
      this.prisma.user.count({ where: { createdAt: { gte: startOfToday } } }),
      this.prisma.recognitionAudit.count(),
      this.prisma.recognitionAudit.count({ where: { success: true } }),
    ]);

    const failureRate =
      recognitionTotal > 0
        ? Math.round(((recognitionTotal - recognitionSuccess) / recognitionTotal) * 100) / 100
        : 0;

    const recognitionTrend = await this.buildRecognitionTrend(today, days);

    return {
      totalUsers,
      activeUsers,
      bannedUsers,
      newUsersToday,
      recognitionTotal,
      recognitionSuccess,
      recognitionFailureRate: failureRate,
      recognitionTrend,
    };
  }

  /**
   * 近 N 天识别调用量趋势(去标识聚合)。按 createdAt 落在每个本地日 [00:00,24:00) 计数。
   * 返回升序日期序列(看板从左到右)。
   */
  private async buildRecognitionTrend(
    endDate: string,
    days: number,
  ): Promise<RecognitionTrendPoint[]> {
    const dates = recentLocalDates(endDate, days).reverse(); // 升序
    const points: RecognitionTrendPoint[] = [];
    for (const date of dates) {
      const dayStart = new Date(`${date}T00:00:00.000Z`);
      const dayEnd = new Date(dayStart.getTime() + 86400000);
      const range = { gte: dayStart, lt: dayEnd };
      const [total, success] = await this.prisma.$transaction([
        this.prisma.recognitionAudit.count({ where: { createdAt: range } }),
        this.prisma.recognitionAudit.count({ where: { createdAt: range, success: true } }),
      ]);
      points.push({ date, total, success, failed: total - success });
    }
    return points;
  }
}
