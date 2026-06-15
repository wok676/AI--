# TestAI · AI 驱动全栈练手项目(第 2 版)

> 全程 **0 手写代码**,由 AI Sub-Agent 编排产出:移动 App + 后端 + 管理后台。
> 本版相对上个项目的升级:**开局就把多 Agent 编排真正落地**(`.claude/agents/` + 契约先行 + worktree 并行 + commit 元信息)。

## 选题

**TBD** —— App 具体需求待定。定题后由 `architect` 产出 `docs/PRD.md`,再进入六阶段工作流。

## 技术栈

- **App**:Expo + React Native + TypeScript(react-native-paper、i18next、expo-secure-store)
- **后端**:NestJS + Prisma + PostgreSQL(JWT + bcrypt + class-validator)
- **管理后台**:Vite + React + Ant Design
- **部署**:Docker + Nginx + SSL(Let's Encrypt)

## 关键文档

| 文件 | 作用 |
|---|---|
| [CLAUDE.md](CLAUDE.md) | 项目宪法(最高效力,所有 Agent 必读) |
| [docs/WORKFLOW.md](docs/WORKFLOW.md) | 多 Agent 编排操作手册(契约先行 + worktree) |
| [.claude/agents/](.claude/agents/) | 8 个 Sub-Agent 角色定义 |
| [docs/prompts/](docs/prompts/) | 结构化 Prompt 模板 + 对话归档 |
| docs/PRD.md · API.md · DB-Schema.md · UI-DESIGN.md | 设计产物(定题后填充) |

## 当前状态

- [x] 仓库骨架 + 宪法 + 编排基础设施(agents / 模板 / 工作流文档)
- [ ] 选题 → PRD → 契约冻结(`architect`)
- [ ] UI 设计规范(`ui-ux-designer`)
- [ ] 三端实现(worktree 并行)
- [ ] 安全审计 / i18n / 测试
- [ ] 部署 + 上架

## 开干方式

定好选题后,对 Claude 说:「用 architect 角色,基于选题 XXX 出 PRD 并冻结契约」,随后按 `docs/WORKFLOW.md` 第 4 节的编排节奏推进。
