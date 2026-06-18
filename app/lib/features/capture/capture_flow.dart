import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/types.dart';
import '../../common/test_keys.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../compliance/permission_prompt.dart';
import '../../compliance/permission_service.dart';
import '../../l10n/app_localizations.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../data/repositories.dart';
import 'recognition_confirm_screen.dart';

/// 录入方式选择 BottomSheet(UI §5.3)+ 拍照/相册前置授权 + 文字入口。
///
/// 合规(§7.3):拍照/相册点击 → 先弹**自定义前置解释弹窗** → 允许后才系统权限 →
/// 再 image_picker;被拒绝优雅降级(提示改用其他方式),绝不闪退。
abstract final class CaptureFlow {
  CaptureFlow._();

  static Future<void> showMethodSheet(BuildContext context, WidgetRef ref) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext sheetCtx) {
        return SafeArea(
          child: Column(
            key: const ValueKey<String>(TestKeys.captureMethodSheet),
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _MethodTile(
                key: const ValueKey<String>(TestKeys.captureOptionPhoto),
                icon: Icons.photo_camera,
                label: l10n.capture_method_photo,
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  _capturePhoto(context, ref, RecognitionSource.photo);
                },
              ),
              _MethodTile(
                key: const ValueKey<String>(TestKeys.captureOptionGallery),
                icon: Icons.photo_library,
                label: l10n.capture_method_gallery,
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  _capturePhoto(context, ref, RecognitionSource.gallery);
                },
              ),
              _MethodTile(
                key: const ValueKey<String>(TestKeys.captureOptionText),
                icon: Icons.edit_note,
                label: l10n.capture_method_text,
                onTap: () {
                  Navigator.of(sheetCtx).pop();
                  context.push(AppRoutes.textCapture);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  /// 拍照 / 相册:前置授权 → 取图 → 识别 → 跳确认页。
  static Future<void> _capturePhoto(
    BuildContext context,
    WidgetRef ref,
    RecognitionSource source,
  ) async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final PermissionService permService = ref.read(permissionServiceProvider);
    final bool isCamera = source == RecognitionSource.photo;

    // ① 前置解释弹窗 + 系统权限(允许后才真正请求)。
    final bool granted = await PermissionPrompt.requestWithRationale(
      context,
      permission: isCamera ? AppPermission.camera : AppPermission.photos,
      service: permService,
    );
    if (!granted) {
      // 优雅降级:提示改用其他录入方式(不闪退,F8 精神)。
      if (context.mounted) {
        AppSnackbar.showMessage(
          context,
          isCamera ? l10n.capture_camera_unavailable : l10n.capture_gallery_unavailable,
        );
      }
      return;
    }

    // ② 取图(image_picker;全程 try-catch)。
    String? path;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
      );
      path = file?.path;
    } catch (_) {
      path = null;
    }
    if (path == null) {
      if (context.mounted) {
        AppSnackbar.showMessage(
          context,
          isCamera ? l10n.capture_camera_unavailable : l10n.capture_gallery_unavailable,
        );
      }
      return;
    }

    // ③ 识别(loading 由确认页骨架承载:这里先调用,失败转 i18n)。
    if (!context.mounted) return;
    await _recognizeAndConfirm(
      context,
      ref,
      source: source,
      future: ref.read(mealRepositoryProvider).recognizeImage(filePath: path, source: source),
    );
  }

  /// 调识别 → 成功跳确认页 / 失败 messageKey 提示(429 限流、422 失败等)。
  static Future<void> _recognizeAndConfirm(
    BuildContext context,
    WidgetRef ref, {
    required RecognitionSource source,
    required Future<RecognitionResult> future,
  }) async {
    // 识别中的全局轻提示(确认页有完整骨架;此处用一次性进度遮罩)。
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => const _RecognizingDialog(),
    );
    try {
      final RecognitionResult result = await future;
      if (context.mounted) Navigator.of(context).pop(); // 关闭进度遮罩
      if (context.mounted) {
        context.push(
          AppRoutes.recognitionConfirm,
          extra: RecognitionConfirmArgs(result: result, source: source),
        );
      }
    } catch (e) {
      if (context.mounted) Navigator.of(context).pop();
      if (context.mounted) AppSnackbar.showError(context, e);
    }
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile(
      {super.key, required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: AppSpacing.md,
      leading: Icon(icon, size: 28, color: AppColors.primary),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      onTap: onTap,
    );
  }
}

class _RecognizingDialog extends StatelessWidget {
  const _RecognizingDialog();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return AlertDialog(
      content: Row(
        children: <Widget>[
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(l10n.recognize_loading)),
        ],
      ),
    );
  }
}
