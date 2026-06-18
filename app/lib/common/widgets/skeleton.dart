import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimens.dart';

/// 骨架屏底块 + shimmer 微光(UI §3.10:加载态首选骨架而非转圈)。
/// shimmer 从 start→end 扫过,RTL 自动反向(用 AlignmentDirectional)。
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius = AppRadius.sm,
    this.shape = BoxShape.rectangle,
  });

  /// 圆形骨架(如进度环占位)。
  const Skeleton.circle({super.key, required double diameter})
    : width = diameter,
      height = diameter,
      radius = 0,
      shape = BoxShape.circle;

  final double width;
  final double height;
  final double radius;
  final BoxShape shape;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        final double t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape,
            borderRadius: widget.shape == BoxShape.rectangle
                ? BorderRadius.circular(widget.radius)
                : null,
            gradient: LinearGradient(
              // RTL 时 Flutter 会把 AlignmentDirectional 自动镜像。
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: const <Color>[
                AppColors.surfaceContainer,
                AppColors.surfaceContainerHigh,
                AppColors.surfaceContainer,
              ],
              stops: <double>[
                (t - 0.3).clamp(0.0, 1.0),
                t.clamp(0.0, 1.0),
                (t + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
