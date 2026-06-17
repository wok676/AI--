import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';

/// 三色宏量条(UI §3.8):蛋白/碳水/脂肪,高 6dp,圆角 full。
/// 上方 labelSmall 名称 + 克数(克数 LTR 字形)。
class MacroBars extends StatelessWidget {
  const MacroBars({
    super.key,
    required this.proteinLabel,
    required this.carbsLabel,
    required this.fatLabel,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  final String proteinLabel;
  final String carbsLabel;
  final String fatLabel;
  final num proteinG;
  final num carbsG;
  final num fatG;

  @override
  Widget build(BuildContext context) {
    final num total = (proteinG + carbsG + fatG).clamp(1, double.infinity);
    return Row(
      children: <Widget>[
        Expanded(
          child: _MacroColumn(
            label: proteinLabel,
            grams: proteinG,
            fraction: proteinG / total,
            color: AppColors.macroProtein,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MacroColumn(
            label: carbsLabel,
            grams: carbsG,
            fraction: carbsG / total,
            color: AppColors.macroCarbs,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _MacroColumn(
            label: fatLabel,
            grams: fatG,
            fraction: fatG / total,
            color: AppColors.macroFat,
          ),
        ),
      ],
    );
  }
}

class _MacroColumn extends StatelessWidget {
  const _MacroColumn({
    required this.label,
    required this.grams,
    required this.fraction,
    required this.color,
  });

  final String label;
  final num grams;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 名称前加对应宏量色小圆点(蛋白蓝/碳水橙/脂肪黄),增强可读性(视觉增强)。
        Row(
          children: <Widget>[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Flexible(
              child: Text(
                '$label  ${grams.round()}g',
                style: theme.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: AppSizes.macroBarHeight,
            backgroundColor: AppColors.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
