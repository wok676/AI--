import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_dimens.dart';
import 'permission_service.dart';

/// 权限类型(决定前置弹窗文案与请求方法)。
enum AppPermission { camera, photos, notifications }

/// 【权限前置解释弹窗】(UI §5.9 / §7.3 / PRD §4.3)。
///
/// 合规强约束:
/// - 这是**自定义 Dialog**,**先于系统权限弹窗**出现;
/// - 用户点「允许」后才真正调用 [PermissionService] 触发系统权限弹窗;
/// - 点「暂不」→ 返回 false,调用方做优雅降级(改用其他录入方式),**绝不闪退**;
/// - 被永久拒绝 → 引导「去设置开启」(perm.openSettings),不强迫;
/// - **绝不在启动时盲目索取**:仅由用户主动触发对应功能时调用本流程。
class PermissionPrompt {
  PermissionPrompt._();

  /// 完整前置流程:先解释弹窗 → 允许后请求系统权限 → 返回最终是否授予。
  /// 返回 true 表示已授权可继续;false 表示用户取消/被拒(调用方降级)。
  static Future<bool> requestWithRationale(
    BuildContext context, {
    required AppPermission permission,
    required PermissionService service,
  }) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final (String title, String body) = _copy(l10n, permission);

    // ① 前置解释弹窗(系统弹窗之前)。
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => _RationaleDialog(title: title, body: body),
    );
    if (proceed != true) return false; // 用户点「暂不」→ 不触发系统弹窗,降级。

    if (!context.mounted) return false;

    // ② 用户同意后才调系统权限。
    final PermissionOutcome outcome = await _request(service, permission);
    switch (outcome) {
      case PermissionOutcome.granted:
        return true;
      case PermissionOutcome.denied:
        return false; // 本次拒绝:调用方降级,可下次再问。
      case PermissionOutcome.permanentlyDenied:
        if (context.mounted) {
          await _showOpenSettings(context, service);
        }
        return false;
    }
  }

  static Future<PermissionOutcome> _request(
    PermissionService service,
    AppPermission permission,
  ) {
    switch (permission) {
      case AppPermission.camera:
        return service.requestCamera();
      case AppPermission.photos:
        return service.requestPhotos();
      case AppPermission.notifications:
        return service.requestNotifications();
    }
  }

  static (String, String) _copy(AppLocalizations l10n, AppPermission permission) {
    switch (permission) {
      case AppPermission.camera:
        return (l10n.perm_camera_title, l10n.perm_camera_body);
      case AppPermission.photos:
        return (l10n.perm_photos_title, l10n.perm_photos_body);
      case AppPermission.notifications:
        return (l10n.perm_notify_title, l10n.perm_notify_body);
    }
  }

  /// 永久拒绝引导(不强迫):提供「去设置开启」。
  static Future<void> _showOpenSettings(
    BuildContext context,
    PermissionService service,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool? go = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        content: Text(l10n.perm_openSettings),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.perm_notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.perm_openSettings),
          ),
        ],
      ),
    );
    if (go == true) await service.openSettings();
  }
}

class _RationaleDialog extends StatelessWidget {
  const _RationaleDialog({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      actions: <Widget>[
        // 「暂不」(次)/「允许」(主),点按区由按钮主题保证 ≥48dp(§7.3)。
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.perm_notNow),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.perm_allow),
        ),
      ],
    );
  }
}
