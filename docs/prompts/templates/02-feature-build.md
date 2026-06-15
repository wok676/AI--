# 模板 02 · 功能编码(Sub-Agent)

> 用途:阶段 2/3 业务编码与功能补全。
> 对应:功能完整性、i18n 加分。

---

**角色 Role**:你是 【frontend-engineer / backend-engineer】。先读 `CLAUDE.md`、契约(`docs/API.md`)与本功能的 PRD 段落。

**目标 Goal**:实现【填写:功能名,如 用户登录 / 列表 CRUD】。

**约束 Constraints**:
- 零手写痕迹:完整由你生成,小步提交。
- 防崩溃:所有异步/IO 包 try-catch,UI 三态齐全,挂 ErrorBoundary。
- 鉴权:接口过纵向(RBAC)+横向(归属)校验。
- 零硬编码文本:所有文案走 i18n key,同步更新 `locales/zh.json`、`en.json`。
- 零硬编码密钥:配置走 `.env`。

**输出 Output**:
1. 功能代码(前端组件/后端模块)。
2. 对应单元/集成测试。
3. 新增 i18n key。
4. 符合 §14 的 commit(含 AI-Reason / Sub-Agent / Rule-Refs)。

**验收 Acceptance**:
- [ ] `tsc --noEmit` + lint + test 通过。
- [ ] 无裸字符串、无硬编码密钥。
- [ ] 鉴权用例通过。
