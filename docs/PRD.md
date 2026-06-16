# PRD · AI 饮食热量记录(AI Calorie / Diet Tracker)

> 状态:**已冻结(FROZEN）**——人类架构师已在「需求确认门」拍板,本 PRD 据最终决策增量更新后冻结,可交 `architect` 做技术选型与 API/DB 契约。
> 冻结日期:2026-06-16(补充:语言扩至 12 种含日韩)。
> 主责:`product-manager`。下游:`ui-ux-designer`(读第 5 章)、`architect`(读全文,冻结 API/DB 契约)。
> 上位法:`CLAUDE.md`(项目宪法,最高效力)。本 PRD 只管「做什么 / 怎么交互」,技术选型与 API/DB 字段由 `architect` 定。
>
> **既定约束(架构师已拍板,不可推翻)**:
> - App:AI 饮食热量记录;客户端 **Flutter 双端(iOS + Android)**。
> - v1(MVP):**免费,无订阅 / 无广告 / 无内购 / 无第三方追踪**;仅核心功能。
> - v1 **有账号体系 + 后端**(已定:AI 识别必须走后端代理保护密钥;**登录后饮食记录云端存储、跨设备同步**)。
> - 目标市场:**出海,v1 支持 12 种主流语言(全球使用人数前十 + 日语、韩语)**(en/zh/hi/es/fr/ar/bn/pt/ru/ur/ja/ko),其中 **ar、ur 为 RTL**;ja、ko 均为 LTR(详见 §4.8 多语言与 RTL 适配专项)。
> - AI 视觉模型:本项目默认 Claude(具体接入由 `architect` / `backend-engineer` 决定)。
>
> **本轮(冻结前最后一次)确认落实的最终决策**:
> 1. 账号体系:确定要账号 + 后端,登录后饮食记录云端存储、跨设备。
> 2. 登录:v1 = 邮箱密码 + **Sign in with Apple(iOS,Must)**;Google 登录降为 Should/后续。
> 3. 食物原图:**最小化留存**——识别后默认不长期保存原图,仅存结构化识别结果。
> 4. 目标智能估算(Mifflin-St Jeor + 免责声明):进 **Should**,明确非医疗建议。
> 5. streak 连续记录:进度环 Must;streak 进 **Should**,不做焦虑/暗黑激励。
> 6. 每日识别次数:v1 设宽松上限 + 友好提示(具体数值「待架构定值」)。
> 7. **多语言扩大为 12 种主流语言(全球使用人数前十 + 日语、韩语)+ RTL 适配**(新增 §4.8)。

---

## 1. 产品概述与核心价值

### 1.1 产品定位
**一句话**:拍一张照,就知道这顿吃了多少热量。
**定位**:面向大众的「**饮食记录与热量参考工具**」(lifestyle / health & fitness 辅助记录类),**非医疗、非诊断、非治疗产品**。
**口号(候选)**:Snap your meal. Know your calories.(拍下这餐,了解热量)

### 1.2 目标用户与痛点
| 用户画像 | 核心痛点 | 本 App 的解法 |
|---|---|---|
| 想控制体重 / 增肌减脂的上班族 | 传统记账类 App 要手动搜索食物、填份量,太繁琐,记两天就放弃 | 拍照即录,AI 自动出食物 + 热量 + 宏量,几秒完成 |
| 健康意识人群 | 不知道一餐大致摄入多少、营养是否均衡 | 每日热量 / 蛋白 / 碳水 / 脂肪汇总 + 趋势,直观看见 |
| 出海多语种用户 | 多数热量 App 食物库偏本地、英文/中文割裂,小语种与 RTL 体验差 | AI 视觉识别不依赖固定食物库;v1 原生支持 12 种主流语言(全球使用人数前十 + 日语、韩语),含 ar/ur 的 RTL 镜像布局 |

### 1.3 核心亮点(留存与体验优化项,2–3 个)
1. **「拍照即录」零摩擦录入**:相机 → 识别 → 一屏确认 → 入库,核心路径 ≤ 3 步(对齐宪法「核心路径 ≤3 步」)。这是与传统手动记账类的核心差异点。
2. **AI 结果「可编辑确认」而非「不可信黑盒」**:识别结果以可编辑卡片呈现(改名 / 调份量 / 删项 / 加项),用户掌握最终决定权,既提升准确度也降低对 AI 误差的焦虑——同时是规避「宣称精确医疗数值」合规风险的产品手段。
3. **轻量「连续记录」正反馈**:首页**今日进度环为 Must**;**连续记录天数 streak 为 Should**。做正向激励但**不做攻击性 push、不做焦虑营销、不做暗黑(dark pattern)激励**(健康类合规友好)。

### 1.4 商业化预留(v1 不实现,仅设计留口)
- 数据模型与权限模型预留 `plan = free | pro`(由 `architect` 在 DB 设计时落位,PRD 仅声明意图)。
- 未来 Pro 可能解锁:更高每日识别次数、更长历史趋势(如年视图)、导出报表、自定义宏量目标比例。
- **v1 不出现任何价格、付费墙、"升级 Pro"按钮**,避免审核期对「免费」描述与实际不符。商业化 UI 与文案待后续版本另开 PRD。

---

## 2. 完整功能清单(Feature List)

> 优先级:**Must**(MVP 必交,可独立验收)/ **Should**(MVP 尽量带,排期紧可降级)/ **Could**(后续版本)。
> 「归属/可见角色」用于支撑宪法 §6 纵向(RBAC)+ 横向(归属)鉴权,交 `architect` 冻结契约。
> 角色定义见第 2.4 节。

### 2.1 账号与鉴权
| # | 功能 | 优先级 | 归属 / 可见角色 |
|---|---|---|---|
| A1 | 邮箱 + 密码注册(含密码强度提示、邮箱格式校验) | Must | 游客可注册;成功后为本人 `user` |
| A2 | 邮箱 + 密码登录 | Must | 游客 |
| A3 | 退出登录 | Must | 本人 `user` |
| A4 | **Sign in with Apple**(iOS 端,因引入第三方/社交登录而强制,见 §4.5) | Must(iOS) | 游客 |
| A5 | Google 登录 | Should | 游客 |
| A6 | 忘记密码 / 邮箱重置密码 | Should | 游客 |
| A7 | 邮箱验证(注册后验证邮箱归属) | Should | 本人 `user` |
| A8 | **账号注销 / 数据彻底删除**(双端红线,见 §4.2) | Must | 本人 `user`(仅本人可注销本人账号) |
| A9 | 修改密码 | Should | 本人 `user` |

> **已定**:v1 登录方式 = **邮箱密码(Must)+ Sign in with Apple(iOS,Must)**;**Google 登录降为 Should/后续**。v1 即便不上 Google,iOS 端因含 Apple 登录是主动提供的便捷登录、且无其他第三方社交登录,合规无冲突;后续若上 Google,Apple 登录已就位(满足 Guideline 4.8)。

### 2.2 核心业务:饮食识别与记录
| # | 功能 | 优先级 | 归属 / 可见角色 |
|---|---|---|---|
| F1 | **拍照录入**:调起相机拍摄一餐 → 上传后端 → AI 识别 | Must | 本人 `user`,记录 `ownerId = 本人` |
| F2 | **相册选图录入**:从相册选一张图 → 识别 | Must | 本人 `user` |
| F3 | **文字描述录入**:输入「一碗牛肉面 + 一个鸡蛋」→ AI 解析 | Must | 本人 `user` |
| F4 | **AI 识别结果展示**:食物项列表 + 每项热量(kcal)+ 蛋白/碳水/脂肪(g) | Must | 本人 `user` |
| F5 | **结果可编辑确认**:改食物名、调份量(份/克/常见单位)、删除某项、手动新增一项 | Must | 本人 `user` |
| F6 | **AI 估算免责声明**:识别结果页固定展示「热量为 AI 估算,仅供参考」(见 §4.6) | Must | 全体 |
| F7 | **按餐归类**:保存时选 早餐/午餐/晚餐/加餐,默认按当前时间智能推荐 | Must | 本人 `user`,记录归属 `mealEntry` |
| F8 | **识别失败兜底**:AI 无法识别 / 超时 → 友好提示 + 「手动添加」入口(零崩溃,宪法 §1.2) | Must | 本人 `user` |
| F9 | 识别置信度提示(低置信度食物项加视觉标记,提醒用户核对) | Should | 本人 `user` |
| F10 | 每日识别次数软限制(**已定:v1 设宽松上限 + 友好提示,具体数值「待架构定值」**;为成本控制与商业化预留) | Should | 本人 `user` |
| F11 | 收藏 / 快速复用常吃食物(再次记录一键带入) | Could | 本人 `user` |
| F12 | 条码扫描包装食品 | Could | 本人 `user` |

### 2.3 汇总、历史与目标
| # | 功能 | 优先级 | 归属 / 可见角色 |
|---|---|---|---|
| S1 | **每日汇总**:当日总热量 + 蛋白/碳水/脂肪合计,对比每日目标(进度环) | Must | 本人 `user` |
| S2 | **日视图历史**:按日期查看某天所有餐次与条目,可编辑/删除条目 | Must | 本人 `user`(仅本人记录) |
| S3 | **每日热量目标设定**:手动输入目标 kcal | Must | 本人 `user` |
| S4 | **目标智能估算**(已定:进 Should):据身高/体重/性别/年龄/活动量/目标(减/维持/增)用公开公式 **Mifflin-St Jeor** 估算建议值,**用户可改、非强制、附「仅供参考、非医疗建议」免责声明**(见 §4.6) | Should | 本人 `user` |
| S5 | **周视图 / 趋势图**:近 7 天热量柱状 + 宏量趋势折线 | Should | 本人 `user` |
| S6 | 月视图 / 长期趋势 | Could(商业化预留) | 本人 `user` |
| S7 | 体重记录与体重趋势 | Could | 本人 `user` |
| S8 | 数据导出(CSV / 报表) | Could(商业化预留) | 本人 `user` |

### 2.4 设置与账户中心
| # | 功能 | 优先级 | 归属 / 可见角色 |
|---|---|---|---|
| C1 | 个人资料(昵称、头像、身高/体重/目标等用于 S4 的字段) | Should | 本人 `user` |
| C2 | **语言切换**(已定:**12 种语言** en/zh/hi/es/fr/ar/bn/pt/ru/ur/ja/ko,跟随系统 + 手动覆盖;切到 ar/ur 时整体布局切 RTL,ja/ko 为 LTR,见 §4.8) | Must | 全体 |
| C3 | **隐私政策入口** + **用户协议入口**(公网 URL,中英双语) | Must | 全体 |
| C4 | **账号注销入口**(显著可见,见 §4.2) | Must | 本人 `user` |
| C5 | 通知设置(开关;通知权限按需索取,见 §4.3) | Should | 本人 `user` |
| C6 | 单位偏好(kcal/kJ、克/盎司) | Should | 本人 `user` |
| C7 | 关于页(版本号、第三方开源声明、联系方式) | Should | 全体 |
| C8 | 主题(浅色;**不做深色模式**——对齐 UI 合规约定,见第 5 章) | N/A | — |

### 2.5 角色与权限模型(交 architect 冻结 RBAC)
| 角色 | 说明 | 数据可见范围 |
|---|---|---|
| **游客 Guest** | 未登录。仅可访问:启动/引导、登录注册、隐私政策/用户协议、网页注销说明页 | 无业务数据 |
| **普通用户 User** | 登录后的本人 | **仅本人**的饮食记录、汇总、目标、个人资料(横向鉴权:`where ownerId = currentUser.id`) |
| **管理员 Admin** | 管理后台,运营/客服用 | 用户账号管理(封禁/查注销状态)、内容/反馈处理、运营统计。**不得查看用户原始餐食照片与明细等敏感隐私数据**,如需排障仅限脱敏聚合(交 architect 落位最小可见原则) |

> 红线:任何用户接口必须同时过**纵向**(角色是否有权)+**横向**(数据是否归属本人)鉴权(宪法 §6)。所有饮食实体均带 `ownerId`。

### 2.6 管理后台需管理的实体(交 architect / backend)
- 用户账号(列表、状态、注销请求处理、封禁)。
- 反馈 / 举报(若 C7 含反馈入口)。
- 运营统计(DAU、识别调用量、留存等聚合,**脱敏**)。
- AI 识别调用审计(用量/失败率,用于成本与质量监控,**不含可识别个人的原图明细**)。

---

## 3. 核心页面交互流与用户旅程

### 3.1 页面清单
1. 启动页 / 引导页(首启)
2. 登录 / 注册页(含知情同意勾选)
3. 隐私政策页 / 用户协议页(应用内 + 公网)
4. 首页(今日汇总 + 录入入口)
5. 录入方式选择(拍照 / 相册 / 文字)→ 相机页 / 文字输入页
6. AI 识别结果确认页(可编辑)
7. 历史页(日视图 / 周·趋势视图切换)
8. 餐次/条目详情页(查看、编辑、删除)
9. 目标设定页
10. 个人中心 / 设置页
11. 账号注销二次确认流
12. 权限前置解释弹窗(相机 / 相册 / 通知)

### 3.2 主用户旅程(Happy Path:首次拍照记录一餐,核心路径 ≤3 步)
```
首启 → 引导页 → 登录/注册(主动勾选同意《隐私政策》《用户协议》)→ 进入首页
首页【+ 拍照】 →(首次)相机权限前置解释弹窗 → 允许 → 拍照
   → AI 识别中(加载态) → 结果确认页(可改名/调份量/删项)
   → 选餐次 → 【保存】 → 回首页,今日进度环 + 汇总即时更新
```
> 从首页到「保存一餐」的核心操作:① 点拍照 ② 拍/确认结果 ③ 保存 = 3 步达成闭环。

### 3.3 页面跳转表
| 来源页 | 触发 | 目标页 | 备注 |
|---|---|---|---|
| 启动页 | 首启完成 | 引导页 → 登录注册 | 已登录则直达首页 |
| 登录注册 | 勾选同意 + 提交 | 首页 | 未勾选则「同意并继续」禁用(见 §4.1) |
| 登录注册 | 点协议链接 | 隐私政策/用户协议页 | 可应用内查看 |
| 首页 | 点「拍照/相册/文字」 | 对应录入页 | 首次触发权限前置弹窗 |
| 录入页 | 提交图片/文字 | 识别结果确认页 | 加载/空/错误三态(宪法 §5) |
| 结果确认页 | 保存 | 首页(汇总刷新) | 失败→留页+重试 |
| 结果确认页 | 识别失败 | 手动添加表单 | 兜底,不闪退 |
| 首页 | 点历史/趋势 | 历史页 | 日↔周趋势切换 |
| 历史页 | 点某条目 | 条目详情页 | 可编辑/删除 |
| 首页/设置 | 点目标 | 目标设定页 | S3 必做,S4 估算 Should |
| 底部 Tab | 点「我的」 | 个人中心/设置页 | — |
| 设置页 | 点「账号注销」 | 注销二次确认流 | 见 §4.2 |
| 设置页 | 点隐私政策/用户协议/语言 | 对应页 | 全体可见 |

### 3.4 导航结构(建议)
**底部 Tab(3 个)**:`首页 Today` · `历史 History` · `我的 Profile`。
中间或首页主按钮放醒目的**「+ 记录一餐」**悬浮/主行动按钮(FAB),降低录入摩擦。

---

## 4. 合规性专项设计说明(强制,双端审核更严)

> 饮食/健康属敏感数据,iOS 与 Google Play 审核均更严。以下为设计源头内建的合规要求,`frontend-engineer` 须硬落地,`qa-debugger` 须专项验收。

### 4.1 知情同意流(Informed Consent)
- **位置**:注册页(及首启登录页)底部。
- **形式**:一个**默认未勾选**的复选框 + 文案:「我已阅读并同意《用户协议》和《隐私政策》」,其中两份文档为可点击链接,应用内可查看,且提供公网 URL。
- **强约束**:复选框**默认 false**,**不得预勾选**;未勾选时「同意并继续 / 注册」按钮置灰禁用。**严禁**用「点击注册即代表同意」的隐式同意替代显式勾选。
- **登录页**:若采用「注册即同意」,登录页可不再强制勾选;但首版建议在注册处显式勾选、登录处以小字声明并附链接(交 UI 细化)。

### 4.2 账号注销流(双端红线 · 数据彻底不可逆销毁)
- **入口可见性**:`设置 / 个人中心` 内有**清晰、非隐藏**的「**注销账号**」入口(不得藏在多层折叠或外链深处)。
- **二次确认**:点击 → 弹出**风险说明 + 二次确认**:
  - 明确告知:注销后**饮食记录、照片、个人资料、目标等隐私数据将被彻底、不可逆删除,且无法恢复**;
  - 要求用户**重新输入密码 / 二次确认操作**(防误触);
  - 提供「取消」与「确认注销」,确认按钮需用户**主动**操作(可加输入「DELETE」或勾选确认项)。
- **执行结果**:注销后数据按宪法 §5/§6 **彻底删除或不可逆匿名化**(具体落库与级联删除策略交 `backend-engineer`);客户端清除本地缓存/凭证并回到登录页。
- **网页端注销通道(Apple 要求)**:提供**无需登录 App 即可发起注销**的**公网网页入口**(用户在网页上验证身份后提交注销请求)。该 URL 收录进商店元数据。`metadata/` 与 `aso-operator` 负责落地链接,本 PRD 声明此为 Must。
- **第三方登录账号**:用 Apple / Google 登录的用户,注销时一并撤销关联授权并删除其在本服务的数据。

### 4.3 敏感权限按需索取(Just-in-time + 前置解释)
| 权限 | 触发时机 | 前置解释弹窗(自定义,先于系统弹窗) | 拒绝后的降级 |
|---|---|---|---|
| 相机 Camera | **用户点「拍照」时**才请求,非启动时 | 「需要相机来拍摄你的食物以便 AI 识别热量。我们只在你主动拍照时使用相机。」 | 提示并引导改用「相册」或「文字」录入,不闪退 |
| 相册 / 照片 Photos | **用户点「相册」时**才请求 | 「需要访问照片来选择食物图片进行识别。我们仅读取你选择的照片。」 | 引导改用「拍照」或「文字」,不闪退 |
| 通知 Notifications | 用户在「通知设置」开启或首次保存记录后**询问一次**(Should) | 「开启提醒,帮你养成记录习惯。可随时在设置中关闭。」 | 静默关闭通知功能,不影响核心 |
- **强约束**:**绝不在启动时一次性盲目索取所有权限**;每个权限配自定义前置解释弹窗(Pre-permission prompt),用户同意后再触发系统权限弹窗;被拒后提供「去系统设置开启」引导但不强迫。
- **不索取**:定位、麦克风、通讯录等与核心无关的权限一律**不申请**。
- iOS `Info.plist` 权限用途文案(`NSCameraUsageDescription` 等)须中英双语、明确具体(交 frontend / devops 落地)。

### 4.4 iOS ATT(App Tracking Transparency)
- v1 **无第三方广告 SDK、无跨 App/跨网站追踪、无第三方分析用于广告**。
- 结论:**v1 不需要弹出 ATT**。前提是不集成任何用于追踪的 SDK。
- `aso-operator` 在 App Privacy(隐私营养标签)中据实勾选:数据**仅用于 App 功能**,**不用于追踪**。
- 若后续接入广告/第三方追踪分析,则**必须**在追踪前弹 ATT —— 此为后续版本约束,v1 不涉及。

### 4.5 iOS 第三方登录与 Sign in with Apple(已定)
- **最终方案(已拍板)**:v1 登录 = **邮箱密码(Must)+ Sign in with Apple(iOS,Must,A4)**;**Google 登录降为 Should/后续(A5)**。
- iOS 端提供 Sign in with Apple 官方按钮;Android 端不要求 Apple 登录。
- 依据 App Store Review Guideline 4.8:后续一旦上线 Google 等第三方社交登录,Apple 登录已就位,合规无缝。Android 端 Google 登录为自然选项(Should)。

### 4.6 医疗/健康合规红线(规避医疗类审核)
- **定位严格限定为「饮食记录与热量参考工具」**:全程**不得**出现「诊断、治疗、医疗、治愈、医生建议、保证减重 X 公斤」等表述。
- AI 估算结果页与目标估算页**固定展示免责声明**:「热量及营养数据由 AI 估算,可能存在误差,仅供参考,不构成医疗、营养或健康建议。如有健康需求请咨询专业人士。」
- 目标估算(S4,已定进 Should)采用公开公式 **Mifflin-St Jeor**;结果措辞为「建议参考值」,强调可自行调整、非医疗处方,目标估算页固定展示免责声明(`goal.disclaimer`)。
- 商店元数据(`aso-operator`)同样规避医疗宣称;内容分级如实填写。
- **不收集**与核心无关的特殊类别健康数据(如疾病史);身高体重等仅用于本地/本人热量估算,纳入隐私政策说明。

### 4.7 隐私政策 / 数据安全声明要点(交 backend / devops / aso 落地)
- 隐私政策、用户协议:**12 种语言版本**(en/zh/hi/es/fr/ar/bn/pt/ru/ur/ja/ko),公网可访问 URL,应用内可查看(宪法 §8)。**合规文案(隐私/同意/注销/免责声明)翻译须人工把关,禁止机翻歧义。**
- **食物原图「最小化留存」(已定)**:识别后**默认不长期保存原图**,服务端仅在识别处理期间临时使用、处理完毕即按策略删除;**长期仅存结构化识别结果**(食物项 / 热量 / 蛋白·碳水·脂肪 / 份量 / 餐次 / 时间)。隐私政策与同意文案须**明确写明此最小化留存策略**。临时缓存的保留时长与级联删除细节交 `architect` 落库定义。
- 数据加密:饮食/健康隐私数据强加密(传输 HTTPS、敏感字段存储加密),凭证用安全存储(宪法 §5/§6)。
- Google Play **Data Safety** 表与 Apple **App Privacy** 标签据实填写:收集的数据类型、用途、是否加密、是否可删除(指向账号注销);据实声明照片**最小化留存、不长期保存原图**。

### 4.8 多语言与 RTL 适配专项(新增 · 体验与合规要求)

> 本专项为 v1 重大需求:由原中英双语扩大为**12 种主流语言(全球使用人数前十 + 日语、韩语)**,并要求**完整 RTL(从右向左)适配**。具体技术方案(locale 加载、字体、RTL 引擎)交 `architect` / `ui-ux-designer` 细化,本节定「做什么 / 体验底线」。⚠️ 提示:RTL + 12 语言显著加重 UI 与前端工作量,排期与设计令牌须提前预留。**RTL 仍只有 ar/ur 两种;新增的 ja、ko 均为 LTR,不新增 RTL 负担。**

#### 4.8.1 v1 支持语言(12 种)
| 代码 | 语言 | 书写方向 | 备注 |
|---|---|---|---|
| `en` | 英语 English | LTR | 回退语言(fallback) |
| `zh` | 中文 | LTR | 文案基准语言之一 |
| `hi` | 印地语 हिन्दी | LTR | 天城文,需对应字体 |
| `es` | 西班牙语 Español | LTR | |
| `fr` | 法语 Français | LTR | |
| `ar` | 阿拉伯语 العربية | **RTL** | 整体镜像布局 |
| `bn` | 孟加拉语 বাংলা | LTR | 孟加拉文,需对应字体 |
| `pt` | 葡萄牙语 Português | LTR | |
| `ru` | 俄语 Русский | LTR | 西里尔字母 |
| `ur` | 乌尔都语 اردو | **RTL** | 整体镜像布局 |
| `ja` | 日语 日本語 | LTR | 需对应日文字体(汉字/假名) |
| `ko` | 韩语 한국어 | LTR | 需对应韩文字体(谚文) |

#### 4.8.2 RTL 适配要求(ar / ur,作为体验与合规要求)
- **整体镜像布局**:文本对齐(主对齐切右)、行/列排布、列表项内元素顺序、进度/趋势图坐标走向在 RTL 下整体镜像。
- **图标方向**:有方向语义的图标(返回 / 前进 / 箭头 / 进度推进方向)在 RTL 下水平翻转;无方向语义的图标(相机、删除、设置齿轮)不翻转。
- **导航**:返回手势与返回按钮位置、Tab 顺序、抽屉(Bottom Sheet)展开方向遵循平台 RTL 规范。
- **混排**:数字、kcal、克数、品牌名等 LTR 片段嵌入 RTL 文本时按双向算法(BiDi)正确显示,禁止出现乱序。
- **三态与弹窗**:加载/空/错误三态、权限前置弹窗、注销二次确认弹窗在 RTL 下同样镜像且文案完整不截断。
- **验收**:`qa-debugger` 须把「ar/ur RTL 镜像正确、无文本截断、无 BiDi 乱序、方向图标正确翻转」列入双端合规专项测试。

#### 4.8.3 文案与翻译要求
- 文案项清单(第 6 章)仍以 **key + 中文 + 英文** 为基准登记;**目标交付语言为上述 12 种**,其余 10 种由 `aso-operator` / i18n 流程据 key 补齐。
- **合规与法律相关文案(隐私政策 / 用户协议 / 知情同意 / 账号注销风险提示 / 医疗免责声明)翻译须人工把关,禁止机翻产生歧义或弱化风险告知**。
- 语言切换实时生效(无需重启);首次启动跟随系统 locale,落在 12 种之外时回退 `en`。
- 文案长度差异(德/俄/印地语常更长)须在 UI 设计阶段预留弹性,避免按钮/标签截断——交 `ui-ux-designer`。

#### 4.8.4 商店元数据多语言(交 aso-operator 后续落地)
- Google Play / App Store 商店列表(标题、副标题、描述、关键词、截图文案)需覆盖 **12 种语言**;RTL 语言(ar/ur)的截图文案排版亦须镜像,ja/ko 为 LTR 常规排版。**标注交 `aso-operator` 后续落地**,本 PRD 仅声明范围。

---

## 5. 给 UI Agent 的设计提示词(交 ui-ux-designer)

> 总基调:**清爽、健康、可信、轻盈**。健康饮食类常用清新色系(绿/青为主、暖色点缀食物感),大留白、圆角卡片、友好插画。**仅浅色模式,不做深色模式**(对齐项目 UI 合规约定);点按区 ≥ 44pt;权限前置弹窗为自定义组件。三态(加载/空/错误)齐备(宪法 §5)。所有文字走 i18n,**禁止硬编码**。
>
> ⚠️ **多语言与 RTL(贯穿所有页面,见 §4.8)**:需适配 **12 种语言**(全球使用人数前十 + 日语、韩语),其中 **ar/ur 为 RTL**,ja/ko 为 LTR(需日文/韩文字体)。设计令牌与组件须支持**整体镜像布局**(对齐切右、方向图标翻转、导航/抽屉/手势遵循 RTL),并为**文案长度差异**(俄/印地语等更长)预留弹性,避免按钮/标签截断。下列每页提示词默认都附带「RTL 镜像 + 文案弹性」约束。具体 RTL 方案交 `ui-ux-designer`。

### 5.1 登录 / 注册页
- 顶部 App Logo + 一句价值主张(「拍下这餐,了解热量」)。
- 邮箱、密码输入框(密码可见切换、强度提示);主按钮「注册 / 登录」。
- **底部:默认未勾选的同意复选框** + 「《用户协议》《隐私政策》」可点链接;未勾选时主按钮置灰。
- **iOS 必显「Sign in with Apple」官方样式按钮**(已定 Must);分隔线「或」。Google 登录按钮为 Should/后续,v1 可不出现。
- 风格:大留白、品牌主色按钮、输入框圆角、错误态红字小提示。RTL 下整体镜像、Apple 按钮与文案右对齐。

### 5.2 首页(Today)
- 顶部:今日日期 + **连续记录天数 streak(Should,克制正向、不焦虑)**。
- **核心:今日热量进度环**(已摄入 / 目标 kcal),环下方三个宏量小条(蛋白/碳水/脂肪,不同色)。
- 中部:今日餐次卡片列表(早/午/晚/加餐),每卡显示该餐合计与缩略图。
- **醒目主行动按钮 FAB「+ 记录一餐」**(底部居中或右下),点击弹出录入方式选择(拍照/相册/文字)。
- 空态:无记录时友好插画 + 「拍下你的第一餐」引导。

### 5.3 录入方式选择 + 相机/文字页
- 录入选择:底部抽屉(Bottom Sheet)三大按钮:拍照 / 相册 / 文字,大图标 + 文案。
- 相机页:全屏取景 + 快门 + 切换相册入口;首次进入前先出**自定义前置解释弹窗**(见 §4.3)。
- 文字页:多行输入框 + 示例占位「例:一碗牛肉面 + 一个煎蛋」+「识别」按钮。

### 5.4 AI 识别结果确认页(核心页)
- 顶部:用户上传的图(若有)缩略。
- **可编辑食物项卡片列表**:每项 = 食物名(可改)+ 份量(可调,带单位)+ 热量 kcal + 蛋白/碳水/脂肪;每项可删除;底部「+ 手动添加一项」。
- 低置信度项:加浅色标记/提示用户核对(Should)。
- 餐次选择器(早/午/晚/加餐,智能默认)。
- **固定免责声明条**:小字「热量为 AI 估算,仅供参考……」。
- 底部主按钮「保存」;加载态(识别中骨架屏)、错误态(识别失败 + 重试 + 手动添加)。

### 5.5 历史 / 趋势页
- 顶部分段控件:日视图 / 周·趋势。
- 日视图:日期选择器 + 当天餐次条目列表(可进详情编辑/删除)+ 当日汇总。
- 趋势:近 7 天热量柱状图 + 宏量折线;简洁图表、清晰坐标、品牌色。
- 空态/加载/错误三态齐全。

### 5.6 目标设定页
- 手动输入每日目标 kcal(大数字输入)。
- 「帮我估算」展开:身高/体重/性别/年龄/活动量/目标选择 → 给建议值(可一键采用、可改)。
- **免责声明小字**:建议值仅供参考、非医疗建议。

### 5.7 个人中心 / 设置页
- 顶部:头像 + 昵称(可编辑)。
- 列表项:个人资料、每日目标、通知设置、单位偏好、**语言切换(12 种语言选择器,当前语言高亮;切到 ar/ur 即时切 RTL,ja/ko 为 LTR)**、用户协议、隐私政策、关于。
- **底部分组:醒目但克制的「注销账号」入口**(红色文字/警示色,不隐藏)。
- 退出登录按钮。

### 5.8 账号注销二次确认
- 全屏/大弹窗:警示图标 + 标题「注销账号」+ 风险正文(不可逆、彻底删除)。
- 需用户**主动确认**(输入密码或键入确认词/勾选确认项)。
- 两个按钮:次要「取消」、危险色「确认注销」。

### 5.9 权限前置解释弹窗(通用组件)
- 居中卡片:图标 + 标题(为什么需要)+ 说明文案 + 「允许 / 暂不」按钮;允许后才触发系统权限弹窗;文案见 §4.3 与第 6 章。

---

## 6. 文案项清单(i18n)

> 规则:所有用户可见文案走 `t('ns.key')`,语言包集中 `/locales`(宪法 §7)。下表以**建议 key + 中文 + 英文**为基准登记;**v1 目标交付语言为 12 种**(en/zh/hi/es/fr/ar/bn/pt/ru/ur/ja/ko),其余 10 种据 key 由 i18n 流程 / `aso-operator` 补齐(见 §4.8)。交 `frontend/backend-engineer` 落各 locale 语言包(`en.json`/`zh.json`/`hi.json`/…/`ja.json`/`ko.json`)。后端报错返回 `messageKey`,按 `Accept-Language` 渲染、回退 `en`。**禁止硬编码、禁止死文案**。动态值用插值(如 `{{count}}`)。
> ⚠️ **合规/法律文案**(`auth.consent.*`、`account.delete.*`、`recognize.disclaimer`、`goal.disclaimer` 及隐私政策/用户协议正文)**翻译须人工把关,禁止机翻歧义或弱化风险告知**。

### 6.1 通用 / 三态 / 错误
| key | 中文 | English |
|---|---|---|
| `common.continue` | 继续 | Continue |
| `common.save` | 保存 | Save |
| `common.cancel` | 取消 | Cancel |
| `common.confirm` | 确认 | Confirm |
| `common.delete` | 删除 | Delete |
| `common.edit` | 编辑 | Edit |
| `common.retry` | 重试 | Retry |
| `common.loading` | 加载中… | Loading… |
| `common.empty` | 暂无数据 | Nothing here yet |
| `common.error.generic` | 出了点问题,请稍后再试 | Something went wrong. Please try again. |
| `common.error.network` | 网络连接异常,请检查网络 | Network error. Please check your connection. |
| `common.error.timeout` | 请求超时,请重试 | Request timed out. Please try again. |

### 6.2 鉴权 / 知情同意
| key | 中文 | English |
|---|---|---|
| `auth.signup.title` | 注册 | Sign up |
| `auth.login.title` | 登录 | Log in |
| `auth.field.email` | 邮箱 | Email |
| `auth.field.password` | 密码 | Password |
| `auth.password.weak` | 密码强度较弱,建议包含字母与数字 | Weak password. Use letters and numbers. |
| `auth.email.invalid` | 邮箱格式不正确 | Invalid email address |
| `auth.consent.label` | 我已阅读并同意《用户协议》和《隐私政策》 | I have read and agree to the Terms of Service and Privacy Policy |
| `auth.consent.terms` | 用户协议 | Terms of Service |
| `auth.consent.privacy` | 隐私政策 | Privacy Policy |
| `auth.consent.required` | 请先阅读并同意协议与隐私政策 | Please read and accept the Terms and Privacy Policy first |
| `auth.apple.signin` | 通过 Apple 登录 | Sign in with Apple |
| `auth.google.signin` | 通过 Google 登录 | Sign in with Google |
| `auth.logout` | 退出登录 | Log out |
| `auth.forgotPassword` | 忘记密码 | Forgot password |
| `auth.error.invalidCredentials` | 邮箱或密码错误 | Incorrect email or password |

### 6.3 录入与 AI 识别
| key | 中文 | English |
|---|---|---|
| `capture.method.photo` | 拍照 | Take photo |
| `capture.method.gallery` | 相册 | Choose from gallery |
| `capture.method.text` | 文字描述 | Describe in text |
| `capture.text.placeholder` | 例:一碗牛肉面 + 一个煎蛋 | e.g. a bowl of beef noodles + a fried egg |
| `capture.cta.recognize` | 识别 | Analyze |
| `recognize.loading` | AI 正在识别你的食物… | Analyzing your food… |
| `recognize.result.title` | 识别结果 | Results |
| `recognize.item.calories` | 热量 | Calories |
| `recognize.item.protein` | 蛋白质 | Protein |
| `recognize.item.carbs` | 碳水 | Carbs |
| `recognize.item.fat` | 脂肪 | Fat |
| `recognize.item.serving` | 份量 | Serving |
| `recognize.item.addManual` | 手动添加一项 | Add item manually |
| `recognize.lowConfidence` | 此项识别置信度较低,请核对 | Low confidence — please double-check |
| `recognize.disclaimer` | 热量及营养数据由 AI 估算,可能存在误差,仅供参考,不构成医疗或健康建议 | Calorie and nutrition figures are AI estimates and may be inaccurate. For reference only; not medical or health advice. |
| `recognize.error.failed` | 没能识别这张图片,试试换一张或手动添加 | Couldn't recognize this image. Try another photo or add manually. |
| `recognize.limit.reached` | 今日识别次数已达上限,请明天再试 | Daily recognition limit reached. Please try again tomorrow. |

### 6.4 餐次 / 汇总 / 历史 / 目标
| key | 中文 | English |
|---|---|---|
| `meal.breakfast` | 早餐 | Breakfast |
| `meal.lunch` | 午餐 | Lunch |
| `meal.dinner` | 晚餐 | Dinner |
| `meal.snack` | 加餐 | Snack |
| `home.today` | 今日 | Today |
| `home.streak` | 已连续记录 {{count}} 天 | {{count}}-day streak |
| `home.empty.cta` | 拍下你的第一餐 | Log your first meal |
| `home.fab.addMeal` | 记录一餐 | Log a meal |
| `summary.consumed` | 已摄入 | Consumed |
| `summary.goal` | 目标 | Goal |
| `summary.remaining` | 还可摄入 {{kcal}} kcal | {{kcal}} kcal left |
| `history.tab.day` | 日 | Day |
| `history.tab.trend` | 趋势 | Trend |
| `goal.title` | 每日热量目标 | Daily calorie goal |
| `goal.estimate.cta` | 帮我估算 | Estimate for me |
| `goal.field.height` | 身高 | Height |
| `goal.field.weight` | 体重 | Weight |
| `goal.field.activity` | 活动量 | Activity level |
| `goal.disclaimer` | 估算值仅供参考,可自行调整,非医疗建议 | Estimate is for reference only, adjustable, and not medical advice. |

### 6.5 权限前置解释
| key | 中文 | English |
|---|---|---|
| `perm.camera.title` | 需要使用相机 | Camera access |
| `perm.camera.body` | 用于拍摄你的食物以进行 AI 识别。仅在你主动拍照时使用。 | To take photos of your food for AI analysis. Used only when you take a photo. |
| `perm.photos.title` | 需要访问相册 | Photo access |
| `perm.photos.body` | 用于选择食物图片进行识别。仅读取你选择的照片。 | To pick a food photo for analysis. Only the photo you select is read. |
| `perm.notify.title` | 开启提醒 | Enable reminders |
| `perm.notify.body` | 帮你养成记录习惯,可随时在设置中关闭。 | Helps you build a logging habit. You can turn it off anytime. |
| `perm.allow` | 允许 | Allow |
| `perm.notNow` | 暂不 | Not now |
| `perm.openSettings` | 去设置开启 | Open Settings |

### 6.6 设置 / 账号注销
| key | 中文 | English |
|---|---|---|
| `settings.title` | 设置 | Settings |
| `settings.language` | 语言 | Language |
| `settings.units` | 单位 | Units |
| `settings.notifications` | 通知 | Notifications |
| `settings.profile` | 个人资料 | Profile |
| `settings.terms` | 用户协议 | Terms of Service |
| `settings.privacy` | 隐私政策 | Privacy Policy |
| `settings.about` | 关于 | About |
| `account.delete.entry` | 注销账号 | Delete account |
| `account.delete.title` | 确认注销账号? | Delete your account? |
| `account.delete.warning` | 注销后,你的饮食记录、照片、个人资料与目标将被彻底、不可逆地删除,且无法恢复。 | Once deleted, your meal logs, photos, profile, and goals are permanently and irreversibly erased and cannot be recovered. |
| `account.delete.confirmHint` | 请输入密码以确认注销 | Enter your password to confirm |
| `account.delete.confirmBtn` | 确认注销 | Delete account |
| `account.delete.success` | 你的账号与数据已彻底删除 | Your account and data have been permanently deleted |
| `account.delete.web` | 你也可以在网页端注销账号 | You can also delete your account on the web |
| `settings.language.title` | 选择语言 | Choose language |
| `settings.language.systemDefault` | 跟随系统 | Follow system |
| `privacy.photo.retention` | 你的食物照片仅用于即时 AI 识别,识别后不会长期保存原图,我们仅保存识别出的结果数据。 | Your food photos are used only for instant AI analysis. Original images are not retained long-term; we keep only the recognized result data. |

> 注:动态值统一插值(`{{count}}`、`{{kcal}}` 等),禁止字符串拼接;日期/数字按 locale 用 `Intl` 格式化(宪法 §7)。CI 校验**全部 12 个 locale** key 一致性(以 en 为基准集)。

---

## 7. 验收对照(本 PRD 自检)
- [x] 覆盖核心业务闭环:录入(拍照/相册/文字)→ AI 识别 → 可编辑确认 → 按餐入库 → 每日汇总 → 历史/趋势 → 目标。
- [x] Must 功能完整、可独立验收(账号 + Apple 登录、三种录入、识别、可编辑、按餐、日汇总进度环、日历史、目标设定、12 语言切换、隐私入口、账号注销)。
- [x] 合规四项就位:知情同意(§4.1)/ 账号注销含网页通道(§4.2)/ 按需索权+前置弹窗(§4.3)/ iOS 特有 ATT(§4.4)+ Apple 登录(§4.5);另含医疗红线(§4.6)、免责声明(§4.6/§6.3)、最小化照片留存(§4.7)。
- [x] 多语言与 RTL 专项(§4.8):12 语言(全球使用人数前十 + 日/韩)+ ar/ur RTL 镜像(ja/ko 为 LTR),合规文案人工翻译要求已登记。
- [x] 每个核心页面有给 UI 的视觉提示词(第 5 章,含 RTL/文案弹性约束);用户旅程闭合(第 3 章)。
- [x] 文案项清单可交 i18n(第 6 章,12 语言目标);实体标注归属与可见角色(第 2 章),可交 architect 冻结契约。

> **冻结状态:已冻结(FROZEN,2026-06-16)**。人类架构师已在需求确认门拍板,所有 ❓ 已转为确定结论。本 PRD 可交 `architect` 做技术选型与 API/DB 契约;后续变更须走 commit 元信息标注的变更流程。
