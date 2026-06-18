# 2026-06-18 · 阶段4 · Bug 自动化修复闭环 + CI 揪出生产级缺陷

> 评审证据:全程**证据驱动、AI 自诊断**修复,无人工凭经验猜改;CI 接入后又自动照出
> 3 个"本地能跑、一上线就崩"的缺陷。对应评分项「Bug 自动化修复率」「工程部署」。

## 元信息
- **阶段**:阶段4(Bug 修复 + 测试)→ 延伸到阶段5(CI/CD)
- **Sub-Agent**:frontend-engineer / backend-engineer / qa-debugger / devops-release-manager(架构师指挥)
- **关联 commit**:`13bf1cb` `eb6d4e8` `33e2a0d` `22494d2` `7f5d78b` `9efcd19` `78050ed` `85dad22` `19171e1` `d77d2fc` `b0cbdde`

## 一、用户报障 → 证据驱动修复(7 个 bug + 2 处死交互)

| Bug | 证据 | AI 根因 | 修复 commit |
|---|---|---|---|
| 图片识别→黑屏 | 真机崩溃 + 代码读取 | 识别 loading 弹窗在 shell 嵌套 Navigator 上 pop,触发 `!_debugLocked` 断言 | `13bf1cb`(改 rootNavigator) |
| 权限弹窗每次都弹 | 用户反馈 + 权限流代码 | 没查已授权态,每次都弹前置解释 | `eb6d4e8`(查 status,已授权早退) |
| 弹窗按钮粘连 ×2 | 用户反馈 | OverflowBar 无显式间距 | `eb6d4e8`/`33e2a0d`(加 SizedBox) |
| 个人资料/关于 点击无反应 | 用户反馈 | `onTap: () {}` 死交互、无目标页 | `33e2a0d`/`7f5d78b`(删除) |
| 目标页顶部黑屏 | 用户反馈 + 路由排查 | push 路由透明 Scaffold+AppBar,背后无 shell 垫底露黑底 | `22494d2`(填渐变顶色) |
| **文字识别报"未上传图片"** | 用户反馈 + 端到端复现 | 误调 `/recognition`(图片端点),应为 `/recognition/text` | `9efcd19` |
| **识别间歇"失败"** | 实测延迟 4~15s+ 抖动 | 20s 统一 receiveTimeout 误杀有效 AI 请求 | `9efcd19`(识别单独放宽 60s) |

> 修复手法严格走「采集证据 → 喂 AI 自诊断 → 出修复 + 跑测试/复现确认 → 归档」,
> 并补了**识别闭环集成测试** `recognition_smoke_test.dart`(`78050ed`),真机 `All tests passed!`。

## 二、CI 接入(`85dad22`)后自动照出 3 个生产级缺陷

CI 第一次让 server 测试**连真 Postgres + 空库 `migrate deploy`**,照出本地发现不了的问题:

1. **迁移被 `.gitignore` 整目录忽略** → CI `migrate deploy` "No migration found"、零表 → 修:迁移入库(`19171e1`)。
2. **提交的是 SQLite 方言迁移**(lock=sqlite)→ Postgres 报 **P3019** → 修:对真 PG 重生成 Postgres 迁移(`d77d2fc`)。
3. **集成测试并行争用同一个库** → 间歇假失败 → 修:jest `maxWorkers:1` 串行(`d77d2fc`)。

最终 **CI 全绿**;教训沉淀进 `docs/WORKFLOW.md §6.1` 与各 agent 提示词(`b0cbdde`)。

## 结果与验收
- [x] tsc/lint/test 全绿(CI `d77d2fc` success);识别闭环 e2e 真机通过
- [x] 每个修复有证据→根因→验证链路,无人工猜改
- [x] 修复教训固化为常驻规则,防复发
- 产物:GitHub Actions CI 全绿、`recognition_smoke_test.dart`、WORKFLOW §6.1
