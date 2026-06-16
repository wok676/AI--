import { Body, Controller, Get, Param, Patch, Query } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { AdminService } from './admin.service';
import { Roles } from '../../common/auth/roles.decorator';
import { Role } from '../../common/domain/enums';
import { ListUsersQueryDto, StatsQueryDto, UpdateUserStatusDto } from './dto/admin.dto';
import { AdminStatsDto, AdminUserDetailDto, AdminUserListDto } from './dto/admin-response.dto';

/**
 * 管理后台端点(API.md §3 A · PRD §2.5/§2.6)。
 *
 * 纵向鉴权(§6):整个 controller 标注 @Roles(ADMIN),普通 USER 访问 → 403 AUTH_FORBIDDEN + i18n。
 * JwtAuthGuard 已强制 Bearer 与时效;RolesGuard 校验角色。
 * 最小可见:仅返回脱敏字段与去标识聚合,绝不返回原图/餐食明细/健康明细。
 */
@ApiTags('admin')
@ApiBearerAuth()
@Roles(Role.ADMIN)
@Controller('admin')
export class AdminController {
  constructor(private readonly admin: AdminService) {}

  /** 用户列表(分页/搜索/状态筛选)。 */
  @Get('users')
  listUsers(@Query() query: ListUsersQueryDto): Promise<AdminUserListDto> {
    return this.admin.listUsers(query);
  }

  /** 脱敏聚合统计看板。放在 :id 之前避免路由吞掉。 */
  @Get('stats')
  getStats(@Query() query: StatsQueryDto): Promise<AdminStatsDto> {
    return this.admin.getStats(query);
  }

  /** 用户详情(脱敏聚合)。 */
  @Get('users/:id')
  getUserDetail(@Param('id') id: string): Promise<AdminUserDetailDto> {
    return this.admin.getUserDetail(id);
  }

  /** 封禁/解封。仅 ACTIVE/BANNED 切换;不可封禁 ADMIN;注销仍只能本人物理删除。 */
  @Patch('users/:id')
  updateUserStatus(
    @Param('id') id: string,
    @Body() dto: UpdateUserStatusDto,
  ): Promise<AdminUserDetailDto> {
    return this.admin.updateUserStatus(id, dto);
  }
}
