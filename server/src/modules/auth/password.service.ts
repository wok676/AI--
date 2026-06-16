import { Injectable } from '@nestjs/common';
import * as argon2 from 'argon2';

/**
 * 密码哈希:argon2id 盐值哈希(§1.4 / §6 零明文密码)。绝不存明文,绝不打印。
 * argon2 自带随机盐,哈希串内嵌参数与盐,verify 无需单独存盐。
 */
@Injectable()
export class PasswordService {
  private readonly options: argon2.Options = {
    type: argon2.argon2id,
    memoryCost: 19456, // 19 MiB(OWASP 推荐下限档)
    timeCost: 2,
    parallelism: 1,
  };

  async hash(plain: string): Promise<string> {
    return argon2.hash(plain, this.options);
  }

  async verify(hash: string, plain: string): Promise<boolean> {
    try {
      return await argon2.verify(hash, plain);
    } catch {
      // 哈希串损坏等异常一律视为不匹配,不外泄原因
      return false;
    }
  }

  /**
   * 密码强度:≥8 位且含字母+数字(API.md §4.1)。
   */
  isStrong(plain: string): boolean {
    return plain.length >= 8 && /[A-Za-z]/.test(plain) && /\d/.test(plain);
  }
}
