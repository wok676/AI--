# 集成测试 / QA 自动化基座

本目录是 QA 端到端自动化的落地基座。约定见 `docs/WORKFLOW.md §2`(可测性契约)与 `CLAUDE.md §13`。

## 核心约定:test keys 由前端开发时交付

关键交互/状态控件的定位标识集中定义在 [`lib/common/test_keys.dart`](../lib/common/test_keys.dart) 的 `TestKeys` 常量类,**由 frontend 实现界面时同步挂 `ValueKey` 交付**。自动化脚本只消费这些常量,不猜坐标:

```dart
import 'package:calorie_app/common/test_keys.dart';

Finder byKey(String k) => find.byKey(ValueKey<String>(k));
await tester.tap(byKey(TestKeys.loginSubmitBtn));
```

新增/改动控件 → 先在 `TestKeys` 加常量并挂到控件 → 再在脚本里引用。**严禁散落字面量 key**。

## 运行方式

前置:① 本地后端在线(`docker compose -f deploy/docker-compose.dev.yml up -d`,健康端点 `/api/v1/health`);② 真机已连且**解锁**(锁屏会让集成测试挂起);③ USB 真机建 `adb reverse tcp:3000 tcp:3000` 使手机可直连宿主后端。

```bash
# 框架健全性快检(纯 widget,不连后端)
flutter test integration_test/trivial_test.dart -d <device>

# 认证主流程端到端(连本地真后端)
flutter test integration_test/auth_smoke_test.dart -d <device> \
  --dart-define=API_BASE_URL=http://localhost:3000/api
```

## 脚本清单

| 文件 | 覆盖 | 连后端 |
|---|---|---|
| `trivial_test.dart` | integration_test 框架在设备上能跑(健全性) | 否 |
| `auth_smoke_test.dart` | 注册(含知情同意)→ 进主页 → 退出 → 登录 → 注销自清理 | 是 |

## TestKeys 覆盖域(见源文件分区)

认证(`auth_*`)· 底部导航+今日(`shell_*`/`today_*`)· 录入流程(`capture_*`/`recognition_*`)· 目标(`goal_*`)· 历史(`history_*`)· 资料+注销(`profile_*`/`logout_*`/`delete_*`)· 语言选择(`language_option_*`,含按语言码的工厂)· 三态/反馈(`state_*`)。

## 注意

- **设备锁屏**:集成测试需 app 视图到前台;真机图案锁会让测试挂起。测试期间解锁并保持常亮(`adb shell svc power stayon true`)。
- **测试账号**:`auth_smoke` 用 `qa_it_<时间戳>@test.local`,末尾走 app 内注销做自清理,不留脏数据。口令仅本地测试用,绝不进生产路径,不含真实 PII。
