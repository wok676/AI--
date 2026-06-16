import 'package:flutter/material.dart';

import '../../api/types.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/message_key.dart';

/// 统一 Snackbar 反馈(UI §3.11)。错误走 messageKey → i18n;成功直接传文案。
/// 绝不直接展示裸异常/堆栈(宪法 §5)。
abstract final class AppSnackbar {
  AppSnackbar._();

  static void showMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// 把任意异常翻成 i18n 文案展示(ApiError → messageKey,否则通用错误)。
  static void showError(BuildContext context, Object error) {
    if (!context.mounted) return;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String message = error is ApiError
        ? l10n.byMessageKey(error.messageKey)
        : l10n.common_error_generic;
    showMessage(context, message);
  }
}
