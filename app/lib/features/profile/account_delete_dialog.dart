import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/test_keys.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../compliance/account_deletion_service.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/message_key.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../auth/auth_controller.dart';

/// 【账号注销二次确认流】(UI §5.8 / §7.2 / PRD §4.2 红线)。
///
/// 合规强约束:
/// - 风险正文 account.delete.warning 完整告知「不可逆/彻底删除」;
/// - **须主动输入密码**才能点确认(空密码 disabled);
/// - 取消与确认两按钮视觉等权(反 dark pattern,不诱导放弃注销),确认用 error 危险色;
/// - 提供**网页端注销通道**链接清晰可见(Apple 要求);
/// - 成功 → 由 [AccountDeletionService] 清本地凭证 + 撤回同意 → 切未登录 → router 回登录页。
abstract final class AccountDeleteFlow {
  AccountDeleteFlow._();

  /// 弹出二次确认弹窗。删除全过程(输密码 → 调服务 → 清本地凭证 → 反馈)在弹窗内完成;
  /// 成功后 AuthController 已切未登录,router redirect 自动回登录页。
  static Future<void> show(BuildContext context, WidgetRef ref) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => const _DeleteConfirmDialog(),
    );
  }
}

/// 注销二次确认弹窗:内部完成「输密码 → 调服务 → 反馈」,成功返回 true。
class _DeleteConfirmDialog extends ConsumerStatefulWidget {
  const _DeleteConfirmDialog();

  @override
  ConsumerState<_DeleteConfirmDialog> createState() =>
      _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends ConsumerState<_DeleteConfirmDialog> {
  final TextEditingController _password = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final AccountDeletionResult result = await ref
          .read(authControllerProvider.notifier)
          .deleteAccount(password: _password.text);
      if (!mounted) return;
      if (result.isSuccess) {
        // 成功:本地凭证已被服务清除,关闭弹窗,router redirect 回登录页。
        AppSnackbar.showMessage(
          context,
          l10n.byMessageKey(result.messageKey ?? 'account.delete.success'),
        );
        Navigator.of(context).pop(true);
      } else {
        // 失败:留在弹窗,messageKey 提示(如密码错 401)。
        AppSnackbar.showError(context, result.error!);
        setState(() => _busy = false);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, e);
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool canConfirm = !_busy && _password.text.isNotEmpty;

    return AlertDialog(
      // 内容可滚动:窄高屏 / 关闭动画收缩高度时,避免 content Column 瞬时 RenderFlex 溢出(§5)。
      scrollable: true,
      icon: const Icon(Icons.warning_amber, size: 40, color: AppColors.error),
      title: Text(l10n.account_delete_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 完整风险告知(不可逆,§7.2)。
          Text(l10n.account_delete_warning, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            key: const ValueKey<String>(TestKeys.deleteConfirmPasswordField),
            controller: _password,
            obscureText: true,
            enabled: !_busy,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: l10n.account_delete_confirmHint,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // 网页端注销通道(Apple 要求,清晰可见)。
          Text(
            l10n.account_delete_web,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      actions: <Widget>[
        // 取消与确认等权(不放大取消诱导放弃,§7.2)。
        OutlinedButton(
          key: const ValueKey<String>(TestKeys.deleteCancelBtn),
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.account_delete_cancel),
        ),
        FilledButton(
          key: const ValueKey<String>(TestKeys.deleteConfirmBtn),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.onError,
          ),
          onPressed: canConfirm ? _confirm : null,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.onError,
                  ),
                )
              : Text(l10n.account_delete_confirmBtn),
        ),
      ],
    );
  }
}
