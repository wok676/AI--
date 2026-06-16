import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/error_mapper.dart';
import '../api/types.dart';
import '../storage/secure_storage.dart';
import '../storage/token_store.dart';
import 'consent_gate.dart';

/// 注销结果:成功携带后端返回的 messageKey(account.delete.success),供 UI 转 i18n。
class AccountDeletionResult {
  const AccountDeletionResult.success(this.messageKey) : error = null;
  const AccountDeletionResult.failure(this.error) : messageKey = null;

  final String? messageKey;
  final ApiError? error;

  bool get isSuccess => error == null;
}

/// 【账号注销 · 本地凭证彻底清除】(宪法 §4.2 / API §4.8)。
///
/// 流程(UI 层负责二次确认 + 主动输入密码后才调用本服务):
/// 1. 调 `DELETE /api/v1/account`(带 password 二次验证);
/// 2. 后端单事务彻底、不可逆删除全部业务数据 + 去标识审计 + 删 User 行;
/// 3. **成功后立即清空本地所有身份凭证**(secure storage)+ 撤回隐私同意 +
///    清空其余本地缓存,使第三方 SDK 闸门回到「未同意」拦截态;
/// 4. 由调用方导航回登录页。
///
/// 注意:仅在后端确认成功(ok=true)后才清本地,避免误删导致用户卡死无法重试。
class AccountDeletionService {
  // ignore_for_file: prefer_initializing_formals
  AccountDeletionService({
    required ApiClient apiClient,
    required TokenStore tokenStore,
    required SecureStorage secureStorage,
    required ConsentGate consentGate,
  })  : _apiClient = apiClient,
        _tokenStore = tokenStore,
        _secureStorage = secureStorage,
        _consentGate = consentGate;

  final ApiClient _apiClient;
  final TokenStore _tokenStore;
  final SecureStorage _secureStorage;
  final ConsentGate _consentGate;

  /// 邮箱用户:传 password 二次验证(Apple 用户由 UI 传 re-auth 凭证,后端校验)。
  Future<AccountDeletionResult> deleteAccount({String? password}) async {
    try {
      final Response<Map<String, Object?>> resp =
          await _apiClient.dio.delete<Map<String, Object?>>(
        '/account',
        data: <String, Object?>{'password': ?password},
      );

      final Map<String, Object?> data = resp.data ?? const <String, Object?>{};
      final bool ok = data['ok'] == true;
      if (!ok) {
        return const AccountDeletionResult.failure(
          ApiError.local(code: 'INTERNAL_ERROR', messageKey: 'common.error.generic'),
        );
      }

      // —— 后端确认彻底删除后,客户端立即清除本地全部痕迹 ——
      await _purgeLocalState();

      final String messageKey =
          data['messageKey'] as String? ?? 'account.delete.success';
      return AccountDeletionResult.success(messageKey);
    } on DioException catch (e) {
      // 拦截器已把 error 映射为 ApiError;兜底再映射一次。
      final Object? mapped = e.error;
      final ApiError apiError = mapped is ApiError ? mapped : mapDioException(e);
      return AccountDeletionResult.failure(apiError);
    } catch (_) {
      return const AccountDeletionResult.failure(
        ApiError.local(code: 'INTERNAL_ERROR', messageKey: 'common.error.generic'),
      );
    }
  }

  /// 登出(非注销):仅吊销会话 + 清本地凭证,不删后端数据。
  Future<void> logout() async {
    try {
      final String? refresh = await _tokenStore.readRefreshToken();
      if (refresh != null && refresh.isNotEmpty) {
        await _apiClient.dio.post<Object?>(
          '/auth/logout',
          data: <String, Object?>{'refreshToken': refresh},
        );
      }
    } catch (_) {
      // 即便后端登出失败,也要清本地凭证(以本地清除为准)。
    } finally {
      await _tokenStore.clear();
    }
  }

  /// 清空本地全部身份/隐私痕迹:token + 同意状态 + 其余 secure storage 缓存。
  Future<void> _purgeLocalState() async {
    await _tokenStore.clear();
    await _consentGate.revokeConsent();
    // 兜底:清空整个安全存储(确保无任何凭证/敏感缓存残留)。
    await _secureStorage.deleteAll();
  }
}

final accountDeletionServiceProvider = Provider<AccountDeletionService>((Ref ref) {
  return AccountDeletionService(
    apiClient: ref.watch(apiClientProvider),
    tokenStore: ref.watch(tokenStoreProvider),
    secureStorage: ref.watch(secureStorageProvider),
    consentGate: ref.watch(consentGateProvider),
  );
});
