import {
  IsBoolean,
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
} from 'class-validator';

/**
 * DTO + class-validator;配合全局 ValidationPipe(whitelist + forbidNonWhitelisted)。
 * 字段名/结构与前端共享类型逐字段对齐(API.md §4 + 强耦合点②)。
 */

export class RegisterDto {
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @IsString()
  @MinLength(8)
  @MaxLength(128)
  password!: string;

  // 后端二次校验:必须为 true,否则 AUTH_CONSENT_REQUIRED(不信任前端置灰)
  @IsBoolean()
  consentAccepted!: boolean;

  @IsString()
  @IsNotEmpty()
  @MaxLength(20)
  consentVersion!: string;

  @IsOptional()
  @IsString()
  @MaxLength(8)
  locale?: string;
}

export class LoginDto {
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @IsString()
  @MinLength(1)
  @MaxLength(128)
  password!: string;
}

export class AppleLoginDto {
  @IsString()
  @IsNotEmpty()
  identityToken!: string;

  @IsOptional()
  @IsString()
  authorizationCode?: string;

  @IsOptional()
  @IsString()
  @MaxLength(120)
  fullName?: string;

  @IsOptional()
  @IsString()
  @MaxLength(8)
  locale?: string;
}

export class RefreshDto {
  @IsString()
  @IsNotEmpty()
  refreshToken!: string;
}

export class LogoutDto {
  @IsString()
  @IsNotEmpty()
  refreshToken!: string;
}

export class ForgotPasswordDto {
  @IsEmail()
  @MaxLength(254)
  email!: string;
}

export class ChangePasswordDto {
  @IsString()
  @IsNotEmpty()
  currentPassword!: string;

  @IsString()
  @MinLength(8)
  @MaxLength(128)
  newPassword!: string;
}

export class DeleteAccountDto {
  // 邮箱用户须二次验证密码(API.md §4.8 防误触);Apple-only 用户可空,走会话校验
  @IsOptional()
  @IsString()
  @MaxLength(128)
  password?: string;
}
