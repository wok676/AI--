# 多 Agent 编排操作手册(契约先行 + Worktree 并行)

> 本文件是 `CLAUDE.md §11` 的落地操作细则。上个项目的最大教训:多 Agent 编排只写进文档、没真正落配置和 git 历史 = 形式分。本版**开局就跑通真实并行**。

---

## 1. 角色与触发(`.claude/agents/`)

8 个 Sub-Agent 已配置化(见 `.claude/agents/*.md`)。Claude Code 会按 `description` 自动选用,也可显式 `@角色名` 调用:

| 角色 | 何时用 |
|---|---|
| `product-manager` | 一句话创意 → 出 `docs/PRD.md`(功能清单 + 合规交互 + 给 UI 视觉提示词) |
| `architect` | PM 出 PRD 后、前后端动工前,动态选型 + 冻结契约 + 拆任务编排 |
| `ui-ux-designer` | 前端写界面前,出 `docs/UI-DESIGN.md`(令牌 + 线框 + 合规视觉) |
| `frontend-engineer` | 实现移动端界面与交互(默认 Expo/RN);含 i18n 接入 |
| `backend-engineer` | 实现接口/数据层/双向鉴权/数据销毁;含 i18n messageKey |
| `devops-release-manager` | 安全加固/TLS/CI/CD/部署/打包/技术准入 |
| `qa-debugger` | 跑测试、合规专项、安全对抗复核、Bug 自动修复 |
| `aso-operator` | 商店元数据/ASO/截图脚本/隐私 URL/上线后运营 |

> 原 `security-auditor` 职责并入 `qa-debugger`;原 `i18n-specialist` 职责并入 `frontend-engineer` / `backend-engineer`。

---

## 2. 核心纪律:契约先行(Contract-First)

前后端能并行、不打架的**唯一前提**是先冻结契约。Architect 在拆分任务前必须先产出并冻结:

1. **`docs/API.md`** —— 每个端点的 method/path、请求体、响应体、错误码。
2. **`docs/DB-Schema.md`** —— Prisma 模型(表/字段/关系/索引)。
3. **共享类型** —— `app/src/api/types.ts`(前端手写 interface)必须和后端 service 返回值**逐字段对齐**。
4. **messageKey 命名** —— 后端报错返回的 `messageKey` 必须在 `locales/{zh,en}.json` 中存在。

> **三处强耦合点**(改任一处都要前后端同步,详见 [[fullstack-workflow-playbook]] 记忆):
> ① messageKey(i18n) ② API 响应字段名/结构 ③ JWT 返回结构 `{accessToken, user:{id,username,role}}`。
> 契约一旦冻结,前端可对着 mock 写、后端对着 schema 写,各自独立推进。

---

## 3. Worktree 并行操作流程

并行改文件的任务用 git worktree 物理隔离,避免互相覆盖。

```bash
# 在仓库根目录。约定 worktree 放在 .worktrees/(已在 .gitignore)
git worktree add .worktrees/backend  -b feat/backend-<feature>
git worktree add .worktrees/frontend -b feat/frontend-<feature>

# backend-engineer 在 .worktrees/backend 干活,frontend-engineer 在 .worktrees/frontend 干活
# 各自小步 commit(带 AI-Reason / Sub-Agent 标签)

# 完成后合并回 main(契约对齐 → 通常无冲突)
git -C . merge feat/backend-<feature>
git -C . merge feat/frontend-<feature>

# 清理
git worktree remove .worktrees/backend
git worktree remove .worktrees/frontend
```

> Claude Code 内可用 EnterWorktree 工具创建并切入隔离 worktree;子任务 Agent 可用 `isolation: "worktree"` 在独立副本里改文件。

---

## 4. 一次完整功能的编排节奏

```
0. product-manager → 出/更新 docs/PRD.md + 给人类一份《需求确认清单》          [人类确认 ✋]
1. architect       → Plan 模式出方案 + 动态选型 + 冻结契约(API/DB/types/messageKey)  [人类确认 ✋]
2. ui-ux-designer  → (若涉及新界面)出/更新 docs/UI-DESIGN.md + 给人类一份《设计确认清单》  [人类确认 ✋]
3. 并行(worktree 隔离):
     backend-engineer  → 接口 + 数据层 + 双向鉴权 + i18n messageKey + 测试
     frontend-engineer → 屏幕 + API client + 三态 + i18n 接入
4. qa-debugger     → 跑 tsc/lint/test + 端到端验收 + 合规专项 + 安全对抗复核;Bug 走自动修复循环
5. 合并 worktree → 小步 commit → 归档关键对话到 docs/prompts/sessions/
   ── 以下为上架阶段 ──
6. devops-release-manager → 部署上线(TLS/CI/CD/Nginx)+ EAS 打包 + 技术准入  [发布/提交前 人类确认 ✋]
7. aso-operator    → 商店元数据/ASO 文案/截图脚本(交 UI)+ 隐私政策 URL 部署(找 devops)
```

### 4.1 人类确认门(`[人类确认 ✋]`)

标 `✋` 的阶段产出后**必须停下,把一份简短清单交架构师(人类)逐项确认,得到明确"通过"才进入下一阶段**。不得自行跳过、不得边等确认边往下做。

| 门 | 谁出 | 交付给人类的确认清单(各项一句话 + ✅/❓) |
|---|---|---|
| **需求门** | product-manager | 《需求确认清单》:核心功能闭环、Must/Should/Could 划分、合规四项(知情同意/账号注销/按需索权/iOS 特有)、待澄清的存疑点 |
| **契约门** | architect | 技术选型理由、API/DB 契约冻结点、三处强耦合点(messageKey / API 响应结构 / JWT 结构) |
| **设计门** | ui-ux-designer | 《设计确认清单》:对标 App 与气质、覆盖的 Must 页面、设计令牌关键值、合规三项视觉、待人类拍板的风格选项 |
| **发布门** | devops-release-manager | 《发布确认清单》:目标环境与地址、发布内容与版本号、回滚方案、密钥/证书与 TLS 就位、商店提交包与隐私表单、存疑点 |

> 清单是给人类**快速决策**用的摘要,不是把整份文档复述一遍。存疑/多方案处用 ❓ 标出并给推荐项,让人类一眼能拍板。

---

## 5. 提交纪律(零手写的证据)

每条 commit 必须带元信息(见 `CLAUDE.md §14`):

```
feat(auth): add JWT login endpoint

实现 POST /auth/login,返回 accessToken + user。

AI-Reason: 契约 docs/API.md 已冻结登录返回结构,后端照此实现
Sub-Agent: backend-engineer
Rule-Refs: §6.2 鉴权, §3.2 技术栈
```

小步频繁提交,体现 Agent 增量产出。关键编排/诊断对话归档到 `docs/prompts/sessions/`,作为多 Agent 编排与 Bug 修复率的评审证据。

---

## 6. 真机 / 部署经验沉淀(硬性约束,已写入对应 agent 提示词)

> 第一版真机联调踩过的坑,固化为常驻规则。详见各 `.claude/agents/*.md`,此处仅作人看的索引。

| 教训 | 约束 | 责任 agent |
|---|---|---|
| 交付了连登录都进不去的包 | **单测绿 ≠ 主流程可用**:交付任何构建前,必须真机/模拟器**连真后端**跑通主流程(注册/登录/核心闭环/注销)+ 截图取证 | qa-debugger |
| localhost 包在手机上连不到后端 | 给人类真机测试的包**禁用 localhost**,必须 `--dart-define=API_BASE_URL=http://<PC-LAN-IP>:3000/api`;配防火墙放行 + 同 WiFi(或 USB `adb reverse`) | devops(打包)/ qa(测试) |
| 起栈后只建了 auth 表、业务表缺失 | 迁移须能**从空库一键建起完整 schema**(全表/枚举/索引);起栈即 `migrate deploy` 并实测 `health` + 全表;降级库(SQLite)不当基线 | backend(迁移)/ devops(起栈) |
| 界面功能到位但空荡/有重复元素/标签错 | **真机截图逐屏走查**(空荡/重复/标签/标点);视觉增强**优先代码绘制(渐变/柔光斑/图标),禁位图素材**(规避版权、可上架) | ui-ux-designer |
