# 🧨 《今天鸽了吗》待实现功能清单

## 📋 配置清单（必须完成才能上线）

### 1️⃣ Supabase 配置 ✅ 已完成

#### 创建项目
- [x] 访问 [supabase.com](https://supabase.com) 创建账号
- [x] 创建新项目，选择离用户最近的区域
- [x] 在项目设置中获取 **Project URL** 和 **Anon Key**

#### 配置应用
- [x] 替换 `lib/main.dart` 中的占位符
- [x] 替换 `judge/index.html` 中的占位符

#### 数据库配置
- [x] 创建 verdicts 表
- [x] 启用 RLS (Row Level Security)
- [x] 允许匿名操作

#### Storage 配置
- [x] 创建 proofs Storage bucket
- [x] 配置访问策略（Allow anonymous upload/read）

#### 启用匿名认证
- [x] Supabase Dashboard → Authentication → Providers → 启用 Anonymous

**测试状态**: ✅ 图片上传成功，数据库记录正常

---

### 2️⃣ RevenueCat 配置（商业化必需） ✅ 已完成

#### 注册账号
- [x] 访问 [revenuecat.com](https://www.revenuecat.com/) 注册开发者账号
- [x] 创建新项目

#### iOS 配置
- [x] 在 App Store Connect 创建 App ID
- [x] 配置订阅组（Subscription Group）
- [x] 创建订阅商品：
  - Product ID: `toxic_yearly_19.9` (¥19.9/年)
  - Product ID: `toxic_lifetime_68` (¥68 终身)
- [x] 在 RevenueCat 添加 iOS App
- [x] 配置 App Store Connect 共享密钥

#### Android 配置
- [ ] 在 Google Play Console 创建应用
- [ ] 配置订阅商品
- [ ] 在 RevenueCat 添加 Android App
- [ ] 配置 Service Account

#### 应用配置
- [x] 获取 RevenueCat API Key
- [x] 配置 `lib/services/purchase_service.dart`：
  - API Key: `app5904c87b38`
  - Package identifiers: `toxic_yearly_19.9`, `toxic_lifetime_68`
  - Entitlement ID: `toxic_tracker Pro`
- [x] 配置 Offering ID 为 `default`
- [x] 配置 Entitlement ID 为 `toxic_tracker Pro`

---

### 3️⃣ H5 判决页面部署 ✅ 已完成

#### 部署到 Vercel
- [x] 执行 `vercel --prod` 部署

#### 配置域名
- [x] 域名：https://judge-self.vercel.app
- [x] 已更新 `lib/screens/home_screen.dart` 分享 URL

---

### 4️⃣ App Store 上架准备 🔄 进行中

#### 开发者账号
- [ ] 注册苹果开发者账号（$99/年）
- [ ] 完成开发者认证
- [x] 创建 App ID：`com.vanhci.toxictracker` ✅

#### Package ID 配置 ✅ 已完成
- [x] Android applicationId: `com.vanhci.toxictracker`
- [x] Android namespace: `com.vanhci.toxictracker`
- [x] iOS PRODUCT_BUNDLE_IDENTIFIER: `com.vanhci.toxictracker`
- [x] Kotlin 文件包结构更新

#### 隐私政策 ✅ 已完成
- [x] 创建 `privacy_policy.md`
- [x] 包含数据收集说明
- [x] 包含 Supabase 存储使用说明
- [x] 包含 RevenueCat 支付处理说明
- [x] 包含用户权利说明
- [ ] 托管到 GitHub Pages（待执行）

#### Android 签名 📝 待配置
- [x] 创建签名配置指南 `android/SIGNING_SETUP.md`
- [ ] 创建签名证书 (.jks)
- [ ] 配置 key.properties
- [ ] 更新 build.gradle.kts 签名配置
- [ ] 验证签名

#### 提审素材
- [ ] App Logo（1024x1024）
- [ ] 启动页截图（各尺寸）
- [ ] 宣传图（1024x1024）
- [ ] 预览视频（可选）
- [ ] 用户协议页面

#### ASO 优化
- [ ] App 名称：《今天鸽了吗》
- [ ] 副标题：一款专门骂你的自律 App
- [ ] 关键词：自律,打卡,习惯,监督,Flag
- [ ] 描述：
  ```
  连续鸽了3次，你的死党将有权远程处刑。

  这是一款极简主义风格的自律应用，没有温柔的鼓励，只有无情的嘲讽。
  每次你放弃任务，都要拍照留证，分享给死党让他来判决：
  是放你一马，还是立刻触发30秒的"赛博处刑"。

  - 💀 粗野主义界面：硬核黑边框，刺眼的荧光黄，零模糊
  - 📸 强制拍照：没有照片就不算鸽了
  - 🤝 社交处刑：让死党来当你的行刑官
  - 💬 毒舌教练：Amanda 免费陪你立 Flag，解锁更多教练需 9.9元/月
  ```

---

## 🚀 后续优化功能（可选）

### 功能增强
- [x] **耻辱海报生成器**：受罚后生成带二维码的精美海报
- [x] **成就系统**：连续完成 N 天获得徽章
- [x] **数据统计**：可视化展示鸽了多少次
- [x] **更多教练人设**：
  - 暴躁的健身教练 ✅
  - 阴阳怪气的班主任 ✅
  - 佛系躺平大师 ✅

### 技术优化
- [x] 离线模式支持
- [x] 深色模式
- [x] 多语言支持（英文）
- [x] 小组件（Widget）
- [x] Apple Watch 配套应用（Swift 代码已创建，需在 Xcode 中添加 Target）
- [x] 推送通知提醒

### 商业化扩展
- [x] 年度订阅（¥68/年，省 ¥50）
- [x] 终身买断（¥98）
- [x] 企业版（团队监督）— 基础功能已实现，完整功能需后端支持
- [x] 自定义教练声音（TTS 语音 + 可配置音调/语速）

---

## 📊 里程碑

### MVP 上线（Week 1）
- [x] 完成 Supabase 配置
- [x] 完成 H5 部署
- [x] 代码质量检查（分析 + 测试）
- [x] Web 构建验证
- [x] 添加 Supabase 迁移脚本（supabase/migrations.sql）
- [x] Package ID 更新为 `com.vanhci.toxictracker`
- [x] 隐私政策文档创建
- [x] Android 签名配置指南
- [ ] 测试完整流程（需网络）
- [ ] 创建 Android 签名证书
- [ ] 托管隐私政策到 GitHub Pages
- [ ] RevenueCat 后台创建产品
- [ ] 提交 App Store 审核

### 用户增长（Week 2-4）
- [ ] 小红书内容营销
- [ ] 抖音短视频推广
- [ ] 社群裂变活动
- [ ] 收集用户反馈

### 商业化验证（Month 2）
- [ ] 优化付费转化率
- [ ] A/B 测试定价策略
- [ ] 开发企业版功能

---

## 🐛 已知问题

- [x] ~~Web 端无法使用相机，会调用文件选择器~~ → 浏览器限制，正常行为
- [x] ~~Web 端图片上传失败~~ → 已修复（使用 uploadBinary）
- [ ] RevenueCat 在 Web 端不支持 → 正常行为，仅在移动端可用
- [x] ~~部分表情符号在 Web 端显示为方框~~ → 已添加 Noto Color Emoji 字体

---

## ✅ 已完成功能

### 上架准备 (2026-03-26)
- [x] Package ID 更新为 `com.vanhci.toxictracker`
- [x] 隐私政策文档 (`privacy_policy.md`)
- [x] Android 签名配置指南 (`android/SIGNING_SETUP.md`)
- [x] RevenueCat iOS 配置验证通过

### 核心功能
- [x] 任务管理（增删改查）
- [x] 拍照上传（Web/移动端）
- [x] Supabase Storage 集成
- [x] 判决记录数据库
- [x] 分享功能（share_plus）
- [x] 教练选择系统
- [x] 付费墙 UI
- [x] 惩罚页面（30秒锁屏）
- [x] 启动页视觉设计

### 技术实现
- [x] Flutter 跨平台架构
- [x] Supabase 后端服务
- [x] 匿名认证
- [x] Web 端兼容性修复
- [x] 实时判决监听（轮询方式）
- [x] H5 判决页部署（Vercel）
- [x] 代码质量检查（0 问题）
- [x] 单元测试（54/54 通过）
- [x] CI/CD 自动化（GitHub Actions）
- [x] 开发脚本和用户指南
- [x] 上架配置文档
- [x] 用户身份管理服务
- [x] 团队统计关联

---

## 🔗 相关链接

- [Supabase Dashboard](https://supabase.com/dashboard)
- [RevenueCat Dashboard](https://app.revenuecat.com/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Google Play Console](https://play.google.com/console)
- [Vercel Dashboard](https://vercel.com/dashboard)
- [GitHub 仓库](https://github.com/vanhci/toxic_tracker)
