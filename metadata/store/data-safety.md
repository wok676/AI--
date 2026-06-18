# 数据安全表单填写答案 · Google Play Data Safety + iOS App Privacy

> 包名 / Bundle ID:`com.testai.calorie_app`
> 维护者:`aso-operator`。依据**实际数据流**(`docs/PRD.md` §4.4/§4.7 + `server/` 后端代码)如实填写,**不瞎填**。
> 关键事实核对来源:
> - 后端通过 `server/src/modules/recognition/claude.client.ts` 代理调用 Anthropic Messages API(`ANTHROPIC_BASE_URL` 可指向官方或**中转/代理网关**)。密钥仅在服务端(`.env`),不下发客户端。
> - 食物原图**仅在请求处理期临时持有内存,处理后立即丢弃,绝不落库**(`recognition.service.ts` finally 清引用 / `Buffer.alloc(0)`)。长期仅存结构化识别结果。
> - 传输全程 HTTPS(宪法 §6 / PRD §4.7)。
> - 账号注销:Prisma `onDelete: Cascade` 物理删除用户全部 PII 与饮食数据;识别审计表 `onDelete: SetNull` 去标识(ownerId 置空,不可逆,且本就不含原图/PII)。
> - v1 无第三方广告/追踪 SDK,数据**不用于追踪**。

---

## A. 实际数据流摘要(填表依据)

| 数据 | 是否收集 | 去向 | 留存 |
|---|---|---|---|
| 邮箱 | 是(邮箱注册);Apple 登录可能为私密中继地址或无邮箱 | 自有后端 | 账号有效期内;注销即物理删除 |
| Apple 用户标识(sub) | 是(仅 Sign in with Apple 用户) | 自有后端 | 同上 |
| 密码 | 是(邮箱注册) | 自有后端,**bcrypt 哈希存储,绝不明文** | 同上 |
| 食物照片 / 相册图 | 是(用户主动拍照/选图时) | 后端→AI 识别服务(Anthropic / 中转网关)**仅即时处理** | **不长期保存原图**;处理完即弃 |
| 文字餐食描述 | 是(用户文字录入时) | 同上(交 AI 识别) | 识别期临时使用;结构化结果入库 |
| 识别结果数据(食物名/份量/热量/宏量) | 是 | 自有后端 | 账号有效期内;注销即删除 |
| 个人资料(昵称、头像、身高、体重、性别、年龄) | 是(可选,用于目标估算 S4) | 自有后端 | 账号有效期内;注销即删除 |
| 偏好(语言、单位、每日目标、通知开关) | 是 | 自有后端 | 同上 |
| 识别用量审计(成功率/延迟/模型,**不含原图/原文/PII**) | 是 | 自有后端 | 注销后去标识保留(ownerId=NULL) |

> 不收集:精确/粗略位置、麦克风、通讯录、设备广告 ID、跨 App 追踪标识、特殊类别健康病史。

---

## B. Google Play · Data Safety 表

### B.1 总体开关
- **Does your app collect or share any of the required user data types?** → **Yes**
- **Is all of the user data encrypted in transit?** → **Yes**(全链路 HTTPS)
- **Do you provide a way for users to request that their data be deleted?** → **Yes**(App 内「设置 > 注销账号」+ 网页注销通道;物理删除)

### B.2 逐数据类型(Data type · Collected · Shared · Purpose · Optional?)

| Category | Data type | Collected | Shared | Processed ephemerally | 用途(Purpose) | 必填? |
|---|---|---|---|---|---|---|
| Personal info | Email address | Yes | No | No | Account management(账号/登录) | 注册必填 |
| Personal info | User IDs(Apple sub) | Yes | No | No | Account management | 仅 Apple 登录 |
| Personal info | Name / 其他资料(昵称) | Yes | No | No | App functionality(资料显示) | 可选 |
| Health & fitness | Health info(身高/体重/性别/年龄、热量/宏量记录) | Yes | No | No | App functionality(热量记录与目标估算) | 可选 |
| Photos and videos | Photos(食物照片) | **No(不收集)** — 见说明 | — | **Yes(ephemeral)** | App functionality(即时 AI 识别) | 可选 |
| App activity | Other user-generated content(文字餐食描述) | Yes(转为结构化结果) | No | 文字本身即时处理 | App functionality | 可选 |
| App info & performance | Crash logs / Diagnostics | 视实现(若仅本地日志可填 No) | No | — | App functionality | — |

**照片(Photos)填法说明(关键)**:
- Google Play 允许将"仅在设备/请求期临时处理、不离开即时处理用途、不被长期收集"的数据标注为 **Processed ephemerally** 而**非 Collected**。本 App 原图**仅在后端请求处理期临时存在、处理后即弃、绝不落库**,符合 ephemeral 定义。
- 因此 Photos 选 **Collected = No**,并勾选 **"Data is processed ephemerally"**。
- 由识别得到的**结构化结果**(食物名/份量/热量/宏量)按 Health & fitness 的 health info 申报为 Collected = Yes。

### B.3 数据共享(Shared with third parties)
- App **不向第三方共享用于其自身用途的数据**(无广告 SDK、不卖数据)。
- **重要如实标注**:食物照片/文字会**传输给 AI 识别服务提供方(Anthropic,或经运营配置的中转/代理网关)进行即时处理**。Google Play 将"为代你执行处理、不得另作他用的服务提供方(service provider / processor)"区别于"Sharing"——此类**通常归类为处理而非 Sharing**,但运营须确保该 AI 提供方/中转方在合同上**仅作即时处理、不留存、不另用**。
  - 若使用的中转网关**无法保证不留存/不另用**,则该数据必须改勾 **Shared = Yes** 并在隐私政策中点名披露。**上线前由 `devops-release-manager` 与运营确认中转方的数据处理条款**,据此定夺 Shared 勾选。
- 当前默认填法(基于"AI 提供方仅作即时处理"假设):Shared = No,均作为 service provider 处理。**此假设须经合同核实后方可定稿。**

### B.4 安全实践(Security practices)
- Data encrypted in transit:**Yes**(HTTPS)
- Users can request data deletion:**Yes**(App 内注销 + 网页通道,物理删除)
- 已遵循 Play 家庭政策(无儿童定向);无广告 ID。

---

## C. iOS · App Privacy(隐私营养标签)

> 三档:Data Used to Track You / Data Linked to You / Data Not Linked to You。
> v1 **无追踪** → "Data Used to Track You" 一栏为空,据实选 **Not used for tracking**。

### C.1 Data Linked to You(与用户身份关联)

| Data Type | 申报 | Purposes | Used for Tracking? |
|---|---|---|---|
| Contact Info → Email Address | Yes | App Functionality | No |
| Identifiers → User ID(Apple sub) | Yes(仅 Apple 登录) | App Functionality | No |
| Health & Fitness → Health(身高/体重/热量/宏量记录) | Yes | App Functionality | No |
| User Content → Other User Content(文字餐食描述、识别结果) | Yes | App Functionality | No |
| User Content → Photos(食物照片) | 见下方说明 | App Functionality | No |

### C.2 食物照片(Photos)填法说明
- Apple 的 App Privacy 要求申报"**collect**(传到设备外服务器并保留,或用于上述用途)"的数据。本 App 照片仅传至后端**即时识别后立即丢弃、不留存**。
- Apple 对"仅用于一次性请求处理、立即丢弃、不与用户身份长期关联、未用于追踪/广告/分析、且非用于产品个性化"的数据,**允许不申报为收集**(类似服务请求的瞬时使用豁免)。
- 因本 App 原图严格符合该瞬时处理特征:**照片可不申报为 collected**;但**结构化识别结果(健康数据)照常申报**(C.1 已含)。
- 保守可选做法:若审核团队要求,亦可将 Photos 申报为 **Data Not Linked to You · App Functionality · 不用于追踪**。两种填法均不构成虚假申报;**最终以提审沟通为准,由 `devops-release-manager` 定稿。**

### C.3 Data Not Linked to You
- Diagnostics(崩溃/性能,若收集且不关联身份)→ App Functionality;否则不勾。

### C.4 Tracking
- **Data Used to Track You:无。** v1 不集成任何广告/跨 App 追踪 SDK,据实选"App does not use data for tracking"(因此**不弹 ATT**)。

---

## D. 第三方 / 子处理方披露清单(供隐私政策与表单一致)

| 第三方 | 角色 | 接触的数据 | 数据处理性质 |
|---|---|---|---|
| AI 识别服务(Anthropic Claude;或运营配置的中转/代理网关) | 处理方(processor / service provider) | 食物照片、文字描述(**仅即时**) | 即时返回估算结果;按合同不留存、不另用。**中转方留存条款须运营核实** |
| 托管/云服务商(后端服务器、数据库) | 处理方 | 全部后端存储数据 | 仅为运行本服务存储,受访问控制 |
| Apple(Sign in with Apple) | 身份提供方 | Apple sub / 私密中继邮箱 | 仅用于身份验证 |

> 表单与隐私政策(`metadata/privacy/privacy.html` §3 第三方服务)必须**口径一致**:照片"仅即时处理、不长期保存原图"。

---

## E. 上线前待确认事项(交 devops / 运营拍板)

- [ ] 核实 AI 识别**中转/代理网关**的数据处理条款:是否留存请求内容、是否另作他用。决定 Google Play `Shared` 与隐私政策点名披露口径。
- [ ] 确认崩溃/性能日志是否上报第三方分析(若有,需在两表补充申报)。
- [ ] 隐私政策公网 URL(`privacy.html`)、用户协议 URL(`terms.html`)部署完成并填入双端后台。
- [ ] App Store Connect 账号删除项指向 App 内注销 + 网页通道。
- [ ] 提审演示账号就绪。
```
