import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';

/// 首页核心进度环(UI §3.7,极简专业 · 数据导向):直径 200,环宽 12,圆形端帽。
/// - 底环 progressRing.track;进度弧**单色 primary**(去 SweepGradient 渐变,极简);
///   超目标转 progressRing.over(克制琥珀,不报警)。
/// - 中心 kcal 巨号粗体**近黑 onSurface**(数据本身不上色,克制);辅助文案弱中性灰。
/// - LTR 从顶部顺时针;RTL 从顶部逆时针(方向镜像,§8.2)。
/// - 入场 800ms easeOutCubic 从 0 扫到当前值(§9.4)。
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.consumed,
    required this.goal,
    required this.centerTop,
    required this.centerBottom,
    this.subtitle,
  });

  final num consumed;
  final num goal;

  /// 中心主数字(已摄入 kcal)与下方「/目标」文案,由调用方本地化。
  final String centerTop;
  final String centerBottom;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;
    final double goalSafe = goal <= 0 ? 0 : goal.toDouble();
    final double ratio = goalSafe <= 0
        ? 0
        : (consumed / goalSafe).clamp(0.0, 1.0).toDouble();
    final bool over = goalSafe > 0 && consumed > goalSafe;

    return SizedBox(
      width: AppSizes.progressRingDiameter,
      height: AppSizes.progressRingDiameter,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: ratio),
        duration: AppMotion.progressRingIn,
        curve: Curves.easeOutCubic,
        builder: (BuildContext context, double animated, _) {
          return CustomPaint(
            painter: _RingPainter(
              progress: animated,
              over: over,
              clockwise: !isRtl,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // 关键数值用 LTR 局部包裹,避免 RTL 下 BiDi 乱序(UI §8.3)。
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(centerTop, style: theme.textTheme.displaySmall),
                  ),
                  Text(centerBottom, style: theme.textTheme.bodySmall),
                  if (subtitle != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      // 极简风:辅助「剩余」文案用弱中性灰,不抢中心数字(§3.7 不上色)。
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.over,
    required this.clockwise,
  });

  final double progress;
  final bool over;
  final bool clockwise;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - AppSizes.progressRingStroke) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.progressRingStroke
      ..color = AppColors.progressRingTrack
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;

    const double start = -math.pi / 2; // 12 点钟
    final double sweep = 2 * math.pi * progress * (clockwise ? 1 : -1);

    // 极简专业 · 数据导向:进度弧用**单色**(去 SweepGradient 渐变,UI §3.7)。
    // 正常态克制墨绿 primary;超目标转 progressRing.over 克制琥珀(不报警红,不焦虑)。
    final Paint arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.progressRingStroke
      ..strokeCap = StrokeCap.round
      ..color = over ? AppColors.progressRingOver : AppColors.primary;

    canvas.drawArc(rect, start, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.over != over ||
      old.clockwise != clockwise;
}
