import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/types.dart';
import 'secure_storage.dart';

/// 身份凭证安全存储(宪法 §6:token 一律安全存储,禁明文/SharedPreferences)。
///
/// 仅暴露 access/refresh token 读写与「彻底清除」;account 注销与 logout 复用 [clear]。
class TokenStore {
  TokenStore(this._storage);

  final SecureStorage _storage;

  static const String _kAccess = 'auth.accessToken';
  static const String _kRefresh = 'auth.refreshToken';
  static const String _kUserId = 'auth.user.id';
  static const String _kUsername = 'auth.user.username';
  static const String _kRole = 'auth.user.role';

  Future<String?> readAccessToken() => _storage.read(_kAccess);
  Future<String?> readRefreshToken() => _storage.read(_kRefresh);

  /// 持久化整个会话(登录/注册/刷新成功后)。
  Future<void> saveSession(AuthSession session) async {
    await _storage.write(_kAccess, session.accessToken);
    await _storage.write(_kRefresh, session.refreshToken);
    await _storage.write(_kUserId, session.user.id);
    await _storage.write(_kUsername, session.user.username);
    await _storage.write(
      _kRole,
      session.user.role == UserRole.admin ? 'ADMIN' : 'USER',
    );
  }

  /// 仅更新 access(刷新轮换时,refresh 也会一并轮换则用 saveSession)。
  Future<void> updateAccessToken(String accessToken) =>
      _storage.write(_kAccess, accessToken);

  Future<bool> hasSession() async {
    final String? t = await _storage.read(_kRefresh);
    return t != null && t.isNotEmpty;
  }

  /// 【本地凭证彻底清除】——登出 / 账号注销成功后调用。
  /// 删除所有身份相关键(宪法 §4.2 / API §4.8:清 secure storage 回登录页)。
  Future<void> clear() async {
    await _storage.delete(_kAccess);
    await _storage.delete(_kRefresh);
    await _storage.delete(_kUserId);
    await _storage.delete(_kUsername);
    await _storage.delete(_kRole);
  }
}

final tokenStoreProvider = Provider<TokenStore>(
  (Ref ref) => TokenStore(ref.watch(secureStorageProvider)),
);
