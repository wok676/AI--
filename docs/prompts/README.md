# Prompt 与对话历史归档(评审提交物)

> 本目录是 **「Prompt 与上下文工程」** 与 **「Bug 自动化修复率」** 的核心证据。
> 证明全程由 AI 驱动、指令结构化、可复用。

## 目录结构

```
docs/prompts/
├── README.md                 # 本说明
├── templates/                # 可复用 Prompt 模板(结构化指令库)
│   ├── 00-architect-plan.md      # 架构师·Plan 模式拆解
│   ├── 01-requirement-prd.md     # 需求→PRD 生成
│   ├── 01b-ui-design.md          # UI/UX 设计规范(编码前)
│   ├── 02-feature-build.md       # 功能编码(Sub-Agent)
│   ├── 03-bug-autofix.md         # Bug 自动化修复(日志/截图/CDP)
│   └── 06-deploy.md              # 部署(Docker/Nginx/SSL)
└── sessions/                 # 实际对话历史归档(按阶段/日期)
    └── YYYY-MM-DD-阶段-主题.md
```

## 归档规则

1. **每个阶段**都在 `sessions/` 下建一个文件,命名 `YYYY-MM-DD-阶段-主题.md`。
2. 记录至少包含:**使用的 Sub-Agent 角色、原始 Prompt、AI 关键输出摘要、结果链接(commit / 文件)**。
3. Bug 修复务必记录"证据(日志/截图/CDP) → AI 诊断 → 修复"全链路。
4. 模板放 `templates/`,实际使用时复制并填充,体现"模块化复用"。

## 结构化 Prompt 五要素(所有模板遵循)

| 要素 | 说明 |
|---|---|
| **角色 Role** | 指定 Sub-Agent 身份(如 backend-engineer) |
| **目标 Goal** | 一句话说清要达成什么 |
| **约束 Constraints** | 必须遵守的规则(引用 CLAUDE.md 条款) |
| **输出 Output** | 期望的产物格式(代码/文档/方案) |
| **验收 Acceptance** | 完成判定标准(对应评分点) |
