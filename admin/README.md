# TestAI Admin Console

管理后台(宪法 §3.2 默认栈:Vite + React + Ant Design + TypeScript strict)。
对接后端 `docs/API.md §3 Admin` 端点,仅展示**脱敏聚合**数据。

## 功能
- 管理员登录(走 `/auth/login`,前端 + 后端双重校验 `role=ADMIN`)。
- 运营看板:总用户/活跃/封禁/今日新增、识别调用量与失败率、近 7 天调用量趋势(去标识聚合)。
- 用户管理:列表(分页/搜索)、详情(脱敏聚合,无餐食明细/原图)、封禁/解封。

## 安全与合规
- 仅 ADMIN 可访问;后端端点 `@Roles(ADMIN)` 强制(403 + i18n)。
- **绝不展示**用户原图、餐食明细、健康明细、完整邮箱(邮箱已脱敏 `a***@b.com`)。
- accessToken 仅存内存;refreshToken 存 sessionStorage(不明文久存 localStorage)。
- 零硬编码密钥:配置走 `.env`(见 `.env.example`),`.env` 已 gitignore。
- 统一错误结构 `{ code, messageKey, traceId }`,按 `Accept-Language` 渲染 i18n;三态(加载/空/错误)齐备。

## 开发
```bash
npm install
cp .env.example .env   # 按需填 VITE_DEV_API_TARGET / VITE_API_BASE_URL
npm run dev            # 本地 5173,/api 代理到后端
```

## 校验
```bash
npm run typecheck   # tsc --noEmit (strict)
npm run lint        # eslint, 0 warning
npm run build       # tsc + vite build
```
