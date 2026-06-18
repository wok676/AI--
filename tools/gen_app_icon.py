#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
App 图标 / 启动页生成器 · AI 饮食热量记录(风格 v2 ·「极简专业 · 数据导向」)
================================================================================

宪法 §视觉:**图标必须代码/矢量生成,禁止位图采购**。本脚本仅依赖 Pillow(PIL),
用纯几何形状绘制,不引入任何外部图片文件,任意分辨率重绘清晰,规避版权 / 授权问题。

设计概念(v2):**「热量进度环 + 极简火苗」**
  - 一个**接近闭合的细进度环**(数据/仪表感),单色克制墨绿强调色;
  - 环中央一枚**极简两笔火苗**(热量/卡路里语义),同强调色,克制不花哨;
  - 底:**纯净近白圆角方**(squircle),配少量极浅中性,呼应"近黑白 + 单一强调色";
  - 去掉旧版的双叶环抱 / 三层暖橙火苗 / 径向立体渐变 —— 干净、专业、数据感。

设计来源:docs/UI-DESIGN.md(§0 气质 / §2.1 配色)、app/lib/theme/app_colors.dart。
所有颜色为取自 AppColors 的十六进制常量,与全局设计令牌一致,禁另起一套。

输出
----
  app/assets/icon/icon.png            1024x1024  近白圆角底 + 进度环+火苗(商店 / iOS / launcher)
  app/assets/icon/icon_foreground.png 1024x1024  透明底,仅图形居中 ~64%(Android 自适应前景)
  app/assets/branding/splash.png       512x512   透明底,仅图形居中 ~78%(启动页中心 logo)

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
# 颜色常量(取自 app/lib/theme/app_colors.dart,十六进制,RGB)—— 极简专业盘
# ----------------------------------------------------------------------------
PRIMARY = (0x1F, 0x6E, 0x4E)            # 强调墨绿   #1F6E4E(环 + 火苗)
PRIMARY_CONTAINER = (0xE3, 0xEF, 0xE9)  # 极淡绿     #E3EFE9(环底轨)
SURFACE = (0xF7, 0xF8, 0xFA)            # 近白底     #F7F8FA
SURFACE_LOWEST = (0xFF, 0xFF, 0xFF)     # 纯白       #FFFFFF(图标底)
OUTLINE_VARIANT = (0xE6, 0xE8, 0xED)    # 极浅中性边 #E6E8ED

# ----------------------------------------------------------------------------
# 输出路径(相对仓库根)
# ----------------------------------------------------------------------------
_REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
OUT_ICON = os.path.join(_REPO_ROOT, "app", "assets", "icon", "icon.png")
OUT_FOREGROUND = os.path.join(_REPO_ROOT, "app", "assets", "icon", "icon_foreground.png")
OUT_SPLASH = os.path.join(_REPO_ROOT, "app", "assets", "branding", "splash.png")

# 超采样倍率:先在高分辨率画再缩小,得到平滑抗锯齿边缘。
SS = 4


def rounded_mask(size, radius):
    """返回圆角矩形的 L 模式遮罩(255 内 / 0 外)。"""
    m = Image.new("L", size, 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], radius=radius, fill=255)
    return m


def _flame_polygon(cx, cy, w, h, samples=140):
    """
    极简对称火苗轮廓(水滴 / 火焰形,直立不摇曳 —— 专业克制)。
    cx,cy = 火苗底部中心;w = 最宽半宽;h = 总高(向上为负 y)。
    底部圆鼓、中下最宽、顶端干净收尖。
    """
    pts_right = []
    pts_left = []
    for i in range(samples + 1):
        t = i / samples  # 0=底部 1=顶尖
        bulge = math.sin(t * math.pi) ** 0.85
        half = w * bulge * (1.0 - 0.12 * t)
        x = cx
        y = cy - h * t
        pts_right.append((x + half, y))
        pts_left.append((x - half, y))
    return pts_right + list(reversed(pts_left))


def draw_graphic(canvas_px, scale):
    """
    在透明 RGBA 画布上绘制「热量进度环 + 极简火苗」,图形整体直径 ≈ canvas_px * scale。
    返回 RGBA Image(透明底)。坐标使用超采样像素。
    """
    px = canvas_px * SS
    img = Image.new("RGBA", (px, px), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)

    cx = px / 2.0
    cy = px / 2.0
    R = (px * scale) / 2.0  # 图形外接半径

    # —— 进度环(数据/仪表感)——
    # 环底轨:整圈极淡绿;进度弧:约 78% 强调墨绿,顶部留一小缺口(进行感)。
    stroke = R * 0.165                 # 环宽(细,专业)
    ring_box = [cx - R, cy - R, cx + R, cy + R]
    # 底轨整圈
    d.arc(ring_box, start=0, end=360, fill=PRIMARY_CONTAINER + (255,),
          width=int(stroke))
    # 进度弧:从顶部(-90°)顺时针扫 ~280°,圆头端帽用小圆补足。
    sweep = 280.0
    a0 = -90.0
    a1 = a0 + sweep
    d.arc(ring_box, start=a0, end=a1, fill=PRIMARY + (255,), width=int(stroke))
    # 端帽圆头(让弧两端为圆形,精致)
    rr = stroke / 2.0
    rad_mid = (R - stroke / 2.0)
    for ang in (a0, a1):
        ex = cx + rad_mid * math.cos(math.radians(ang))
        ey = cy + rad_mid * math.sin(math.radians(ang))
        d.ellipse([ex - rr, ey - rr, ex + rr, ey + rr], fill=PRIMARY + (255,))

    # —— 中心极简火苗(同强调色,单色,克制)——
    flame_h = R * 0.92
    flame_w = R * 0.34
    flame_base_y = cy + flame_h * 0.46  # 底部略低于圆心,整体视觉居中
    flame = _flame_polygon(cx, flame_base_y, flame_w, flame_h)
    d.polygon(flame, fill=PRIMARY + (255,))
    # 火苗内挖一个近白小水滴(留白 = 内焰),保持单色却有层次。
    inner = _flame_polygon(cx, flame_base_y - flame_h * 0.06,
                           flame_w * 0.46, flame_h * 0.56)
    d.polygon(inner, fill=SURFACE_LOWEST + (255,))

    # 按实际像素包围盒自动居中(消除构图偏移,确保图形在画布正中)
    bbox = img.getbbox()
    if bbox:
        content = img.crop(bbox)
        cw, ch = content.size
        centered = Image.new("RGBA", (px, px), (0, 0, 0, 0))
        centered.paste(content, ((px - cw) // 2, (px - ch) // 2), content)
        img = centered

    return img.resize((canvas_px, canvas_px), Image.LANCZOS)


def build_full_icon(size=1024):
    """商店 / iOS / launcher:近白圆角底 + 极浅描边 + 图形(完整不透明)。"""
    px = size * SS
    # 纯净近白底(无渐变):#FFFFFF 主体,贴极浅中性 1.5% 描边强调边界。
    bg = Image.new("RGBA", (px, px), SURFACE_LOWEST + (255,))
    # 极浅内描边(squircle 内圈)增加一点精致边界,克制。
    bd = ImageDraw.Draw(bg)
    inset = int(px * 0.012)
    rad = int(px * 0.2237)
    bd.rounded_rectangle(
        [inset, inset, px - 1 - inset, px - 1 - inset],
        radius=rad, outline=OUTLINE_VARIANT + (255,), width=max(2, int(px * 0.006)),
    )
    # 圆角遮罩(iOS squircle 近似:半径 ≈ 22.37%)
    mask = rounded_mask((px, px), radius=rad)
    base = Image.new("RGBA", (px, px), (0, 0, 0, 0))
    base.paste(bg, (0, 0), mask)
    base = base.resize((size, size), Image.LANCZOS)

    # 图形:占画布 ~62%(进度环+火苗,留充裕白边 —— 极简留白)
    graphic = draw_graphic(size, scale=0.62)
    base.alpha_composite(graphic)
    return base


def build_foreground(size=1024):
    """Android 自适应前景:透明底,仅图形居中 ~64%(落在 66% 安全圆内有余量)。"""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    graphic = draw_graphic(size, scale=0.64)
    canvas.alpha_composite(graphic)
    return canvas


def build_splash(size=512):
    """启动页中心 logo:透明底,仅图形居中 ~78%。"""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    graphic = draw_graphic(size, scale=0.78)
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
