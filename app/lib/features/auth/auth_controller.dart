import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/types.dart';
import '../../compliance/account_deletion_service.dart';
import '../../compliance/consent_gate.dart';
import '../../storage/token_store.dart';
import '../data/repositories.dart';

/// 鉴权阶段(供 go_router redirect 判断;UI §4.2 已登录直达 Today / 未登录拦截)。
enum AuthStatus { unknown, authenticated, unauthenticated }

@immutable
class AuthState {
  const AuthState({required this.status, this.user});

  final AuthStatus status;
  final AuthUser? user;

  /// 启动初始态:未知(从安全存储恢复会话前不做跳转,避免闪屏)。
  static const AuthState unknown = AuthState(status: AuthStatus.unknown);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isResolved => status != AuthStatus.unknown;

  AuthState copyWith({AuthStatus? status, AuthUser? user}) =>
      AuthState(status: status ?? this.status, user: user ?? this.user);
}

/// 鉴权状态控制器:启动恢复会话 → 登录/注册/Apple 写入 → 登出/注销清空。
///
/// 所有操作包 try-catch,失败抛 [ApiError] 由 UI 三态承载;状态切换驱动 router redirect。
class AuthController extends StateNotifier<AuthState> {
  // ignore_for_file: prefer_initializing_formals
  AuthController({
    required AuthRepository authRepo,
    required TokenStore tokenStore,
    required ConsentGate consentGate,
    required AccountDeletionService deletionService,
  })  : _authRepo = authRepo,
        _tokenStore = tokenStore,
        _consentGate = consentGate,
        _deletionService = deletionService,
        super(AuthState.unknown) {
    _restore();
  }

  final AuthRepository _authRepo;
  final TokenStore _tokenStore;
  final ConsentGate _consentGate;
  final AccountDeletionService _deletionService;

  /// 启动时从安全存储恢复会话(有 refresh token 即视为已登录,access 失效由拦截器自动刷新)。
  Future<void> _restore() async {
    try {
      final bool hasSession = await _tokenStore.hasSession();
      state = hasSession
          ? const AuthState(status: AuthStatus.authenticated)
          : const AuthState(status: AuthStatus.unauthenticated);
    } catch (_) {
      // 读失败从严:视为未登录,绝不崩溃(宪法 §1.2)。
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> login({required String email, required String password}) async {
    final AuthSession session = await _authRepo.login(email: email, password: password);
    await _onSession(session);
  }

  /// 注册:同时把用户**主动勾选**的同意写入合规闸门(consent_gate),
  /// 用于第三方 SDK 拦截判断(PRD §4.1/§4.7)。后端亦二次校验 consentAccepted。
  Future<void> register({
    required String email,
    required String password,
    required String consentVersion,
    required String locale,
  }) async {
    final AuthSession session = await _authRepo.register(
      email: email,
      password: password,
      consentAccepted: true,
      consentVersion: consentVersion,
      locale: locale,
    );
    await _consentGate.grantConsent(version: consentVersion);
    await _onSession(session);
  }

  Future<void> signInWithApple({
    required String identityToken,
    required String authorizationCode,
    String? fullName,
    required String locale,
  }) async {
    final AuthSession session = await _authRepo.apple(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      fullName: fullName,
      locale: locale,
    );
    await _onSession(session);
  }

  Future<void> _onSession(AuthSession session) async {
    await _tokenStore.saveSession(session);
    state = AuthState(status: AuthStatus.authenticated, user: session.user);
  }

  /// 登出:吊销会话 + 清本地凭证(复用合规服务)。
  Future<void> logout() async {
    await _deletionService.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// 【账号注销】成功后切到未登录(本地凭证清除由 [AccountDeletionService] 完成)。
  Future<AccountDeletionResult> deleteAccount({String? password}) async {
    final AccountDeletionResult result =
        await _deletionService.deleteAccount(password: password);
    if (result.isSuccess) {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
    return result;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((Ref ref) {
  return AuthController(
    authRepo: ref.watch(authRepositoryProvider),
    tokenStore: ref.watch(tokenStoreProvider),
    consentGate: ref.watch(consentGateProvider),
    deletionService: ref.watch(accountDeletionServiceProvider),
  );
});
