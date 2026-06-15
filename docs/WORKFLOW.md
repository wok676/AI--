# 多 Agent 编排操作手册(契约先行 + Worktree 并行)

> 本文件是 `CLAUDE.md §11` 的落地操作细则。上个项目的最大教训:多 Agent 编排只写进文档、没真正落配置和 git 历史 = 形式分。本版**开局就跑通真实并行**。

---

## 1. 角色与触发(`.claude/agents/`)

8 个 Sub-Agent 已配置化(见 `.claude/agents/*.md`)。Claude Code 会按 `description` 自动选用,也可显式 `@角色名` 调用:

| 角色 | 何时用 |
|---|---|
| `architect` | 新功能/新模块动工前,出 Plan + 冻结契约 |
| `ui-ux-designer` | 前端写界面前,出 `docs/UI-DESIGN.md` |
| `frontend-engineer` | 实现 Expo/RN 界面与交互 |
| `backend-engineer` | 实现 NestJS 接口/Prisma/鉴权 |
| `security-auditor` | 对抗式复核越权/密钥(独立于实现者) |
| `i18n-specialist` | 抽离裸串、对齐语言包 |
| `devops-release-manager` | 部署/打包/上架 |
| `qa-debugger` | 跑测试、Bug 自动修复 |

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
1. architect      → Plan 模式出方案 + 冻结契约(API/DB/types/messageKey)   [人类确认]
2. ui-ux-designer → (若涉及新界面)出/更新 docs/UI-DESIGN.md
3. 并行(worktree 隔离):
     backend-engineer  → 接口 + Prisma + 鉴权 + 测试
     frontend-engineer → 屏幕 + API client + 三态 + i18n
4. i18n-specialist   → 扫裸串、对齐 zh/en
5. security-auditor  → 对抗式复核(独立于实现者,发现必须复核后采信)
6. qa-debugger       → 跑 tsc/lint/test + 端到端验收,Bug 走自动修复循环
7. 合并 worktree → 小步 commit → 归档关键对话到 docs/prompts/sessions/
```

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
