import { SetMetadata } from '@nestjs/common';

export const IS_PUBLIC_KEY = 'isPublic';

/**
 * 标记公开端点(Guest):register/login/apple/refresh/forgot-password/health(API.md §2)。
 * 未标记的端点默认需 Bearer accessToken。
 */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
