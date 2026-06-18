#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
App 图标 / 启动页生成器 · AI 饮食热量记录
=========================================

宪法 §视觉:**图标必须代码/矢量生成,禁止位图采购**。本脚本仅依赖 Pillow(PIL),
用纯几何形状 + 径向渐变绘制「新叶环抱暖橙热量火苗」,不引入任何外部图片文件,
任意分辨率重绘清晰,规避版权 / 授权问题。

设计来源:docs/UI-DESIGN.md(§0 气质 / §2.1 配色)、app/lib/theme/app_colors.dart。
所有颜色为取自 AppColors 的十六进制常量,与全局设计令牌一致,禁另起一套。

输出
----
  app/assets/icon/icon.png            1024x1024  墨绿圆角渐变底 + 图形(商店 / iOS / launcher)
  app/assets/icon/icon_foreground.png 1024x1024  透明底,仅图形居中 ~70%(Android 自适应前景)
  app/assets/branding/splash.png       512x512   透明底,仅图形居中 ~82%(启动页中心 logo)

运行方式
--------
  1) 安装依赖:   pip install Pillow
  2) 在仓库根目录执行:
         python tools/gen_app_icon.py
     (脚本按相对仓库根的路径写出文件,会自动创建缺失目录)

注意:本脚本只生成上述源图。多分辨率切图 / iOS AppIcon set / Android mipmap /
启动页注入,由 devops 通过 flutter_launcher_icons / flutter_native_splash 执行
(见 app/pubspec.yaml 配置段)。UI 不跑 flutter 命令。
"""

import math
import os

from PIL import Image, ImageDraw

# ----------------------------------------------------------------------------
# 颜色常量(取自 app/lib/theme/app_colors.dart,十六进制,RGB)
# ----------------------------------------------------------------------------
PRIMARY = (0x2E, 0x7D, 0x5B)            # 品牌主色 墨绿  #2E7D5B
SECONDARY = (0x4E, 0x8C, 0x7A)          # 次强调 青灰绿  #4E8C7A(底渐变外圈)
PRIMARY_CONTAINER = (0xB6, 0xE5, 0xCE)  # 叶片主体 浅绿  #B6E5CE
ON_PRIMARY_CONTAINER = (0x0A, 0x3D, 0x2A)  # 叶脉 / 暗调   #0A3D2A
TERTIARY = (0xE0, 0x7A, 0x3F)           # 火苗外焰 暖橙  #E07A3F
MACRO_FAT = (0xE0, 0xB7, 0x3F)          # 火苗内焰 琥珀黄 #E0B73F
ON_PRIMARY = (0xFF, 0xFF, 0xFF)         # 火苗芯 / 高光   #FFFFFF

# ----------------------------------------------------------------------------
# 输出路径(相对仓库根)
# ----------------------------------------------------------------------------
_REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
OUT_ICON = os.path.join(_REPO_ROOT, "app", "assets", "icon", "icon.png")
OUT_FOREGROUND = os.path.join(_REPO_ROOT, "app", "assets", "icon", "icon_foreground.png")
OUT_SPLASH = os.path.join(_REPO_ROOT, "app", "assets", "branding", "splash.png")

# 超采样倍率:先在高分辨率画再缩小,得到平滑抗锯齿边缘。
SS = 4


def _lerp(a, b, t):
    return tuple(int(round(a[i] + (b[i] - a[i]) * t)) for i in range(3))


def radial_gradient(size, inner, outer, center=None, radius=None):
    """生成 RGBA 径向渐变(中心 inner → 边缘 outer),纯像素计算,不用任何位图。"""
    w, h = size
    if center is None:
        center = (w / 2.0, h / 2.0)
    if radius is None:
        radius = math.hypot(w, h) / 2.0
    cx, cy = center
    img = Image.new("RGB", size)
    px = img.load()
    inv_r = 1.0 / radius
    for y in range(h):
        dy2 = (y - cy) ** 2
        for x in range(w):
            t = math.sqrt((x - cx) ** 2 + dy2) * inv_r
            if t > 1.0:
                t = 1.0
            px[x, y] = _lerp(inner, outer, t)
    return img


def rounded_mask(size, radius):
    """返回圆角矩形的 L 模式遮罩(255 内 / 0 外)。"""
    m = Image.new("L", size, 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return m


def _flame_polygon(cx, cy, w, h, lean=0.0, samples=120):
    """
    生成一簇向上收尖的火苗轮廓点(对称水滴 / 火焰形)。
    cx,cy = 火苗底部中心;w = 最宽半宽;h = 总高(向上为负 y)。
    lean = 顶尖向右偏移比例(轻微摇曳,>0 右偏)。
    曲线:左右两侧用参数化曲线,底部圆鼓、中段外扩、顶端收尖并带一点 S 形摇曳。
    """
    pts_right = []
    pts_left = []
    for i in range(samples + 1):
        t = i / samples  # 0=底部 1=顶尖
        # 半宽随高度变化:底部稍窄→中下最宽→顶端收为 0
        bulge = math.sin(t * math.pi) ** 0.85
        half = w * bulge * (1.0 - 0.15 * t)
        # 火苗中线随高度轻微摇曳(S 形)
        sway = lean * w * (t ** 2) + 0.18 * w * math.sin(t * math.pi) * lean
        x_center = cx + sway
        y = cy - h * t
        pts_right.append((x_center + half, y))
        pts_left.append((x_center - half, y))
    # 右侧自底向顶,左侧自顶向底,闭合
    return pts_right + list(reversed(pts_left))


def _leaf_polygon(cx, cy, length, width, angle_deg, samples=80):
    """
    生成一片叶子的轮廓(对称尖椭圆,两端收尖),围绕 (cx,cy) 旋转 angle_deg。
    沿叶子长轴方向铺点,半宽用 sin 包络两端收尖。
    """
    a = math.radians(angle_deg)
    ca, sa = math.cos(a), math.sin(a)
    right = []
    left = []
    for i in range(samples + 1):
        t = i / samples  # 0..1 沿长轴
        # 沿长轴坐标:-length/2 .. +length/2
        u = (t - 0.5) * length
        # 半宽包络:两端收尖,尖端略偏(叶形:一头更尖)
        env = math.sin(t * math.pi) ** 0.9
        half = (width / 2.0) * env
        # 局部坐标 (u, +-half) → 旋转 → 平移
        for sign, bucket in ((+1, right), (-1, left)):
            lx, ly = u, sign * half
            wx = cx + lx * ca - ly * sa
            wy = cy + lx * sa + ly * ca
            bucket.append((wx, wy))
    return right + list(reversed(left))


def _leaf_midrib(cx, cy, length, angle_deg):
    """叶脉:沿叶子长轴的一条直线(返回两端点)。"""
    a = math.radians(angle_deg)
    ca, sa = math.cos(a), math.sin(a)
    half = length * 0.40
    x0, y0 = cx - half * ca, cy - half * sa
    x1, y1 = cx + half * ca, cy + half * sa
    return [(x0, y0), (x1, y1)]


def draw_graphic(canvas_px, scale):
    """
    在透明 RGBA 画布上绘制「新叶环抱火苗」图形,图形整体直径 ≈ canvas_px * scale。
    返回 RGBA Image(透明底)。坐标使用超采样像素。
    """
    px = canvas_px * SS
    img = Image.new("RGBA", (px, px), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    cx = px / 2.0
    cy = px / 2.0
    R = (px * scale) / 2.0  # 图形外接半径

    # —— 两片叶子:自底部向上、向外环抱火苗 ——
    leaf_len = R * 1.55
    leaf_wid = R * 0.62
    # 左叶:叶心位于画面左下,长轴指向左上;右叶镜像。
    leaf_specs = [
        # (相对中心的叶心 x 偏移, y 偏移, 长轴角度°)
        (-R * 0.46, R * 0.42, -58.0),  # 左叶,向左上伸展
        (R * 0.46, R * 0.42, 58.0),    # 右叶,向右上伸展
    ]
    for ox, oy, ang in leaf_specs:
        lx, ly = cx + ox, cy + oy
        poly = _leaf_polygon(lx, ly, leaf_len, leaf_wid, ang)
        d.polygon(poly, fill=PRIMARY_CONTAINER + (255,))
        # 叶缘暗调描边(克制,低 alpha)
        d.line(poly + [poly[0]], fill=ON_PRIMARY_CONTAINER + (70,),
               width=max(1, int(px * 0.004)), joint="curve")
        # 叶脉
        rib = _leaf_midrib(lx, ly, leaf_len, ang)
        d.line(rib, fill=ON_PRIMARY_CONTAINER + (90,),
               width=max(1, int(px * 0.006)))

    # —— 中心火苗:三层(外焰暖橙 → 内焰琥珀黄 → 芯白)——
    flame_base_y = cy + R * 0.30   # 火苗底部(略低于中心,被叶托起)
    flame_h = R * 1.18             # 外焰总高
    flame_w = R * 0.50             # 外焰半宽

    # 外焰(暖橙)
    outer = _flame_polygon(cx, flame_base_y, flame_w, flame_h, lean=0.10)
    d.polygon(outer, fill=TERTIARY + (255,))
    # 内焰(琥珀黄),更小更窄,底部上抬
    inner = _flame_polygon(cx, flame_base_y - flame_h * 0.04,
                           flame_w * 0.58, flame_h * 0.74, lean=0.12)
    d.polygon(inner, fill=MACRO_FAT + (255,))
    # 芯(白色高光),小水滴
    core = _flame_polygon(cx, flame_base_y - flame_h * 0.10,
                          flame_w * 0.26, flame_h * 0.42, lean=0.10)
    d.polygon(core, fill=ON_PRIMARY + (235,))

    # 缩小回目标尺寸(抗锯齿)
    return img.resize((canvas_px, canvas_px), Image.LANCZOS)


def build_full_icon(size=1024):
    """商店 / iOS / launcher:墨绿圆角渐变底 + 图形(自带圆角,完整不透明)。"""
    px = size * SS
    # 径向渐变底:中心 secondary(略亮)→ 边缘 primary(深),做轻立体光。
    bg = radial_gradient((px, px), inner=SECONDARY, outer=PRIMARY,
                         center=(px * 0.5, px * 0.42))
    bg = bg.convert("RGBA")
    # 圆角遮罩(iOS squircle 近似:半径 ≈ 22.37%)
    mask = rounded_mask((px, px), radius=int(px * 0.2237))
    base = Image.new("RGBA", (px, px), (0, 0, 0, 0))
    base.paste(bg, (0, 0), mask)
    base = base.resize((size, size), Image.LANCZOS)

    # 图形:占画布 ~80%(留四角安全区,避免 squircle 裁切)
    graphic = draw_graphic(size, scale=0.80)
    base.alpha_composite(graphic)
    return base


def build_foreground(size=1024):
    """Android 自适应前景:透明底,仅图形居中 ~70%(落在 66% 安全圆内有余量)。"""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    graphic = draw_graphic(size, scale=0.70)
    canvas.alpha_composite(graphic)
    return canvas


def build_splash(size=512):
    """启动页中心 logo:透明底,仅图形居中 ~82%。"""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    graphic = draw_graphic(size, scale=0.82)
    canvas.alpha_composite(graphic)
    return canvas


def _save(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, "PNG")
    print("written:", os.path.relpath(path, _REPO_ROOT), img.size)


def main():
    _save(build_full_icon(1024), OUT_ICON)
    _save(build_foreground(1024), OUT_FOREGROUND)
    _save(build_splash(512), OUT_SPLASH)
    print("done. 3 assets generated (pure PIL, zero bitmaps).")


if __name__ == "__main__":
    main()
