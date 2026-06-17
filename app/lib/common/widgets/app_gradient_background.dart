import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// 全局可复用的「清新渐变 + 柔光色斑」背景(视觉增强 · 用户验收)。
///
/// 设计语言(克制!健康工具气质):
/// - 极淡垂直渐变:surface(顶)→ primaryContainer 极淡(底),整体仍极浅,文字清晰;
/// - 2 个柔光色斑:用 [RadialGradient](中心色 → 透明)画的大圆,做柔边而**非模糊滤镜**
///   (省性能);右上 primary @ ~7%、左下 tertiary @ ~6%,均位于内容**之下**;
/// - 对比度不受影响(WCAG AA):色斑 alpha 极低,不压暗文字。
///
/// 所有颜色值来自 [AppColors] 的 gradient/blob 令牌,**禁止逐页 hardcode**。
///
/// 用法:把屏的 [Scaffold.backgroundColor] 设为透明,再用本组件包裹 body。
/// 色斑用 [Positioned] 绝对定位且不拦截手势([IgnorePointer]),不影响交互。
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    super.key,
    required this.child,
    this.showBlobs = true,
  });

  /// 前景内容(置于渐变与色斑之上)。
  final Widget child;

  /// 是否绘制柔光色斑(默认开;极小屏或不需要时可关)。
  final bool showBlobs;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      // —— 1. 极淡垂直渐变(底层)——
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[AppColors.gradientTop, AppColors.gradientBottom],
        ),
      ),
      child: Stack(
        children: <Widget>[
          // —— 2. 柔光色斑(中层,位于内容之下,不拦截手势)——
          if (showBlobs) ...<Widget>[
            // 右上:primary 柔光斑。
            const PositionedDirectional(
              top: -120,
              end: -100,
              child: IgnorePointer(
                child: _SoftBlob(
                  diameter: 360,
                  center: AppColors.blobPrimary,
                  edge: AppColors.blobPrimaryTransparent,
                ),
              ),
            ),
            // 左下:tertiary(暖橙)柔光斑。
            const PositionedDirectional(
              bottom: -140,
              start: -110,
              child: IgnorePointer(
                child: _SoftBlob(
                  diameter: 400,
                  center: AppColors.blobTertiary,
                  edge: AppColors.blobTertiaryTransparent,
                ),
              ),
            ),
          ],
          // —— 3. 前景内容(顶层)——
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

/// 单个柔光色斑:RadialGradient 从中心色渐隐到透明,圆形,柔边无模糊滤镜。
class _SoftBlob extends StatelessWidget {
  const _SoftBlob({
    required this.diameter,
    required this.center,
    required this.edge,
  });

  final double diameter;
  final Color center;
  final Color edge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[center, edge],
          // 中心实色范围小、向外平滑渐隐,边缘完全透明 → 柔边。
          stops: const <double>[0.0, 1.0],
        ),
      ),
    );
  }
}
