import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// 全局可复用的页面背景(风格 v2 ·「极简专业 · 数据导向」)。
///
/// 设计语言(干净、专业、数据感):
/// - **去掉柔光色斑与渐变**:极简风不要花哨光斑;改铺**干净纯色** [AppColors.surface]
///   (极浅中性灰白),让数据/数字/卡片成为唯一视觉焦点;
/// - 对比度安全(WCAG AA):纯净平面不压暗任何文字;
/// - 保持**类名 / 构造接口不变**([child] + [showBlobs]),frontend 调用处零改动。
///
/// 注:[showBlobs] 参数保留以兼容现有调用,但在极简风下**不再绘制任何色斑**,
/// 传 true/false 均呈现同一干净纯色背景。
///
/// 用法:把屏的 [Scaffold.backgroundColor] 设为透明,再用本组件包裹 body;
/// 或直接将 [Scaffold.backgroundColor] 设为 [AppColors.surface] 亦等效。
class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    super.key,
    required this.child,
    this.showBlobs = true,
  });

  /// 前景内容(置于纯色背景之上)。
  final Widget child;

  /// 兼容保留:极简风下不绘制色斑,此参数不产生可见差异。
  final bool showBlobs;

  @override
  Widget build(BuildContext context) {
    // 干净纯色平面 —— 无渐变、无色斑。
    // 用 Stack(expand) 铺满整屏:ColoredBox 子组件会随内容收缩,内容不满屏时会
    // 露出透明 Scaffold 的黑底;StackFit.expand 强制背景层与内容层都填满约束。
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const ColoredBox(color: AppColors.surface),
        child,
      ],
    );
  }
}
