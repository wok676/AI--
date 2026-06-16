import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

/**
 * 管理后台域(API.md §3 A · PRD §2.5/§2.6)。
 * 全部端点纵向 @Roles(ADMIN);仅脱敏聚合,最小可见。复用全局 JwtAuthGuard/RolesGuard/异常过滤器。
 */
@Module({
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
