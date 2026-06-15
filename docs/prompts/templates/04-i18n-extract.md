# 模板 04 · 国际化抽离

> 用途:阶段 3 功能补全 · 国际化。
> 对应:i18n 优雅集成加分、零硬编码文本铁律。

---

**角色 Role**:你是 i18n-specialist。

**目标 Goal**:扫描【填写:范围/模块】,将所有面向用户的裸字符串抽离到 i18n。

**约束 Constraints**:
- 前端 UI、后端错误提示、通知文案全部覆盖。
- 后端报错返回 `messageKey`,不返回写死文案。
- key 命名规范:`模块.子项.含义`。
- 动态值用插值,禁字符串拼接。

**输出 Output**:
1. 替换后的代码(`t('...')`)。
2. 更新 `locales/zh.json` 与 `locales/en.json`,**两者 key 完全对齐**。
3. 缺失/多余 key 报告。

**验收 Acceptance**:
- [ ] ESLint `i18next/no-literal-string` 无报错。
- [ ] zh/en key 一致性校验通过。
- [ ] 切换语言 UI 全量更新。
