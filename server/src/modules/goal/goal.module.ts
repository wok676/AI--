import { Module } from '@nestjs/common';
import { GoalController } from './goal.controller';
import { GoalService } from './goal.service';

/**
 * 目标域(API.md §4.16/§4.17)。导出 GoalService 供 summary 复用「当日生效目标」解析。
 */
@Module({
  controllers: [GoalController],
  providers: [GoalService],
  exports: [GoalService],
})
export class GoalModule {}
