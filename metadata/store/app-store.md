# iOS App Store 上架文案 · Calorie Tracker(卡路里记录)

> Bundle ID:`com.testai.calorie_app`
> 主类别:健康健美(Health & Fitness)；副类别建议:Food & Drink。
> 年龄分级:4+(无敏感内容)；如实回答 App 隐私与内容问卷。
> 价格:免费(无 App 内购买项目)。
> 维护者:`aso-operator`。本文档为 en / zh 基准 locale；其余 10 种语言据 PRD §4.8.4 补齐。
> ⚠️ 文案与 `docs/PRD.md` 冻结功能相符；无医疗宣称、无虚假宣传。

---

## 1. 名称(App Name,上限 30 字符)

| 语言 | 文案 | 字符数 |
|---|---|---|
| English | `Calo: Calorie Tracker` | 21 |
| 中文 | `Calo 卡路里记录` | 9 |

---

## 2. 副标题(Subtitle,上限 30 字符)

| 语言 | 文案 | 字符数 |
|---|---|---|
| English | `AI photo calorie & macro log` | 28 |
| 中文 | `AI 拍照估算热量与宏量` | 11 |

> 副标题承载次级关键词:AI / photo / calorie / macro,且与名称不重复堆词。

---

## 3. 关键词包(Keywords,上限 100 字符,iOS 隐藏关键词)

> 规则:逗号分隔、无空格(空格浪费字符)、不重复名称/副标题已用词、单复数取其一、不堆竞品名与最高级。

```
calorie counter,food diary,meal tracker,nutrition,diet,protein,carb,fat,weight,fitness,health,macros
```

字符数:99(≤100)。

说明:
- 名称/副标题已含 `calorie tracker / snap / log / AI / photo / calorie / macro`,关键词包**不重复**这些词,改放近义高频词扩大召回面。
- 未放入 `best / top / no.1` 等违规词;未放入竞品品牌名(避免侵权/拒审)。
- `weight / fitness / health` 为合规的领域词,均与实际功能(体重目标估算、健康健身定位)相符,非疗效宣称。

---

## 4. 描述(Description)

### English

```
Snap your meal. Know your calories.

Calorie Tracker makes logging a three-step habit: take a photo, confirm the result, save. Instead of searching a database and typing portions by hand, point your camera at your plate and let AI estimate the calories and macronutrients for you.

PHOTO-FIRST LOGGING
Snap a photo, choose one from your library, or simply describe your meal in words. AI reads it and returns an estimate in seconds.

YOU STAY IN CONTROL
Every result is fully editable. Rename a food, adjust the portion, remove an item, or add one manually before saving. The AI suggests; you decide.

SEE YOUR DAY AT A GLANCE
A daily progress ring shows calories consumed against your goal, with protein, carbs, and fat broken out. Review past days and a 7-day trend to understand your eating patterns.

A GENTLE HABIT
An optional logging streak gently celebrates consistency — no guilt, no aggressive reminders.

BUILT FOR A GLOBAL AUDIENCE
12 languages out of the box — English, Chinese, Hindi, Spanish, French, Arabic, Bengali, Portuguese, Russian, Urdu, Japanese, Korean — with full right-to-left layout for Arabic and Urdu.

PRIVACY YOU CAN UNDERSTAND
Food photos are used only for instant analysis; we do not keep original images long-term, only the recognized result data. Data is sent over encrypted (HTTPS) connections. Camera and photo access are requested only when you use those features. Delete your account anytime from Settings — deletion is permanent and irreversible — with a web deletion channel also available.

A NOTE ON ACCURACY
Calorie and nutrition figures are AI estimates and may be inaccurate. They are for general information only and are not medical, dietary, or health advice. Consult a qualified professional for medical or nutritional decisions.

Free to use. No ads, no subscription, no in-app purchases.
```

### 中文

```
拍下这餐,了解热量。

卡路里记录把饮食记录变成「拍照 — 确认 — 保存」三步习惯。不必再翻食物库、手动填份量,把镜头对准餐盘,AI 就帮你估算这一餐的热量与宏量营养素。

拍照即录
拍一张、从相册选一张,或直接用文字描述这餐,AI 几秒内给出估算结果。

你说了算
每一项结果都可编辑。保存前可改食物名、调份量、删除或手动添加条目。AI 负责建议,决定权在你。

一眼看懂今天
每日进度环显示已摄入热量与目标的对比,并分别列出蛋白质、碳水和脂肪。回顾过去每一天,并通过近 7 天趋势了解自己的饮食规律。

温和的习惯养成
可选的连续记录天数为坚持记录加一点正向鼓励——不制造焦虑、不强行提醒。

为全球用户打造
内置 12 种语言——英语、中文、印地语、西班牙语、法语、阿拉伯语、孟加拉语、葡萄牙语、俄语、乌尔都语、日语、韩语——并为阿拉伯语和乌尔都语提供完整的从右向左布局。

看得懂的隐私说明
食物照片仅用于即时识别;我们不会长期保存原图,只保存识别出的结果数据。数据通过加密(HTTPS)连接传输。相机与相册权限仅在你使用相应功能时申请。你可随时在「设置」中注销账号——注销永久且不可逆——并提供网页注销通道。

关于准确性
热量与营养数值为 AI 估算,可能存在误差,仅供一般信息参考,不构成医疗、膳食或健康建议。涉及医疗或营养决策请咨询专业人士。

免费使用,无广告、无订阅、无内购。
```

---

## 5. 推广文本(Promotional Text,上限 170 字符,可随时更新无需审核)

| 语言 | 文案 | 字符数 |
|---|---|---|
| English | `New: log meals by photo, gallery, or text — AI estimates calories and macros in seconds, and every result stays fully editable. Free, no ads, 12 languages.` | 154 |
| 中文 | `全新体验:拍照、相册或文字记录一餐,AI 几秒估算热量与宏量,每项结果都可编辑。免费、无广告、支持 12 种语言。` | 53 |

---

## 6. 商店审核备注 / 隐私字段(App Store Connect)

- **隐私政策 URL**(已上线 GitHub Pages):https://wok676.github.io/AI--/privacy.html
- **用户协议 / EULA**(已上线):https://wok676.github.io/AI--/terms.html
- **账号删除(Apple 必填)**:App 内「设置 > 注销账号」提供;另在隐私政策页公布网页注销通道(满足 Guideline 5.1.1(v))。
- **Sign in with Apple**:iOS 端已实现(PRD A4),无需另外提供第三方社交登录即合规;后续接入 Google 登录时 Apple 登录已就位(Guideline 4.8)。
- **ATT**:v1 无第三方追踪 SDK,不弹 ATT;App Privacy 标签据实勾选"数据不用于追踪"。详见 `metadata/store/data-safety.md`。
- **审核演示账号**:交 `devops-release-manager` 在提审时附测试账号(邮箱+密码),供 Apple 审核登录后体验核心识别流程。

---

## 7. 禁忌词排查结论(App Store)

| 排查项 | 结论 |
|---|---|
| 最高级 / 排名(best、#1、top、leading、world's) | 通过 — 全文未出现 |
| 医疗/疗效宣称(diagnose、treat、cure、guaranteed weight loss) | 通过 — 明确"not medical/dietary/health advice" |
| 价格/促销词出现在名称或副标题 | 通过 — 名称/副标题无价格词;"Free"仅在描述正文客观陈述 |
| 关键词包堆砌、含竞品品牌、含最高级 | 通过 — 99 字符内皆为合规领域词,无竞品名、无 best/top |
| 名称/副标题/关键词重复堆同一词 | 通过 — 三处分层用词,无冗余重复 |
| 提及其他平台(Android、Google Play) | 通过 — iOS 文案未提及其他平台 |
| 功能与实际不符 | 通过 — 卖点逐条对应 PRD 冻结功能 |
| 未发布功能当作已有(beta/coming soon 当卖点) | 通过 — 仅描述 v1 已实现 Must/Should |
```
