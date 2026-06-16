import { ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Role } from '../domain/enums';
import { RolesGuard } from './roles.guard';
import { AppException } from '../errors/app.exception';
import { CurrentUserContext } from './auth.types';

/**
 * 纵向鉴权(§6):角色不足 → 403(AUTH_FORBIDDEN)。
 */
function ctxWithUser(user: CurrentUserContext | undefined): ExecutionContext {
  return {
    switchToHttp: () => ({ getRequest: () => ({ user }) }),
    getHandler: () => undefined,
    getClass: () => undefined,
  } as unknown as ExecutionContext;
}

describe('RolesGuard (vertical authz)', () => {
  const make = (required: Role[] | undefined): RolesGuard => {
    const reflector = {
      getAllAndOverride: () => required,
    } as unknown as Reflector;
    return new RolesGuard(reflector);
  };

  it('allows when no roles required', () => {
    const guard = make(undefined);
    expect(guard.canActivate(ctxWithUser({ id: 'u1', role: Role.USER }))).toBe(true);
  });

  it('allows ADMIN to access ADMIN endpoint', () => {
    const guard = make([Role.ADMIN]);
    expect(guard.canActivate(ctxWithUser({ id: 'a1', role: Role.ADMIN }))).toBe(true);
  });

  it('forbids USER on ADMIN endpoint with AUTH_FORBIDDEN', () => {
    const guard = make([Role.ADMIN]);
    try {
      guard.canActivate(ctxWithUser({ id: 'u1', role: Role.USER }));
      fail('should have thrown');
    } catch (e) {
      expect(e).toBeInstanceOf(AppException);
      expect((e as AppException).errorKey).toBe('AUTH_FORBIDDEN');
    }
  });

  it('forbids missing user', () => {
    const guard = make([Role.USER]);
    expect(() => guard.canActivate(ctxWithUser(undefined))).toThrow(AppException);
  });
});
