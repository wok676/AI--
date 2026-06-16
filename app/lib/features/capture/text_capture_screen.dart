import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../api/types.dart';
import '../../common/widgets/app_snackbar.dart';
import '../../l10n/app_localizations.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';
import '../data/repositories.dart';
import 'recognition_confirm_screen.dart';

/// 文字录入页(UI §5.3):多行输入 + 「识别」。识别成功跳确认页,失败 messageKey 提示。
class TextCaptureScreen extends ConsumerStatefulWidget {
  const TextCaptureScreen({super.key});

  @override
  ConsumerState<TextCaptureScreen> createState() => _TextCaptureScreenState();
}

class _TextCaptureScreenState extends ConsumerState<TextCaptureScreen> {
  final TextEditingController _text = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _recognize() async {
    final String text = _text.text.trim();
    if (text.isEmpty) return;
    setState(() => _submitting = true);
    try {
      final RecognitionResult result =
          await ref.read(mealRepositoryProvider).recognizeText(text);
      if (mounted) {
        context.pushReplacement(
          AppRoutes.recognitionConfirm,
          extra: RecognitionConfirmArgs(result: result, source: RecognitionSource.text),
        );
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.capture_text_title)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _text,
                enabled: !_submitting,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: l10n.capture_text_placeholder,
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: _submitting ? null : _recognize,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(AppSizes.buttonHeightCta),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.onPrimary),
                    )
                  : Text(l10n.capture_cta_recognize),
            ),
          ],
        ),
      ),
    );
  }
}
