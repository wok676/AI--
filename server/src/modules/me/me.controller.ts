import { Body, Controller, Get, HttpCode, HttpStatus, Patch } from '@nestjs/common';
import { ApiBearerAuth, ApiTags } from '@nestjs/swagger';
import { MeService } from './me.service';
import { CurrentUser } from '../../common/auth/current-user.decorator';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { UpdateMeDto } from './dto/me.dto';
import { MeDto } from './dto/me-response.dto';

/**
 * 当前用户端点(API.md §3 #9–10 · GET/PATCH /me · PRD C1/C2/C6)。需 Bearer(全局 JwtAuthGuard)。
 * 横向归属:恒读写 req.user.id 本人;不接受外部 userId,杜绝越权读改他人资料。
 */
@ApiTags('me')
@ApiBearerAuth()
@Controller('me')
export class MeController {
  constructor(private readonly me: MeService) {}

  @Get()
  get(@CurrentUser() user: CurrentUserContext): Promise<MeDto> {
    return this.me.get(user);
  }

  @Patch()
  @HttpCode(HttpStatus.OK)
  update(@CurrentUser() user: CurrentUserContext, @Body() dto: UpdateMeDto): Promise<MeDto> {
    return this.me.update(user, dto);
  }
}
