import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储封装(宪法 §6:token 必须存安全存储,禁明文/禁 SharedPreferences)。
///
/// iOS → Keychain;Android → EncryptedSharedPreferences(AES)。
/// 所有读写包 try-catch,失败降级为 null/no-op,绝不抛到 UI 层(宪法 §1.2)。
class SecureStorage {
  SecureStorage([FlutterSecureStorage? backend])
      : _backend = backend ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  final FlutterSecureStorage _backend;

  Future<String?> read(String key) async {
    try {
      return await _backend.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _backend.write(key: key, value: value);
    } catch (_) {
      // 写失败不致命(如设备无安全硬件):静默降级。
    }
  }

  Future<void> delete(String key) async {
    try {
      await _backend.delete(key: key);
    } catch (_) {}
  }

  /// 清空全部凭证(账号注销 / 登出后调用,§4.2 本地凭证彻底清除)。
  Future<void> deleteAll() async {
    try {
      await _backend.deleteAll();
    } catch (_) {}
  }
}

final secureStorageProvider = Provider<SecureStorage>((Ref ref) => SecureStorage());
