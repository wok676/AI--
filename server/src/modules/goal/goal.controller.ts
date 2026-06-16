import { Body, Controller, Get, HttpCode, HttpStatus, Post, Put } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { GoalService } from './goal.service';
import { CurrentUser } from '../../common/auth/current-user.decorator';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { EstimateGoalDto, PutGoalDto } from './dto/goal.dto';
import { GoalDto, GoalEstimateDto } from './dto/goal-response.dto';

/**
 * 每日目标端点(API.md §3 #19–21)。需 Bearer。estimate 为纯计算,不落库。
 */
@ApiTags('goal')
@Controller('goal')
export class GoalController {
  constructor(private readonly goal: GoalService) {}

  @Get()
  get(@CurrentUser() user: CurrentUserContext): Promise<GoalDto | null> {
    return this.goal.get(user);
  }

  @Put()
  @HttpCode(HttpStatus.OK)
  put(@CurrentUser() user: CurrentUserContext, @Body() dto: PutGoalDto): Promise<GoalDto> {
    return this.goal.put(user, dto);
  }

  @Post('estimate')
  @HttpCode(HttpStatus.OK)
  estimate(@Body() dto: EstimateGoalDto): GoalEstimateDto {
    return this.goal.estimate(dto);
  }
}
