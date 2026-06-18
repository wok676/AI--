# 2026-06-18 · 阶段5–6 · 多 Agent 编排:公网部署 + 上架物料准备

> 评审证据:架构师(人类)下指令,**调度多个专职 Sub-Agent 并行产出**,完成公网部署
> 与上架物料。对应评分项「多 Agent 编排架构」「工程部署与可用性」「达到上架标准」。

## 元信息
- **阶段**:阶段5(部署)+ 阶段6(上架准备)
- **Sub-Agent**:architect(指挥)→ devops-release-manager(部署/打包)+ aso-operator(商店物料)+ ui-ux-designer(图标/启动页)
- **关联 commit**:`a11b0c9`(图标+物料+隐私 URL)、`deploy/README-render.md`、`gh-pages` 分支

## 一、公网部署(devops-release-manager,Render 免费档)

- 经 Render API 建 Postgres + Web Service(server/Dockerfile + Docker runtime),配齐 7 个环境变量。
- 容器 entrypoint `migrate deploy`(用已入库的 `prisma/migrations-postgres`)自动建全 9 表。
- **公网地址**:https://testai-server-51gd.onrender.com (HTTPS,Singapore)。
- 验证(连线上后端真实闭环):`/api/v1/health` 200 → 注册拿 token → 文字识别返回真实 AI 结果
  (香蕉 105 + 牛奶 150 kcal)→ 注销 200。**铁律6 公网可访问达成。**

## 二、上架物料(并行编排)

**调度 1 · aso-operator**(Prompt 要点:读 PRD/法律文案,产双端商店文案 + Data Safety + 隐私页):
- `metadata/store/google-play.md` / `app-store.md`(中英,禁忌词已排查通过)
- `metadata/store/data-safety.md`(据真实数据流:读 `recognition.service.ts`/`schema.prisma` 核实图片瞬时处理不落库)
- `metadata/privacy/{privacy,terms}.html`(自包含静态页)

**调度 2 · ui-ux-designer**(Prompt 要点:沿用 AppColors,代码生成图标,禁位图):
- `tools/gen_app_icon.py`(纯 PIL:墨绿圆角底 + 叶片环抱热量火苗,零位图)
- 图标(1024² + 自适应前景)+ 启动页;`pubspec.yaml` 配好 flutter_launcher_icons / native_splash

**架构师收口(devops/Bash)**:跑生成脚本 + launcher/splash 注入 + 打 **Release APK**
(`flutter build apk --release --dart-define=API_BASE_URL=<Render 公网>`,55MB)+ GitHub Pages
上线隐私/协议页(`gh-pages` 分支):
- 隐私政策:https://wok676.github.io/AI--/privacy.html
- 用户协议:https://wok676.github.io/AI--/terms.html

## 结果与验收
- [x] 后端公网 HTTPS 可访问,真实闭环验证通过
- [x] Release APK 打出(连公网后端)
- [x] 双端商店文案 + Data Safety + 图标 + 启动页 + 隐私协议公网 URL 齐备
- [x] 全程多 Agent 编排(architect → aso-operator / ui-ux-designer / devops 并行),提交带 §14 元信息
- 产物:Render 服务、`metadata/`、`gh-pages` 公网页、`app-release.apk`
