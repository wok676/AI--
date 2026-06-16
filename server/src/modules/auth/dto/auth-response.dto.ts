import { Role } from '../../../common/domain/enums';

/**
 * JWT 返回结构(API.md §1 强耦合点③,不可改)。
 * 前端 app/lib/api/types.dart 的 AuthSession/AuthUser 逐字段对齐。
 */
export interface AuthUserDto {
  id: string;
  username: string;
  role: Role;
}

export interface AuthSessionDto {
  accessToken: string;
  refreshToken: string;
  user: AuthUserDto;
}

export interface OkDto {
  ok: true;
}

export interface DeleteAccountResultDto {
  ok: true;
  messageKey: 'account.delete.success';
}
