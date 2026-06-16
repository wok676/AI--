import 'app_localizations.dart';

/// 后端 messageKey(点号命名空间,如 `auth.error.invalidCredentials`)→ 本地化文案。
///
/// ARB key 不允许含 '.',故扁平化为下划线(`auth_error_invalidCredentials`);
/// 此处集中映射,统一 API client 把错误 messageKey 转 i18n 文案(宪法 §5/§7)。
/// 未登记的 key 一律回退 common.error.generic,绝不直接显示裸 key。
extension MessageKeyL10n on AppLocalizations {
  String byMessageKey(String dottedKey) {
    switch (dottedKey) {
      // —— 通用 / 三态 / 错误(API §0.3)——
      case 'common.error.generic':
        return common_error_generic;
      case 'common.error.network':
        return common_error_network;
      case 'common.error.timeout':
        return common_error_timeout;
      case 'errors.unauthorized':
        return errors_unauthorized;
      case 'errors.forbidden':
        return errors_forbidden;
      case 'errors.notFound':
        return errors_notFound;
      // —— 鉴权 ——
      case 'auth.error.invalidCredentials':
        return auth_error_invalidCredentials;
      case 'auth.consent.required':
        return auth_consent_required;
      case 'auth.password.weak':
        return auth_password_weak;
      case 'auth.email.invalid':
        return auth_email_invalid;
      // —— 识别 ——
      case 'recognize.error.failed':
        return recognize_error_failed;
      case 'recognize.limit.reached':
        return recognize_limit_reached;
      case 'recognize.disclaimer':
        return recognize_disclaimer;
      // —— 目标 / 注销 ——
      case 'goal.disclaimer':
        return goal_disclaimer;
      case 'account.delete.success':
        return account_delete_success;
      default:
        // 未知 messageKey:回退通用错误,不暴露裸 key(宪法 §1.2/§7)。
        return common_error_generic;
    }
  }
}
