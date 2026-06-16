import { Body, Controller, Delete, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { CurrentUser } from '../../common/auth/current-user.decorator';
import { CurrentUserContext } from '../../common/auth/auth.types';
import { DeleteAccountDto } from './dto/auth.dto';
import { DeleteAccountResultDto } from './dto/auth-response.dto';

/**
 * 账号注销端点(API.md §3 #8 · DELETE /account · 彻底擦除红线)。
 * 需 Bearer;仅本人可注销本人账号(横向归属:取 req.user.id,不接受外部传入 id)。
 */
@ApiTags('account')
@Controller('account')
export class AccountController {
  constructor(private readonly auth: AuthService) {}

  @Delete()
  @HttpCode(HttpStatus.OK)
  deleteAccount(
    @CurrentUser() user: CurrentUserContext,
    @Body() dto: DeleteAccountDto,
  ): Promise<DeleteAccountResultDto> {
    // 注销目标恒为当前已鉴权用户本人;不暴露/不接受任意 userId,杜绝越权注销他人
    return this.auth.deleteAccount(user, dto);
  }
}
