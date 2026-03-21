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

### 2️⃣ RevenueCat 配置（商业化必需）

#### 注册账号
- [ ] 访问 [revenuecat.com](https://www.revenuecat.com/) 注册开发者账号
- [ ] 创建新项目

#### iOS 配置
- [ ] 在 App Store Connect 创建 App ID
- [ ] 配置订阅组（Subscription Group）
- [ ] 创建订阅商品：
  - Product ID: `pro_monthly`
  - 价格: ¥9.9/月
- [ ] 在 RevenueCat 添加 iOS App
- [ ] 配置 App Store Connect 共享密钥

#### Android 配置
- [ ] 在 Google Play Console 创建应用
- [ ] 配置订阅商品
- [ ] 在 RevenueCat 添加 Android App
- [ ] 配置 Service Account

#### 应用配置
- [ ] 获取 RevenueCat API Key
- [ ] 替换 `lib/services/purchase_service.dart` 第 4 行：
  ```dart
  static const String _apiKey = 'YOUR_REVENUECAT_API_KEY';
  ```
- [ ] 配置 Offering ID 为 `default`
- [ ] 配置 Entitlement ID 为 `pro`

---

### 3️⃣ H5 判决页面部署 ✅ 已完成

#### 部署到 Vercel
- [x] 执行 `vercel --prod` 部署

#### 配置域名
- [x] 域名：https://judge-self.vercel.app
- [x] 已更新 `lib/screens/home_screen.dart` 分享 URL

---

### 4️⃣ App Store 上架准备

#### 开发者账号
- [ ] 注册苹果开发者账号（$99/年）
- [ ] 完成开发者认证
- [ ] 创建 App ID：`com.yourcompany.toxictracker`

#### 提审素材
- [ ] App Logo（1024x1024）
- [ ] 启动页截图（各尺寸）
- [ ] 宣传图（1024x1024）
- [ ] 预览视频（可选）
- [ ] 隐私政策页面（可用 [Termly](https://termly.com/) 生成）
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
- [ ] **耻辱海报生成器**：受罚后生成带二维码的精美海报
- [ ] **成就系统**：连续完成 N 天获得徽章
- [ ] **数据统计**：可视化展示鸽了多少次
- [ ] **更多教练人设**：
  - 暴躁的健身教练
  - 阴阳怪气的班主任
  - 佛系躺平大师

### 技术优化
- [ ] 离线模式支持
- [ ] 深色模式
- [ ] 多语言支持（英文）
- [ ] 小组件（Widget）
- [ ] Apple Watch 配套应用
- [ ] 推送通知提醒

### 商业化扩展
- [ ] 年度订阅（¥68/年，省 ¥50）
- [ ] 终身买断（¥98）
- [ ] 企业版（团队监督）
- [ ] 自定义教练声音

---

## 📊 里程碑

### MVP 上线（Week 1）
- [x] 完成 Supabase 配置
- [x] 完成 H5 部署
- [x] 代码质量检查（分析 + 测试）
- [x] Web 构建验证
- [ ] 测试完整流程（需网络）
- [ ] RevenueCat 配置
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
- [ ] 部分表情符号在 Web 端显示为方框 → 需要添加字体

---

## ✅ 已完成功能

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

---

## 🔗 相关链接

- [Supabase Dashboard](https://supabase.com/dashboard)
- [RevenueCat Dashboard](https://app.revenuecat.com/)
- [App Store Connect](https://appstoreconnect.apple.com/)
- [Google Play Console](https://play.google.com/console)
- [Vercel Dashboard](https://vercel.com/dashboard)
- [GitHub 仓库](https://github.com/vanhci/toxic_tracker)
