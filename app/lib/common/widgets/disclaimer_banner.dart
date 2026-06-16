import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';

/// 固定免责声明条(UI §3 / §7.4:识别结果页、目标页常驻,不可关闭)。
/// `bodySmall onSurfaceVariant` + ⓘ 图标(医疗红线 PRD §4.6)。
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.info_outline, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              // 关键合规文案绝不截断(UI §2.4 / §7.4)。
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
