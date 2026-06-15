# 项目宪法 · AI 全栈开发工作流（CLAUDE.md）

> **本文件是项目最高效力的"宪法",所有 Coding Agent / Sub-Agent 必须无条件遵守。**
> 与任何局部约定冲突时,以本文件为准。
>
> **项目代号**:TestAI(全栈练手项目第 2 版)
> **目标**:遵循"AI 驱动全栈开发流程",**全程 0 手写代码**,产出一个**可线上部署、达到上架标准**的移动 App + 后端 + 管理后台。
> **本版重点**:开局就把**多 Agent 编排**真正落地——`.claude/agents/` 角色定义 + 契约先行 + git worktree 并行 + commit 元信息标签(上个项目的最大教训,见 §11、`docs/WORKFLOW.md`)。

---

## 第 0 章 · 元信息

| 项 | 值 |
|---|---|
| 文件性质 | 项目宪法(最高效力) |
| 效力等级 | 最高,覆盖所有 README / 注释 / 局部约定 |
| 修改方式 | 任何修改须在 commit 注明"理由 + 操作 Sub-Agent" |
| 语言 | 文档中文;代码标识符 / 注释 / commit 英文 |
| 适用对象 | 架构师(人类)+ 所有 AI Agent |
| **选题** | **TBD** —— App 具体需求待定,定题后由 Architect 产出 `docs/PRD.md` |

---

## 第 1 章 · 核心铁律(红线)

| # | 铁律 |
|---|---|
| 1 | **零手写代码**:所有代码/配置/脚本由 AI 生成,Git 记录可追溯 |
| 2 | **零崩溃**:任何异常都降级为友好提示,绝不闪退/白屏 |
| 3 | **零越权**:每个接口同时过纵向(角色)+横向(归属)鉴权 |
| 4 | **零明文密码 / 零硬编码密钥**:一律 `.env` + 哈希存储 |
| 5 | **零硬编码文本**:所有用户可见文案走 i18n |
| 6 | **必须可线上部署且公网可访问** |
| 7 | **必须打出 Release 包并达上架标准** |

---

## 第 2 章 · 六大阶段工作流

| 阶段 | 任务 | 主责 Sub-Agent | 产物 |
|---|---|---|---|
| **1a. 需求** | AI 脑暴 PRD → 合规交互设计 → 给 UI 视觉提示词 | Product Manager | `docs/PRD.md` |
| **1b. 技术选型 + 契约** | 审 PRD → 动态选型 → 冻结 API/DB 契约 | Architect | `docs/API.md`、`docs/DB-Schema.md` |
| **1c. UI/UX 设计** | 据 App 类型出设计规范 + 合规视觉 | UI/UX Designer | `docs/UI-DESIGN.md` |
| **2. 多 Agent 编排(核心)** | Plan 模式 + Sub-Agent 做架构与业务编码 | Architect 指挥 + 各 Engineer | 前后端代码 |
| **3. 功能补全** | 登录、支付、i18n 等;**Worktree 分支隔离** | Frontend / Backend | 功能模块 |
| **4. Bug 修复 + 测试** | **严禁人工排查**:日志/截图/CDP/抓包驱动 AI 自诊断;合规专项 + 安全对抗复核 | QA + 对应 Engineer | 测试报告 + 修复记录 |
| **5. 工程部署** | 安全加固 + TLS + CI/CD + Docker/Nginx/SSL 全自动 | DevOps / Release Manager | 部署脚本 + 公网链接 |
| **6. 上架** | Release 包 + 元数据 + ASO + 隐私协议 | DevOps(打包/准入)+ ASO Operator(元数据/文案) | 可上架产物 |

> 全程由架构师(人类)下指令,Sub-Agent 执行。每阶段产物入库,关键 Prompt/对话归档到 `docs/prompts/sessions/`。

---

## 第 3 章 · 技术栈选型(推荐默认配方,可由架构师按需替换)

> 以下为**已验证的推荐默认配方**,复用现成工程基线、开局即跑。但**技术选型需求驱动**:架构师(`architect`)审阅 PRD 后,可针对客户端/后端/数据库/测试框架动态替换,**替换须在 `docs/PRD.md` 之后的技术选型报告中给出充分论证**。无强理由时优先沿用本配方。

### 3.1 前端(移动端)
- **Expo + React Native(最新稳定 SDK)**,TypeScript `strict: true`,禁 `any`。
- 打包:**EAS Build / EAS Submit** —— Android AAB/APK、iOS IPA/TestFlight。
- 导航 `expo-router`;服务端状态 React Query;本地状态按需(Context / Zustand)。
- UI:`react-native-paper`(MD3);i18n:`i18next` + `react-i18next` + `expo-localization`。
- 敏感数据:`expo-secure-store`(禁止用 AsyncStorage 存 token)。

### 3.2 后端 + 管理后台
- **NestJS(TS)**:DI、管道校验、守卫,利于鉴权与统一异常处理。
- DB:**PostgreSQL + Prisma**(本地可 SQLite,部署切 Postgres)。
- 鉴权:Passport-JWT + bcrypt;校验:class-validator + ValidationPipe(whitelist)。
- **管理后台**:Vite + React + Ant Design,核心实体增删改查。
- API:RESTful + OpenAPI/Swagger 自动文档。

### 3.3 部署
- **Docker 多阶段构建** + `docker-compose`(app + db + nginx)。
- **Nginx 反向代理 + SSL(Let's Encrypt / certbot)**,全站 HTTPS。
- 部署脚本(`deploy/deploy.sh`)经 SSH 自动化发布,幂等可重跑。

### 3.4 工程化基线
- ESLint + Prettier + `tsc --noEmit`;Jest 测试。三端各自 package.json;统一可上 pnpm-workspace。

---

## 第 4 章 · 标准目录结构

```
/ (repo root)
├── CLAUDE.md                 # 本宪法
├── .env.example              # 环境变量样板(占位无真值)
├── .claude/agents/           # 8 个 Sub-Agent 角色定义(产品/架构/UI/前端/后端/运维/测试/运营)
├── docs/
│   ├── PRD.md / API.md / DB-Schema.md / UI-DESIGN.md   # 设计产物(定题后填充)
│   ├── WORKFLOW.md           # 多 Agent 编排 + 契约先行 + worktree 操作手册
│   └── prompts/{README.md, templates/, sessions/}      # Prompt 库 + 对话归档
├── locales/{zh.json, en.json}# 国际化语言包(前后端共享 key)
├── app/                      # Expo / RN 前端
├── server/                   # NestJS 后端
├── admin/                    # 管理后台
├── deploy/                   # 部署脚本、nginx、docker-compose
└── metadata/                 # 上架元数据(icons/splash/privacy/store)
```

---

## 第 5 章 · 架构防漏设计(防崩溃)

- **全局 Error Boundary**:前端根组件外层必须包裹,捕获渲染异常 → 可恢复兜底 UI(含"重试")。路由级二级 Error Boundary。
- **强制 try-catch**:所有 `async/await`、网络、存储、原生调用必须 try-catch。统一 API client 集中处理超时/重试/断网/HTTP 错误 → 转 i18n 文案。
- **后端全局异常过滤器**:统一返回 `{ code, messageKey, traceId }`,**绝不泄露堆栈**。
- **三态 UI + 输入校验**:所有列表/详情有 加载/空/错误 三态;前后端双重校验。

---

## 第 6 章 · 安全与鉴权(防越权 / 明文密码)

- **密钥与密码**:敏感配置走 `.env`,仓库只提交 `.env.example`;密码 bcrypt/argon2 哈希,严禁明文;`.env`/证书/keystore 必须 `.gitignore`;提交前 gitleaks 扫描。
- **纵向鉴权**:RBAC 守卫,校验"当前角色是否有权调用此接口"。
- **横向鉴权**:数据层强制校验归属(`where { id, ownerId: currentUser.id }`),杜绝改 ID 越权。
- **基线**:HTTPS only、Helmet、CORS 白名单、接口限流、依赖审计、日志脱敏(不打印 PII/token)。失败统一 401/403 + i18n,不暴露资源是否存在。

---

## 第 7 章 · 国际化

- **零硬编码文本**:UI/报错/通知全部 `t('ns.key')`。语言包集中 `/locales`,前后端共享 key。
- **后端报错也国际化**:返回 `messageKey`,按 `Accept-Language` 渲染。默认中文,回退英文。
- 动态值用插值,禁拼接;日期/数字/货币用 `Intl` 按 locale 格式化。CI 校验 key 一致性。

---

## 第 8–10 章 · 交付物 / 上架 / 部署清单

- **元数据**(`/metadata`):App 图标、启动页、**隐私协议**(中英双语,公网 URL)、商店素材。
- **上架双平台**:Google Play(AAB、Play App Signing、Data Safety、内容分级)/ Apple(IPA、App Privacy 标签、TestFlight 内测)。
- **线上部署**:Dockerfile 多阶段 + compose 一键起栈;Nginx 反代 + SSL;`deploy.sh` SSH 幂等部署;**公网可访问** + 健康检查端点 + 部署文档。

---

## 第 11 章 · AI 协作工作流与 Sub-Agent(本版重点)

> **操作细则见 [`docs/WORKFLOW.md`](docs/WORKFLOW.md)。** 角色定义见 [`.claude/agents/`](.claude/agents/)。

### 11.1 编排原则
- **架构师(人类)只下指令、做决策、审阅**,所有代码由 Agent 产出。
- 复杂任务先进 **Plan 模式** 出方案 → 拆分子任务 → **Sub-Agent 并行(fan-out)** → 汇总。
- **契约先行**:前后端并行前,先冻结 API 契约(`docs/API.md` + `locales` key + 共享类型),各 agent 照契约各写各的。
- 并行改文件用 **Worktree 隔离**,避免冲突。
- 安全/越权类发现,必须由独立 Agent **对抗式复核**后才采信。

### 11.2 Sub-Agent 角色矩阵(对应 `.claude/agents/*.md`)

> 共 **8 个角色**。原 `security-auditor`(安全对抗复核)职责并入 **qa-debugger**;原 `i18n-specialist`(文案抽离/语言包对齐)职责并入 **frontend-engineer / backend-engineer**。

| 角色 | 职责 |
|---|---|
| **product-manager** | 需求脑暴 → PRD;双端上架合规交互设计(知情同意/账号注销/按需索权/iOS ATT+Apple 登录);给 UI 的视觉提示词 |
| **architect** | 审 PRD → 动态技术选型 → 系统架构与安全/鉴权规范 → 冻结 API/DB 契约 → 任务拆解与指挥编排 |
| **ui-ux-designer** | 据 App 类型定设计规范(令牌/组件/线框/三态)+ 合规视觉(拒绝暗黑模式/44pt 点按/前置授权弹窗) |
| **frontend-engineer** | 移动端实现(默认 Expo/RN)、UI 三态、i18n 接入、客户端合规硬落地,严格遵循 `docs/UI-DESIGN.md` 与契约 |
| **backend-engineer** | API、数据层、纵向+横向鉴权守卫、隐私强加密、彻底/不可逆账号数据销毁、i18n messageKey、管理后台后端 |
| **devops-release-manager** | 安全加固 + 全链路 TLS、CI/CD、Docker/Nginx/SSL、备份监控、SSH 幂等部署、EAS 打包与技术准入 |
| **qa-debugger** | 测试用例、双端合规专项测试、安全对抗复核、CDP/抓包调试、对照宪法验收、Bug 自动修复 |
| **aso-operator** | 双端商店元数据/ASO/本地化文案、截图脚本(交 UI)、商店侧合规审查、上线后评论与数据运营 |

### 11.3 Bug 自动化修复工作流
> **严禁人工改 Bug**。循环:① 采集证据(日志/截图/CDP)→ ② 喂 Agent 自诊断定位根因 → ③ Agent 出修复 + 验证 → ④ 诊断对话存 `docs/prompts/sessions/`。

---

## 第 12 章 · Prompt 与上下文工程

- **结构化 Prompt 五要素**:角色 + 目标 + 约束 + 输出格式 + 验收标准(模板见 `docs/prompts/templates/`)。
- **大任务拆解**:先 Plan,再分子任务,每个单一职责。常用指令沉淀为模板复用。
- **全程归档**:关键对话存 `docs/prompts/sessions/`。引导 Agent 始终读取本 `CLAUDE.md` 作为上下文锚点。

---

## 第 13 章 · 质量门禁(Definition of Done)

任务"完成"前必须全绿:
- [ ] `tsc --noEmit` + ESLint + Prettier 通过
- [ ] 单元/集成测试通过,关键路径有覆盖
- [ ] 无裸字符串、无硬编码密钥/明文密码(自动扫描通过)
- [ ] 纵向 + 横向鉴权用例通过
- [ ] 对照第 5–10 章清单逐条核对

---

## 第 14 章 · Git 提交规范(零手写的核心证据)

### 14.1 Commit 格式(Conventional Commits + AI 元信息)
```
<type>(<scope>): <简短描述>

<正文:本次变更内容>

AI-Reason: <AI 驱动的决策理由>
Sub-Agent: <负责的角色,如 backend-engineer>
Rule-Refs: <对应宪法条款,如 §6.2 横向鉴权>
```
- `type`:feat/fix/refactor/docs/test/chore/build/ci。
- **每条 commit 必须含 `AI-Reason` 与 `Sub-Agent`**,缺失视为不合规。
- 提交粒度小而频繁,体现 Agent 增量产出;严禁一次性贴入大段代码;严禁提交密钥/`.env`/证书。

### 14.2 分支
- 主分支保护,PR 合并;功能开发用 **Worktree / 分支隔离**,PR 描述引用任务与宪法条款。
