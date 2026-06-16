import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../prisma/prisma.service';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { AppException } from '../../common/errors/app.exception';
import { ActivityLevel, GoalType, Plan, Role, Sex } from '../../common/domain/enums';
import { UpdateMeDto } from './dto/me.dto';
import { MeDto } from './dto/me-response.dto';

/**
 * 当前用户资料/偏好(API.md §4.9 GET/PATCH /me · PRD C1/C2/C6)。
 *
 * 横向归属(§6):恒以 req.user.id 读写本人,不接受外部传入 id。
 * 防 mass-assignment(§6):仅落 UpdateMeDto 白名单字段;role/plan/status/email/passwordHash
 *   不可经此端点修改(DTO 不含 + ValidationPipe forbidNonWhitelisted)。
 * 最小返回:显式 select,绝不返回 passwordHash 等敏感列。
 */
@Injectable()
export class MeService {
  constructor(private readonly prisma: PrismaService) {}

  private static readonly SELECT = {
    id: true,
    email: true,
    username: true,
    role: true,
    plan: true,
    avatarUrl: true,
    locale: true,
    unitEnergy: true,
    unitMass: true,
    notifyEnabled: true,
    profile: {
      select: {
        sex: true,
        birthYear: true,
        heightCm: true,
        weightKg: true,
        activityLevel: true,
        goalType: true,
      },
    },
  } satisfies Prisma.UserSelect;

  async get(user: CurrentUserContext): Promise<MeDto> {
    const row = await this.prisma.user.findUnique({
      where: { id: user.id },
      select: MeService.SELECT,
    });
    // token 有效但用户已删除(如注销后旧 access 未过期)→ 归一 404,不暴露存在性
    if (!row) throw new AppException('RESOURCE_NOT_FOUND');
    return this.toDto(row);
  }

  async update(user: CurrentUserContext, dto: UpdateMeDto): Promise<MeDto> {
    // 仅白名单标量字段;profile 用 upsert 嵌套写(1:1)
    const data: Prisma.UserUpdateInput = {};
    if (dto.username !== undefined) data.username = dto.username;
    if (dto.avatarUrl !== undefined) data.avatarUrl = dto.avatarUrl;
    if (dto.locale !== undefined) data.locale = dto.locale;
    if (dto.unitEnergy !== undefined) data.unitEnergy = dto.unitEnergy;
    if (dto.unitMass !== undefined) data.unitMass = dto.unitMass;
    if (dto.notifyEnabled !== undefined) data.notifyEnabled = dto.notifyEnabled;

    if (dto.profile) {
      const p = dto.profile;
      const profileData = {
        ...(p.sex !== undefined ? { sex: p.sex } : {}),
        ...(p.birthYear !== undefined ? { birthYear: p.birthYear } : {}),
        ...(p.heightCm !== undefined ? { heightCm: p.heightCm } : {}),
        ...(p.weightKg !== undefined ? { weightKg: p.weightKg } : {}),
        ...(p.activityLevel !== undefined ? { activityLevel: p.activityLevel } : {}),
        ...(p.goalType !== undefined ? { goalType: p.goalType } : {}),
      };
      data.profile = { upsert: { create: profileData, update: profileData } };
    }

    try {
      const row = await this.prisma.user.update({
        where: { id: user.id }, // 横向归属:恒本人
        data,
        select: MeService.SELECT,
      });
      return this.toDto(row);
    } catch (err) {
      // 记录不存在(P2025,如注销后旧 token)→ 归一 404
      if (err instanceof Prisma.PrismaClientKnownRequestError && err.code === 'P2025') {
        throw new AppException('RESOURCE_NOT_FOUND');
      }
      throw err;
    }
  }

  private toDto(row: {
    id: string;
    email: string | null;
    username: string;
    role: string;
    plan: string;
    avatarUrl: string | null;
    locale: string;
    unitEnergy: string;
    unitMass: string;
    notifyEnabled: boolean;
    profile: {
      sex: string;
      birthYear: number | null;
      heightCm: number | null;
      weightKg: number | null;
      activityLevel: string | null;
      goalType: string | null;
    } | null;
  }): MeDto {
    return {
      id: row.id,
      email: row.email,
      username: row.username,
      role: row.role === Role.ADMIN ? Role.ADMIN : Role.USER,
      plan: row.plan === Plan.PRO ? Plan.PRO : Plan.FREE,
      avatarUrl: row.avatarUrl,
      locale: row.locale,
      unitEnergy: row.unitEnergy,
      unitMass: row.unitMass,
      notifyEnabled: row.notifyEnabled,
      profile: {
        sex: (row.profile?.sex as Sex) ?? Sex.UNSPECIFIED,
        birthYear: row.profile?.birthYear ?? null,
        heightCm: row.profile?.heightCm ?? null,
        weightKg: row.profile?.weightKg ?? null,
        activityLevel: (row.profile?.activityLevel as ActivityLevel | null) ?? null,
        goalType: (row.profile?.goalType as GoalType | null) ?? null,
      },
    };
  }
}
