import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule } from '@nestjs/config';
import { AuthController } from './auth.controller';
import { AccountController } from './account.controller';
import { AuthService } from './auth.service';
import { PasswordService } from './password.service';
import { TokenService } from './token.service';
import { AppleService } from './apple.service';

@Module({
  imports: [ConfigModule, JwtModule.register({})],
  controllers: [AuthController, AccountController],
  providers: [AuthService, PasswordService, TokenService, AppleService],
  exports: [AuthService, PasswordService, TokenService],
})
export class AuthModule {}
