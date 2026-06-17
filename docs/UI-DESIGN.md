# UI/UX 设计规范 · AI 饮食热量记录 v1

> 状态:**已出图,待人类确认门(DESIGN REVIEW)**。由 `ui-ux-designer` 产出,下游 `frontend-engineer`(Flutter)在通过人类确认后据此还原。
> 上位法:`CLAUDE.md`(宪法,最高效力);需求来源:`docs/PRD.md`(FROZEN,尤其第 5 章视觉提示词 + §4.8 多语言/RTL);数据形态来源:`docs/API.md`(FROZEN,DTO/三态/错误码)。
> 客户端 = **Flutter 双端**,所有设计令牌映射到 **Material 3 `ThemeData`**(非 React Native Paper);组件按 Flutter Material 3 体系描述。
> **任何与本规范不符的前端视觉都视为 bug。** 所有视觉数值来自令牌,杜绝逐页 hardcode;所有文字走 i18n key,禁硬编码。

---

## 0. 对标 App 与一句话气质(定基调)

### 0.1 对标 App 与借鉴/取舍
| 对标 App | 借鉴点 | 本 App 如何取舍融合 |
|---|---|---|
| **Yazio**(饮食/热量) | 顶部**大号热量进度环**作为情绪锚点;清新色系、圆角卡片、宏量(蛋白/碳水/脂肪)三色小条;空态友好插画 | 沿用「进度环 + 三宏量条」作为首页核心;但弱化其会员付费引导(v1 无付费墙),色调更克制不花哨 |
| **Cal AI / 同类「拍照识餐」App** | **拍照即录零摩擦**主入口(醒目 FAB);AI 识别结果以**可编辑卡片**呈现而非黑盒 | 沿用拍照主入口 + 可编辑确认卡片;但**强制免责声明条**、低置信度视觉标记,规避「精确医疗数值」合规风险 |
| **iOS 健康 / Google Fit** | 系统级的**克制留白、清晰信息层级、无暗黑激励**的健康工具气质;分段控件做日/趋势切换 | 沿用「工具感、可信、不焦虑」气质与分段控件;趋势图用品牌色简洁柱状+折线,不堆砌数据 |

### 0.2 一句话设计气质
> **「清新可信的健康记录工具:大留白、柔和圆角、清新绿主色 + 暖橙食物点缀,进度环为情绪锚点,克制不焦虑、零暗黑模式(指交互层面 dark pattern,且不做深色主题)。」**

后续所有视觉决策回扣这句:清新(绿/青)、可信(免责声明+可编辑)、轻盈(留白+圆角)、不焦虑(正向激励不攻击)。

---

## 1. 设计原则(5 条)

1. **拍照即录,核心路径 ≤3 步**(对齐宪法 + PRD §1.3):主操作 FAB「记录一餐」放拇指热区(底部中部),从首页到保存一餐 = 点 FAB → 拍/确认 → 保存。次要操作不抢视觉权重。
2. **可信而非黑盒**:AI 结果一律「可编辑卡片 + 固定免责声明 + 低置信度标记」呈现,用户掌握最终决定权;全程不出现医疗/诊断/保证性措辞。
3. **统一设计系统,前端零设计决策**:所有颜色/字号/间距/圆角/阴影来自 §2 令牌,直接映射 Flutter `ThemeData`;组件基于 Material 3 扩展(不从零造控件)。
4. **合规即设计,拒绝暗黑模式(dark pattern)**:隐私同意默认不勾、点按区 ≥48dp;注销入口显著不淡化不隐藏 + 二次确认;权限走前置解释弹窗。绝不为留存而视觉隐藏合规入口。
5. **全球化优先(12 语言 + RTL)**:布局用方向无关的 `start/end` 语义而非 `left/right`;ar/ur 整体镜像;为俄/印地语等长文案预留弹性,按钮/标签禁截断;ja/ko 用对应字体。

---

## 2. 设计令牌(具体数值,可直接映射 Flutter `ThemeData` / Material 3)

> 设计目标:落地为 `app/lib/theme/app_theme.dart` 的 `ThemeData(useMaterial3: true, colorScheme: ...)`。下列即 Material 3 `ColorScheme` 角色色值。**仅浅色模式**(PRD C8:不做深色模式),`ThemeData.dark()` 不提供。

### 2.1 配色 · Material 3 ColorScheme(Light,Hex)

主色调:清新绿(健康/可信);辅助点缀:暖橙(食物/食欲)。

| M3 ColorScheme 角色 | Hex | 用途 |
|---|---|---|
| `primary` | `#2E7D5B` | 品牌主色(清新墨绿),主按钮、进度环主弧、选中态 |
| `onPrimary` | `#FFFFFF` | 主色上文字/图标 |
| `primaryContainer` | `#B6E5CE` | 主色容器,Chip 选中底、轻强调块 |
| `onPrimaryContainer` | `#0A3D2A` | 主色容器上文字 |
| `secondary` | `#4E8C7A` | 次强调(青灰绿),次按钮、辅助标识 |
| `onSecondary` | `#FFFFFF` | — |
| `secondaryContainer` | `#CDE9DF` | 次容器底 |
| `onSecondaryContainer` | `#10362B` | — |
| `tertiary` | `#E07A3F` | 暖橙食物点缀色(FAB 可选高亮、碳水宏量条、食物图标点缀) |
| `onTertiary` | `#FFFFFF` | — |
| `tertiaryContainer` | `#FBDEC9` | — |
| `onTertiaryContainer` | `#4A2410` | — |
| `error` | `#BA1A1A` | 错误态、表单错误红字、注销危险按钮 |
| `onError` | `#FFFFFF` | — |
| `errorContainer` | `#FFDAD6` | 错误态背景条 |
| `onErrorContainer` | `#410002` | — |
| `surface` | `#FCFDFB` | 页面背景(极浅暖白,带一丝绿调,非纯白避免刺眼) |
| `onSurface` | `#1A1C1A` | 正文主文字 |
| `surfaceContainerLowest` | `#FFFFFF` | 卡片底(纯白浮起) |
| `surfaceContainerLow` | `#F4F7F2` | 分组背景 |
| `surfaceContainer` | `#EEF2EC` | 输入框填充底、骨架屏底 |
| `surfaceContainerHigh` | `#E8EDE6` | 选中/悬浮容器 |
| `onSurfaceVariant` | `#414941` | 次要文字、占位、图标(灰绿) |
| `outline` | `#717971` | 边框、分隔线 |
| `outlineVariant` | `#C1C9BF` | 浅分隔线 |
| `inverseSurface` | `#2F312E` | Snackbar 底色 |
| `onInverseSurface` | `#F0F1EC` | Snackbar 文字 |
| `scrim` | `#000000` @ 40% | 弹窗/抽屉遮罩 |

### 2.2 中性灰阶(7 级,辅助令牌,Hex)

| 令牌 | Hex | 用途 |
|---|---|---|
| `neutral.0` | `#FFFFFF` | 纯白(卡片) |
| `neutral.50` | `#F4F7F2` | 最浅背景 |
| `neutral.100` | `#EEF2EC` | 填充底 |
| `neutral.300` | `#C1C9BF` | 浅分隔/禁用边 |
| `neutral.500` | `#717971` | 边框/图标 |
| `neutral.700` | `#414941` | 次要文字 |
| `neutral.900` | `#1A1C1A` | 主文字 |

> 禁用态文字 = `onSurface` @ 38% 不透明度;禁用态容器 = `onSurface` @ 12%(Material 3 标准 disabled token)。

### 2.3 语义/宏量色(数据可视化专用)

| 令牌 | Hex | 用途 |
|---|---|---|
| `macro.protein` | `#3D7DCA` | 蛋白质宏量条/折线(蓝) |
| `macro.carbs` | `#E07A3F` | 碳水宏量条/折线(暖橙,= tertiary) |
| `macro.fat` | `#E0B73F` | 脂肪宏量条/折线(琥珀黄) |
| `semantic.success` | `#2E7D5B` | 成功(= primary) |
| `semantic.warning` | `#C98A14` | 低置信度标记、提示 |
| `progressRing.track` | `#E8EDE6` | 进度环底环(未完成弧) |
| `progressRing.over` | `#E07A3F` | 超过目标时进度环转暖橙提示(不报警红,不焦虑) |

### 2.4 字体层级(Typography · 映射 M3 `TextTheme`)

字体族:**多脚本无衬线**,确保 12 语言覆盖:
- 拉丁/西里尔/天城文/孟加拉文/阿拉伯/乌尔都:**Noto Sans** 家族(`Noto Sans`, `Noto Sans Arabic`(ar/ur), `Noto Sans Devanagari`(hi), `Noto Sans Bengali`(bn))。
- 中日韩:`Noto Sans SC`(zh)、`Noto Sans JP`(ja)、`Noto Sans KR`(ko)。
- Flutter 实现:`fontFamilyFallback` 按当前 locale 动态置顶对应 Noto 字体,保证字形正确不豆腐块。数字优先用拉丁字形(tabular figures)对齐。

| M3 TextStyle | 字号/行高(sp) | 字重 | 用途 |
|---|---|---|---|
| `displaySmall` | 36 / 44 | 600 | 进度环中心大数字(已摄入 kcal)、目标大数字输入 |
| `headlineSmall` | 24 / 32 | 600 | 页面主标题 |
| `titleLarge` | 22 / 28 | 600 | 弹窗标题、卡片大标题 |
| `titleMedium` | 16 / 24 | 600 | 卡片标题、列表项主文字、按钮文字 |
| `bodyLarge` | 16 / 24 | 400 | 正文、输入框文字 |
| `bodyMedium` | 14 / 20 | 400 | 次要正文、列表项副文字 |
| `bodySmall` | 12 / 16 | 400 | 免责声明、辅助说明、时间戳 |
| `labelLarge` | 14 / 20 | 600 | 按钮/Chip/Tab 标签 |
| `labelSmall` | 11 / 16 | 500 | 角标、单位、置信度标记 |

> **文案弹性**:按钮/标签容器最小高度固定,文字超长时**两行换行或缩字号**而非截断(`maxLines` + `TextOverflow` 禁用 `ellipsis` 用于关键 CTA;关键合规文案绝不截断)。CJK 行高略增(ja/ko/zh 用 1.5×)。

### 2.5 间距阶梯(8pt 基准网格)

| 令牌 | 值(dp) | 用途 |
|---|---|---|
| `space.xxs` | 4 | 图标与文字贴合 |
| `space.xs` | 8 | 紧凑内边距 |
| `space.sm` | 12 | 卡片内元素间距 |
| `space.md` | 16 | **默认页面水平边距**、卡片内边距 |
| `space.lg` | 24 | 区块间距 |
| `space.xl` | 32 | 大区块/页眉下方 |
| `space.xxl` | 48 | 空态插画上下留白 |

> 页面统一水平安全边距 `space.md = 16`;列表项垂直内边距 12;卡片间距 12。

### 2.6 圆角(Shape · 映射 M3 `shapes`)

| 令牌 | 值(dp) | 用途 |
|---|---|---|
| `radius.xs` | 8 | 小 Chip、标记 |
| `radius.sm` | 12 | 输入框、Snackbar |
| `radius.md` | 16 | **卡片、Bottom Sheet 顶角、列表卡** |
| `radius.lg` | 24 | 大弹窗、底部抽屉 |
| `radius.full` | 999 | 主按钮(全圆角胶囊)、FAB、Chip、进度环端帽 |

> 气质要求「柔和圆角」:卡片统一 16,主按钮用胶囊全圆角(亲和、现代)。

### 2.7 阴影(Elevation · M3 tonal elevation 优先)

Material 3 以 **tonal(色调叠加)** 为主、投影为辅。

| 令牌 | M3 Elevation | 视觉 | 用途 |
|---|---|---|---|
| `elevation.0` | 0 | 无 | 页面背景、贴底元素 |
| `elevation.1` | 1 | 极轻 tonal + 投影 y1 blur3 @8% | 卡片、列表卡 |
| `elevation.2` | 3 | tonal + 投影 y2 blur6 @10% | FAB、悬浮主按钮 |
| `elevation.3` | 6 | tonal + 投影 y4 blur12 @12% | 弹窗、Bottom Sheet |

> 投影色 `#1A1C1A`(onSurface)按不透明度控制,克制不重。

### 2.8 暗黑模式说明(Dark Theme)
- **v1 不提供深色主题**(PRD C8)。`ThemeData` 仅注册 light;`MaterialApp.darkTheme` 留空或指向同一 light theme,`themeMode: ThemeMode.light` 锁定,避免系统深色下出现未设计的反色。
- 文档中「拒绝暗黑模式」另指**交互层面 dark pattern**(欺骗性设计),见 §7,与深色主题是两件事。

---

## 3. 组件规范(Flutter Material 3)

> 全部基于 M3 内置组件扩展;给出尺寸/间距/圆角/色彩与各状态。点按目标 **≥48×48dp**(Material 最小,满足 iOS 44pt 要求;合规勾选区另强制 ≥48dp)。

### 3.1 按钮(M3 Button 家族)
| 类型 | Flutter 组件 | 高度 | 圆角 | 色彩 | 用途 |
|---|---|---|---|---|---|
| 主按钮 | `FilledButton` | 56(关键 CTA)/ 48(常规) | `radius.full` | bg `primary` / 文字 `onPrimary` | 注册、保存、确认 |
| 次按钮 | `OutlinedButton` | 48 | `radius.full` | 边 `outline` / 文字 `primary` | 取消、暂不 |
| 文字按钮 | `TextButton` | 40 | — | 文字 `primary` | 协议链接、轻操作 |
| 危险按钮 | `FilledButton`(error 色) | 48 | `radius.full` | bg `error` / 文字 `onError` | 确认注销 |
| FAB | `FloatingActionButton.extended` | 56 | `radius.full` | bg `primary` / icon+文字 `onPrimary` | 记录一餐 |

**按钮各状态**(以主 FilledButton 为例):
- enabled:bg `primary`;
- hovered/focused:叠加 `onPrimary` @8% state layer;
- pressed:叠加 `onPrimary` @12% + 轻缩放 0.98(120ms);
- disabled:bg `onSurface@12%`、文字 `onSurface@38%`(知情同意未勾选时主按钮此态);
- loading:文字替换为 20dp `CircularProgressIndicator`(onPrimary 色),按钮禁点。

### 3.2 输入框(`TextField`,filled 风格)
- 形态:M3 filled,`fillColor` = `surfaceContainer`,圆角 `radius.sm`,高度 56;
- label 浮动;聚焦时下边框/描边 `primary` 2dp;
- 错误态:描边 `error`,下方 `bodySmall` 红字(如 `auth.email.invalid`);图标可选错误图标;
- 密码框:尾部 `IconButton` 眼睛切换可见(`visibility`/`visibility_off`);
- 占位/help:`onSurfaceVariant`;
- RTL:label、文字、错误提示、尾部图标整体镜像(尾部图标移到 start 侧)。

### 3.3 卡片(`Card`,列表卡 / 餐次卡 / 食物项卡)
- bg `surfaceContainerLowest`(白),圆角 `radius.md`,`elevation.1`,内边距 16;
- 卡间距 12;卡内主标题 `titleMedium`、副文字 `bodyMedium onSurfaceVariant`;
- 餐次卡:左缩略图(48×48,圆角 12)+ 中(餐次名 + 条目数)+ 右(该餐合计 kcal,`titleMedium primary`);
- RTL:缩略图移到 end→start 镜像,kcal 数字保持 LTR 字形但整体块右对齐。

### 3.4 列表项(`ListTile`)
- 最小高度 56;左 leading 图标 24dp(`onSurfaceVariant`)/ 标题 `titleMedium` / trailing(箭头 `chevron_right` 或开关);
- 分隔:`outlineVariant` 1dp 或留白分组;
- **方向图标 `chevron_right` 在 RTL 翻转为 `chevron_left`**;
- 危险项(注销):标题文字 `error` 色 + leading 图标 `error` 色(见 §7.2)。

### 3.5 Chip(`FilterChip` / `ChoiceChip`)
- 用于餐次选择(早/午/晚/加餐)、语言选择、活动量选择;
- 高度 36,圆角 `radius.full`,内边距水平 12;
- 未选:边 `outline`、文字 `onSurfaceVariant`、底透明;
- 选中:底 `primaryContainer`、文字 `onPrimaryContainer`、前置 `check` 图标;
- 点按区扩展到 ≥48dp(透明 padding 补足)。

### 3.6 Tab / 分段控件
- 底部主导航:`NavigationBar`(M3),3 项 Today/History/Profile;高度 80;选中项图标填充 + indicator pill(`secondaryContainer`)+ 标签 `labelMedium`;未选 `onSurfaceVariant`;
- 页内日/趋势切换:`SegmentedButton`(M3),两段(`history.tab.day` / `history.tab.trend`),选中 `secondaryContainer`;
- **RTL:NavigationBar 项顺序与 SegmentedButton 段顺序整体镜像**(Today 在最右起始)。

### 3.7 进度环(自定义 `CustomPainter`,首页核心)
- 直径 200dp,环宽 16dp,端帽圆形(`StrokeCap.round`);
- 底环 `progressRing.track`;进度弧 `primary`;超目标时弧色转 `progressRing.over`(暖橙,不报警);
- 起始角:LTR 从顶部 12 点钟顺时针;**RTL 从顶部逆时针**(方向镜像);
- 中心:`displaySmall` 已摄入 kcal + `bodySmall` 「/ 目标 kcal」+ 下方剩余文案 `summary.remaining`;
- 进度动画:入场 800ms `easeOutCubic` 从 0 扫到当前值。

### 3.8 宏量条(三色细条)
- 蛋白/碳水/脂肪三条,高 6dp,圆角 full,底 `surfaceContainer`,填充各 `macro.*` 色;
- 上方 `labelSmall` 名称 + 克数(数字 LTR)。

### 3.9 空态(Empty State)
- 居中:插画 120dp(线性友好风,清新绿/暖橙,见 §9 图标)+ `titleMedium` 主文案 + `bodyMedium` 副文案 + 主按钮 CTA;
- 首页空态:`home.empty.cta`「拍下你的第一餐」+ FAB 高亮;
- 历史空态:`common.empty`「暂无数据」。

### 3.10 骨架屏(Skeleton,加载态首选)
- 用 `surfaceContainer` 底块 + shimmer(微光从 start→end 扫过,RTL 反向,1200ms 循环);
- 形状镜像真实布局:进度环→灰圆;餐次卡→灰圆角矩形(高 72)×3;识别结果→食物项卡灰块 ×2;
- **优先骨架屏而非转圈**(仅按钮内/瞬时操作用 `CircularProgressIndicator`)。

### 3.11 Snackbar(`SnackBar`)
- 底色 `inverseSurface`,文字 `onInverseSurface` `bodyMedium`,圆角 `radius.sm`,贴底 + `space.md` 边距,浮起于 NavigationBar 之上;
- 含可选 action(`primary` 反色文字,如「重试」`common.retry`);
- 错误用 Snackbar 承载网络/超时类瞬时错误(`common.error.network` 等);保存成功 Snackbar 反馈;
- 时长:普通 4s,带 action 6s;RTL 镜像、action 在 start 侧。

### 3.12 弹窗 / 底部抽屉
- 居中弹窗:`Dialog`,圆角 `radius.lg`,`elevation.3`,内边距 24,标题 `titleLarge` + 正文 `bodyMedium` + 按钮行(次按钮 start / 主按钮 end);
- 底部抽屉:`showModalBottomSheet`,顶角 `radius.lg`,顶部 32×4 拖拽指示条;录入方式选择用此;
- 遮罩 `scrim` 40%;RTL 整体镜像,抽屉从底部升起(方向不变,内部元素镜像)。

---

## 4. 信息架构与导航

### 4.1 Tab + 栈结构
```
MaterialApp (locale-aware, Directionality 由 locale 决定 LTR/RTL)
│
├─ [未登录栈 Guest]
│   ├─ Splash 启动页
│   ├─ Onboarding 引导页(首启)
│   ├─ Auth 登录/注册页 ──(链接)──> Terms 用户协议页 / Privacy 隐私政策页
│   └─ (Web 注销说明页 — 公网,非 App 内栈)
│
└─ [已登录 · 底部 NavigationBar 3 Tab]
    │   ┌─────────────┬──────────────┬──────────────┐
    │  Today 首页     History 历史    Profile 我的
    │   │             │              │
    │   │  进度环      日/趋势分段     设置列表
    │   │  餐次卡列表   日视图→条目详情  ├─ 个人资料
    │   │  FAB「记录一餐」              ├─ 每日目标 → 目标设定页
    │   │   │                          ├─ 通知设置
    │   │   └─(BottomSheet)            ├─ 单位偏好
    │   │      ├─ 拍照 →[前置授权弹窗]→ 相机页    ├─ 语言切换(12 选择器)
    │   │      ├─ 相册 →[前置授权弹窗]→ 相册选图  ├─ 用户协议 / 隐私政策
    │   │      └─ 文字 → 文字输入页              ├─ 关于
    │   │            │                          ├─ 退出登录
    │   │            └→ AI 识别结果确认页(可编辑+免责)→ 保存 → 回首页
    │   │                                       └─ ⚠ 注销账号 → 注销二次确认流
    │   └─ 权限前置解释弹窗(相机/相册/通知,通用组件,先于系统弹窗)
    └─
```

### 4.2 导航规则
- 已登录直达 Today;未登录走 Splash→(首启)Onboarding→Auth。
- FAB 仅在 Today 显示(底部居中偏右,拇指热区);弹 BottomSheet 三入口。
- 返回手势:遵循平台;**RTL 下系统返回方向与返回箭头自动镜像**(Flutter `Directionality` + `AppBar` 自动处理 `Icons.arrow_back`)。
- Tab 顺序 LTR=Today/History/Profile;**RTL 镜像为 Profile/History/Today**(Flutter `NavigationBar` 在 RTL 自动反序)。

---

## 5. 关键页面布局(ASCII 线框 + 区块说明 + 三态)

> 线框为 LTR 示意;RTL 下整体水平镜像(见 §8)。所有文案标 i18n key。

### 5.1 登录 / 注册页(A1/A2/A4 + 知情同意 §4.1)
```
┌─────────────────────────────┐
│            [Logo]            │  App Logo
│   Snap your meal. Know …     │  价值主张(品牌语,i18n)
│                              │
│  ┌────────────────────────┐  │
│  │ auth.field.email       │  │  邮箱输入(filled,错误态红字)
│  └────────────────────────┘  │
│  ┌────────────────────────┐  │
│  │ auth.field.password  👁 │  │  密码(可见切换+强度提示 auth.password.weak)
│  └────────────────────────┘  │
│           auth.forgotPassword │  文字按钮(Should)
│                              │
│  ☐ auth.consent.label        │  ← 默认未勾!点按区≥48dp
│    《auth.consent.terms》     │     《auth.consent.privacy》可点链接
│  ┌────────────────────────┐  │
│  │  auth.signup.title      │  │  主按钮 FilledButton(未勾选=disabled 灰)
│  └────────────────────────┘  │
│  ───────  or  ───────        │  分隔
│  ┌────────────────────────┐  │
│  │   auth.apple.signin    │  │  ← iOS 必显,Apple 官方黑底白字样式
│  └────────────────────────┘  │
│  (Google 按钮 v1 不出现)      │
└─────────────────────────────┘
```
- **区块**:Logo+价值主张 / 表单 / 知情同意 / 主 CTA / Apple 登录。
- **合规**:勾选框默认 `false`,未勾选时主按钮 disabled(灰);Apple 按钮仅 iOS 渲染,样式遵循 Apple HIG(黑底白字胶囊,等宽于主按钮)。
- **三态**:登录/注册提交 → 按钮 loading 态;失败 → Snackbar(`auth.error.invalidCredentials` / `common.error.network`),表单字段级错误用红字。

### 5.2 首页 Today(S1 进度环 + 餐次列表 + FAB)
```
┌─────────────────────────────┐
│ home.today · Jun 16   🔥5d   │  日期(Intl 本地化)+ streak(Should,克制)
│                              │
│          ╭───────╮           │
│         ╱  1230   ╲          │  进度环:displaySmall 已摄入
│        │ /2000kcal │         │  中心 summary.consumed / goal
│         ╲ 770 left ╱         │  summary.remaining({{kcal}})
│          ╰───────╯           │
│   ▓▓▓protein ▓▓carbs ▓fat    │  三宏量条(macro.*)
│                              │
│  meal.breakfast    420 kcal  │  餐次卡(缩略图+合计)
│  [🍳] 2 items          >     │
│  meal.lunch        610 kcal  │
│  [🍜] 3 items          >     │
│  meal.dinner       — 未记录   │  未记录餐次:浅灰占位
│                              │
│              ╭──────────────╮│
│              │ + home.fab    ││  FAB.extended「记录一餐」
│              │   .addMeal    ││  底部居中偏 end(拇指区)
│              ╰──────────────╯│
└─────────────────────────────┘
   [Today] [History] [Profile]   NavigationBar
```
- **三态**:
  - 加载:进度环→灰圆骨架,餐次卡→3 个灰块骨架;
  - 空(当日无记录):进度环显示 0/目标,餐次区显示空态插画 + `home.empty.cta`「拍下你的第一餐」+ FAB 脉冲高亮;
  - 错误(汇总拉取失败):进度环位置显示错误占位 + `common.error.generic` + 重试按钮。

### 5.3 录入方式选择(BottomSheet)+ 相机/文字页(§4.3)
```
BottomSheet:
┌─────────────────────────────┐
│           ▁▁▁▁               │  拖拽条
│  [📷] capture.method.photo   │  大图标+文案,点按≥56高
│  [🖼] capture.method.gallery │
│  [✍] capture.method.text     │
└─────────────────────────────┘

文字页:
┌─────────────────────────────┐
│ ← capture.method.text        │
│ ┌────────────────────────┐   │
│ │ capture.text.placeholder│  │  多行输入,示例占位
│ │                         │  │
│ └────────────────────────┘   │
│ ┌────────────────────────┐   │
│ │   capture.cta.recognize │  │  主按钮「识别」
│ └────────────────────────┘   │
└─────────────────────────────┘
```
- 拍照/相册点击 →**先弹权限前置解释弹窗(§7.3)**→允许→系统权限弹窗→相机/相册。
- 相机页:全屏取景 + 底部快门(72dp 圆)+ 切相册角标;RTL 下切换入口镜像。

### 5.4 AI 识别结果确认页(核心页,F4/F5/F6 §4.6)
```
┌─────────────────────────────┐
│ ← recognize.result.title     │
│ [缩略图 若有]                 │  原图缩略(最小化留存,不上传URL)
│ ┌──────────────────────────┐ │
│ │ Beef noodles        🖊 🗑 │ │  食物名(可改)+ 编辑/删
│ │ recognize.item.serving:1份 │ │  份量(可调,带单位)
│ │ 520 kcal · P22 C68 F16    │ │  热量+宏量
│ │ ⚠ recognize.lowConfidence │ │  低置信度标记(confidence<阈值)
│ └──────────────────────────┘ │
│ ┌──────────────────────────┐ │
│ │ Fried egg           🖊 🗑 │ │
│ │ ... 90 kcal · P6 C1 F7    │ │
│ └──────────────────────────┘ │
│  + recognize.item.addManual  │  文字按钮:手动添加一项
│                              │
│ 餐次: [早][午●][晚][加餐]      │  ChoiceChip(智能默认 suggestedMealType)
│ ─────────────────────────────│
│ ⓘ recognize.disclaimer        │  ← 固定免责声明条(bodySmall,常驻)
│ ┌──────────────────────────┐ │
│ │       common.save         │ │  主按钮「保存」
│ └──────────────────────────┘ │
└─────────────────────────────┘
```
- **区块**:缩略图 / 可编辑食物项卡列表 / 加项 / 餐次选择 / **免责声明条(常驻不可关)** / 保存。
- **免责声明**:`recognize.disclaimer` 用 `bodySmall onSurfaceVariant` + ⓘ 图标,固定在保存按钮上方,不可隐藏。
- **三态**:
  - 加载(识别中):整页骨架(食物项卡灰块 ×2)+ 顶部 `recognize.loading`「AI 正在识别…」;
  - 空:理论不空(失败走错误);
  - 错误(`RECOGNIZE_FAILED` 422):插画 + `recognize.error.failed` +「重试」+「手动添加」入口(F8 兜底,不闪退);
  - 超限(`RECOGNIZE_LIMIT_REACHED` 429):提示 `recognize.limit.reached`;超时(`TIMEOUT`):`common.error.timeout` + 重试。

### 5.5 历史 / 趋势页(S2/S5)
```
┌─────────────────────────────┐
│  [ history.tab.day | trend ] │  SegmentedButton
│ ◀  Jun 16, 2026  ▶           │  日期选择器(趋势态隐藏)
│                              │
│ 日视图:                      │
│  当日汇总条 1230/2000 kcal    │
│  meal.breakfast  ...    >    │  条目列表(点进详情编辑/删)
│  meal.lunch      ...    >    │
│                              │
│ 趋势视图:                    │
│  ▁▃▅▂▆▄█  近7天热量柱状      │  柱状(primary),目标线虚线
│  ╱╲╱ 蛋白/碳水/脂肪折线       │  macro.* 三色折线
└─────────────────────────────┘
```
- **三态**:加载→柱状/列表骨架;空→`common.empty` 插画;错误→`common.error.generic`+重试。
- **RTL**:日期 ◀▶ 箭头镜像;**柱状图 X 轴从右向左**(最近日期在 start=右),折线方向镜像。

### 5.6 目标设定页(S3 + S4 估算 §4.6)
```
┌─────────────────────────────┐
│ ← goal.title                 │
│ ┌──────────────────────────┐ │
│ │        2000               │ │  大数字输入(displaySmall)
│ │        kcal               │ │
│ └──────────────────────────┘ │
│ ▸ goal.estimate.cta「帮我估算」│  展开折叠区(Should)
│   ┌ 展开 ─────────────────┐  │
│   │ 性别 [♂●][♀] 年龄 ___  │  │  ChoiceChip + 输入
│   │ goal.field.height ___  │  │
│   │ goal.field.weight ___  │  │
│   │ goal.field.activity ▾  │  │
│   │ 目标[减][维持●][增]     │  │
│   │ → 建议值 2350 kcal      │  │  estimate 结果
│   │ [采用]                  │  │  一键采用→PUT goal
│   └────────────────────────┘  │
│ ⓘ goal.disclaimer             │  ← 固定免责声明小字
│ ┌──────────────────────────┐ │
│ │       common.save         │ │
│ └──────────────────────────┘ │
└─────────────────────────────┘
```
- **免责声明**:`goal.disclaimer` 常驻;估算措辞「建议参考值」,可改非强制。
- **三态**:估算调用 loading→按钮转圈;失败→Snackbar `common.error.generic`。

### 5.7 个人中心 / 设置页(C1–C7 + §4.2 注销)
```
┌─────────────────────────────┐
│  [头像]  alice          🖊   │  头像+昵称(可编辑)
│ ─────────────────────────────│
│  👤 settings.profile      >  │
│  🎯 goal.title            >  │
│  🔔 settings.notifications ⚪ │
│  ⚖ settings.units         >  │
│  🌐 settings.language  EN >  │  → 12 语言选择器
│  📄 settings.terms        >  │
│  🔒 settings.privacy      >  │
│  ⓘ settings.about         >  │
│ ─────────────────────────────│
│  [ auth.logout ]             │  退出登录(OutlinedButton)
│                              │
│  ⚠ account.delete.entry      │  ← 注销:error 色文字,显著不隐藏!
└─────────────────────────────┘
   [Today] [History] [Profile]
```
- **语言选择器**(点 settings.language):全屏/抽屉列表,12 项,当前语言高亮(check + `primaryContainer`),含 `settings.language.systemDefault`「跟随系统」;切到 ar/ur 即时 RTL 重布局(无需重启);ja/ko LTR。
```
settings.language.title
 ● English (en)        ✓
 ○ 中文 (zh)
 ○ हिन्दी (hi)
 ○ Español (es)  ○ Français (fr)
 ○ العربية (ar) [RTL]  ○ বাংলা (bn)
 ○ Português (pt)  ○ Русский (ru)
 ○ اردو (ur) [RTL]  ○ 日本語 (ja)  ○ 한국어 (ko)
 ─ settings.language.systemDefault
```
- **注销入口**:`account.delete.entry` 用 `error` 色 `titleMedium` + ⚠ 图标,放在退出登录下方独立分组,**字号正常、对比度达标、不淡化不折叠**(§7.2)。

### 5.8 账号注销二次确认流(§4.2 红线)
```
┌─────────────────────────────┐
│           ⚠(error 大图标)   │
│   account.delete.title        │  titleLarge「确认注销账号?」
│                              │
│   account.delete.warning      │  bodyMedium 风险正文(不可逆/彻底删除)
│                              │
│ ┌────────────────────────┐   │
│ │ account.delete.confirmHint│ │  ← 须输入密码(Apple用re-auth)
│ │ [密码输入框]            │   │
│ └────────────────────────┘   │
│  account.delete.web(网页通道)│  文字链接(Apple 要求)
│ ┌──────────┐ ┌────────────┐  │
│ │ common.   │ │account.delete│ │  取消(次)│ 确认注销(error 危险色)
│ │ cancel    │ │.confirmBtn  │ │
│ └──────────┘ └────────────┘  │
└─────────────────────────────┘
```
- **确认按钮**:`account.delete.confirmBtn` 用 `error` 色 FilledButton,**需用户主动输密码**才可点(空密码时 disabled);
- 成功 → Toast/Snackbar `account.delete.success` → 清凭证回登录页;
- **禁暗黑模式**:取消按钮不得比确认按钮更显眼以诱导留存(两按钮等权,确认用危险色但不弱化);网页注销通道链接清晰可见。

### 5.9 权限前置解释弹窗(通用组件 §4.3)
```
┌─────────────────────────────┐
│         (📷 图标)            │
│   perm.camera.title           │  titleLarge「需要使用相机」
│   perm.camera.body            │  bodyMedium 说明为什么需要
│ ┌──────────┐ ┌────────────┐  │
│ │perm.notNow│ │ perm.allow  │ │  暂不(次)│ 允许(主)
│ └──────────┘ └────────────┘  │
└─────────────────────────────┘
```
- 三套文案:相机 `perm.camera.*` / 相册 `perm.photos.*` / 通知 `perm.notify.*`;
- **「允许」后才触发系统权限弹窗**;被拒后再次进入显示 `perm.openSettings`「去设置开启」引导,不强迫;
- 「暂不」降级:引导改用其他录入方式(不闪退,F8 精神)。

---

## 6. 三态总览表(对齐 API DTO / 错误码,宪法 §5)

| 页面 | 加载(骨架优先) | 空 | 错误(messageKey) |
|---|---|---|---|
| 首页汇总 | 进度环+餐次卡骨架 | `home.empty.cta` 插画+FAB高亮 | `common.error.generic`+重试 |
| 识别结果 | 食物项卡骨架+`recognize.loading` | — | `recognize.error.failed`(422)+手动添加;`recognize.limit.reached`(429);`common.error.timeout`(504) |
| 历史日视图 | 列表骨架 | `common.empty` | `common.error.generic`+重试 |
| 历史趋势 | 图表骨架 | `common.empty` | `common.error.network`(503) Snackbar |
| 目标设定 | 输入区即时 | — | `common.error.generic` Snackbar |
| 登录/注册 | 按钮 loading | — | `auth.error.invalidCredentials` / `auth.consent.required` / 字段级红字 |

---

## 7. 合规性专项视觉规范(强制,拒绝暗黑模式 dark pattern)

### 7.1 知情同意勾选(§4.1)
- 组件:`Checkbox`(M3),**默认 `false` 不得预勾选**;
- **点按热区 ≥48×48dp**(`Checkbox` + 包裹 `InkWell`/`GestureDetector` padding 补足到 48);
- 标签 `auth.consent.label` 内嵌《用户协议》《隐私政策》为 `primary` 色可点链接(`RichText` + `TapGestureRecognizer`);
- 未勾选时主 CTA `disabled`(灰);点 CTA 若未勾可附 Snackbar `auth.consent.required`;
- **严禁**「点击注册即代表同意」隐式替代显式勾选。

### 7.2 账号注销入口 + 二次确认(§4.2)
- **入口显著**:`account.delete.entry` 文字 `error` 色 `titleMedium`(16sp 正常字号,非缩小)+ ⚠ leading 图标;对比度 ≥4.5:1;放设置页可见位置,**不藏多层折叠/不外链深处/不淡化**;
- **二次确认**:大弹窗,风险正文 `account.delete.warning` 完整告知不可逆;**须主动输密码**才能点确认;确认按钮 `error` 危险色;
- **反 dark pattern**:取消与确认两按钮视觉等权(不把取消做得超大诱导放弃注销);提供网页注销通道链接 `account.delete.web` 清晰可见;
- 成功 `account.delete.success` 反馈后清本地凭证回登录页。

### 7.3 权限前置解释弹窗(§4.3)
- 自定义 `Dialog`(非系统弹窗),先于系统权限请求出现;
- 三套文案见 §5.9;**「允许」后才调系统权限**;按钮点按区 ≥48dp;
- 仅在用户主动触发对应功能时弹(相机=点拍照、相册=点相册、通知=开通知开关/首次保存后问一次),**绝不启动时盲目索取**;
- 被永久拒绝→`perm.openSettings` 引导但不强迫,核心功能降级可用(改文字录入)。

### 7.4 免责声明(§4.6 医疗红线)
- 识别结果页 `recognize.disclaimer`、目标页 `goal.disclaimer` **固定常驻**,`bodySmall onSurfaceVariant` + ⓘ 图标,不可关闭/隐藏;
- 全 App 文案禁出现「诊断/治疗/医疗/保证减重」等措辞(文案侧由 i18n + 评审把关)。

---

## 8. RTL 适配规范(ar / ur 整体镜像;ja / ko 为 LTR §4.8)

### 8.1 总原则
- Flutter 用 `Directionality`(由 locale 决定 `TextDirection.rtl/ltr`),布局一律用方向无关 API:`EdgeInsetsDirectional`(`start/end` 而非 `left/right`)、`AlignmentDirectional`、`PositionedDirectional`;**禁用** `EdgeInsets.only(left:)` 这类硬编码方向。
- ar/ur:`TextDirection.rtl`,整体镜像;ja/ko:`TextDirection.ltr`,仅切字体(`Noto Sans JP/KR`)不镜像。

### 8.2 镜像清单
| 元素 | LTR | RTL(ar/ur) |
|---|---|---|
| 文本主对齐 | start=左 | start=右 |
| 列表项 leading/trailing | 图标左、箭头右 | 镜像:图标右、箭头左 |
| 方向图标 `arrow_back`/`chevron_right`/`arrow_forward` | 原向 | **水平翻转**(Flutter 自动 + 自定义图标用 `Transform.flip` 或 `matchTextDirection`) |
| 无方向图标(相机/删除/齿轮/相册) | — | **不翻转** |
| NavigationBar Tab 顺序 | Today→History→Profile | 反序(自动) |
| SegmentedButton 段序 | Day→Trend | 反序 |
| 进度环扫描方向 | 顶部顺时针 | 顶部逆时针 |
| 趋势柱状/折线 X 轴 | 左→右(旧→新) | 右→左(旧→新) |
| BottomSheet/骨架 shimmer | start→end 扫光 | end→start |
| 返回手势/AppBar 返回键 | 左侧 | 右侧(自动) |

### 8.3 混排(BiDi)
- 数字、`kcal`、克数、`P22 C68 F16`、品牌名等 LTR 片段嵌入 RTL 文本时,依赖 Flutter/ICU 双向算法正确显示;关键数值用 `Directionality(textDirection: ltr)` 局部包裹避免乱序;
- 单位与数字组合(如「2000 kcal」)整体作为 LTR run。

### 8.4 文案弹性(避免截断,12 语言)
- 俄/印地语/孟加拉语等通常更长:按钮/Chip/标签容器**最小高度固定、宽度自适应**,文案超长**两行换行或自动缩字号**(`FittedBox`/`AutoSizeText` 类策略),**关键 CTA 与合规文案禁 `ellipsis` 截断**;
- CJK(zh/ja/ko)行高用 1.5×;阿拉伯/天城文字形较高,行高预留充裕(M3 行高已含余量);
- 验收交 `qa-debugger`:ar/ur 镜像正确、无截断、无 BiDi 乱序、方向图标正确翻转(PRD §4.8.2)。

---

## 9. 交付前端的 UI Tokens(供 Flutter 直接读取)

> 直接落 `app/lib/theme/`:`app_colors.dart` / `app_text_theme.dart` / `app_dimens.dart` / `app_theme.dart`。

### 9.1 颜色(Hex,= §2.1/2.2/2.3)
```dart
// ColorScheme(Light)关键值
primary            #2E7D5B
onPrimary          #FFFFFF
primaryContainer   #B6E5CE
secondary          #4E8C7A
tertiary           #E07A3F   // 暖橙食物点缀
error              #BA1A1A
surface            #FCFDFB
surfaceContainer   #EEF2EC
onSurface          #1A1C1A
onSurfaceVariant   #414941
outline            #717971
outlineVariant     #C1C9BF
inverseSurface     #2F312E   // Snackbar
// 宏量
macroProtein       #3D7DCA
macroCarbs         #E07A3F
macroFat           #E0B73F
warning            #C98A14   // 低置信度
progressTrack      #E8EDE6
progressOver       #E07A3F
```

### 9.2 圆角 / 间距 / 字号(= §2.4–2.6)
```
radius:  xs8  sm12  md16  lg24  full999
space:   xxs4 xs8 sm12 md16 lg24 xl32 xxl48
text(sp/lh/w): displaySmall 36/44/600 · headlineSmall 24/32/600 ·
  titleLarge 22/28/600 · titleMedium 16/24/600 · bodyLarge 16/24/400 ·
  bodyMedium 14/20/400 · bodySmall 12/16/400 · labelLarge 14/20/600 · labelSmall 11/16/500
elevation: 0 / 1 / 3 / 6
hitTarget: ≥48dp(合规勾选/弹窗按钮强制)
```

### 9.3 核心图标列表(Material Symbols / `Icons`)
| 图标 | Flutter `Icons` | 用途 | RTL 翻转 |
|---|---|---|---|
| 相机 | `photo_camera` | 拍照入口/权限 | 否 |
| 相册 | `photo_library` | 相册入口/权限 | 否 |
| 文字 | `edit_note` | 文字录入 | 否 |
| 加号 | `add` | FAB 记录一餐 | 否 |
| 返回 | `arrow_back` | AppBar 返回 | **是** |
| 前进/箭头 | `chevron_right` | 列表项 | **是** |
| 编辑 | `edit` | 食物名/昵称编辑 | 否 |
| 删除 | `delete_outline` | 删条目 | 否 |
| 餐次 | `restaurant` `local_cafe` | 餐次/加餐 | 否 |
| 进度/火苗 | `local_fire_department` | streak | 否 |
| 蛋白/碳水/脂肪 | 三色条(非图标) | 宏量 | 否 |
| 通知 | `notifications` | 通知设置/权限 | 否 |
| 语言 | `language` | 语言切换 | 否 |
| 单位 | `straighten` | 单位偏好 | 否 |
| 隐私 | `lock` | 隐私政策 | 否 |
| 协议 | `description` | 用户协议 | 否 |
| 关于 | `info` | 关于/免责声明ⓘ | 否 |
| 警示 | `warning_amber` | 注销/低置信度 | 否 |
| 眼睛 | `visibility`/`visibility_off` | 密码可见切换 | 否 |
| 勾选 | `check` | 选中态/语言当前项 | 否 |
| Apple | Apple 官方 logo 资产 | Sign in with Apple | 否 |

### 9.4 动效提示
| 动效 | 时长 / 曲线 | 说明 |
|---|---|---|
| 进度环入场 | 800ms easeOutCubic | 从 0 扫到当前值 |
| 页面转场 | 300ms M3 SharedAxis(平台默认) | iOS 用 Cupertino 滑入,Android M3 |
| 按钮按压 | 120ms,scale 0.98 + state layer | 反馈 |
| 骨架 shimmer | 1200ms 循环 linear | RTL 反向 |
| Snackbar 进出 | 250ms easeOut | 贴底升起 |
| BottomSheet | 300ms easeOutCubic | 从底部升起 |
| FAB 空态脉冲 | 1500ms 循环 | 仅首页空态提示拍照 |
| 语言切换 RTL 重布局 | 即时 + 200ms 淡入 | 无需重启 |

---

## 10. 验收对照(本规范自检)
- [x] 点名 3 个对标 App + 借鉴/取舍;一句话气质明确(§0)。
- [x] 设计令牌全为具体数值(Hex/sp/dp),可直接映射 Flutter M3 `ThemeData`,前端无需再做设计决策(§2/§9)。
- [x] 覆盖 PRD 所有 Must 页面:登录注册(Apple+同意)、首页(进度环+餐次+FAB)、录入三入口、识别确认(可编辑+免责)、历史(日+趋势)、目标设定、设置(12 语言+注销)、注销二次确认、权限前置弹窗(§5)。
- [x] 每屏 ASCII 线框 + 三态(加载骨架优先/空/错误,对齐 API 错误码 messageKey)(§5/§6)。
- [x] 合规三项视觉齐全:知情同意默认不勾+点按≥48dp(§7.1)、注销入口显著+二次确认(§7.2)、相机/相册/通知前置解释弹窗(§7.3);免责声明常驻(§7.4);无深色主题、无 dark pattern。
- [x] RTL 专项:方向无关 API、镜像清单、BiDi 混排、文案弹性防截断;ja/ko LTR 仅切字体(§8)。
- [x] 文案全走 i18n key(对齐 PRD §6 / API §0.3 messageKey),无硬编码。
- [x] 组件基于 Material 3(NavigationBar/SegmentedButton/FilledButton/Checkbox/Chip 等),不从零造控件。

> **下一步**:本规范处于「人类确认门」,未经人类明确确认**不得交 `frontend-engineer`**。确认清单见交付消息。

---

## 11. 视觉增强层 v1.1(真机走查后,人类确认方向:清新渐变+柔光色斑+图标)

> 背景:首版功能到位但留白偏多。增强原则——**全部代码绘制、零位图素材**(规避版权、可上架、任意分辨率清晰),克制不过度,不破坏对比度(WCAG AA)与「不焦虑」气质。所有色值集中 `app_colors` token,禁逐页 hardcode。

### 11.1 渐变背景 + 柔光色斑(`AppGradientBackground`)
- 极淡垂直渐变:`surface → primaryContainer`(约 18–25% alpha),作页面底。
- 2–3 个柔光色斑:`RadialGradient`(中心色→透明,柔边,**不用模糊滤镜**省性能);右上 `primary @ 6–8%`、左下 `tertiary @ 6%`;位于内容下层,`IgnorePointer` 不拦手势。
- 应用范围:登录/注册、今日、历史、目标、个人中心。
- token:`gradientTop / gradientBottom / blobPrimary(+Transparent) / blobTertiary(+Transparent)`。

### 11.2 今日页 hero
- **问候条**:按本地时段「早上好/下午好/晚上好 👋」(i18n `home_greeting_morning/afternoon/evening`)作页面 hero;日期只在顶栏出现一次(避免重复)。
- **进度环**:描边用 `primary→tertiary` `SweepGradient`(超目标仍转暖橙单色,不报警红)。
- **宏量行**:每项名称前加对应宏量色小圆点(蛋白蓝/碳水橙/脂肪黄)。

### 11.3 图标与质感
- 主操作配图标:记录一餐 `photo_camera`、保存 `check`、目标 `local_fire_department`。
- logo 置于 `primaryContainer` 圆形底 + 柔阴影;个人中心顶部用户区做浅色卡片。
- 空态升级:`primaryContainer` 圆底 + 主图标插画组合;CTA 可带图标。
- 卡片柔和阴影(elevation 1–2)+ 16 圆角,保持一致。

### 11.4 不回退红线(增强不得破坏)
历史标题=历史/History、注册同意行内联可点链接(无重复)、注销入口居中红色显著可发现、空态隐藏 FAB、合规三项视觉、RTL 方向无关。
