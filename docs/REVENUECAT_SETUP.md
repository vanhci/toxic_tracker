# RevenueCat 配置指南

## 1. 注册 RevenueCat 账号

1. 访问 https://www.revenuecat.com/
2. 点击 "Get Started" 注册账号（可用 GitHub/Google 登录）
3. 创建新项目，命名为 "Toxic Tracker"

## 2. iOS 配置

### 2.1 App Store Connect 配置

1. 登录 https://appstoreconnect.apple.com/
2. 选择你的 App（或创建新 App）
3. 进入 "功能" → "订阅"
4. 创建订阅组：`toxic_tracker_premium`
5. 创建订阅商品：
   - 产品 ID：`pro_monthly`
   - 参考名称：毒舌教练月度订阅
   - 订阅时长：1个月
   - 价格：¥9.9

### 2.2 获取 App Store Connect 共享密钥

1. App Store Connect → App 信息
2. 找到 "App 专用共享密钥"
3. 复制密钥（用于 RevenueCat 验证收据）

### 2.3 RevenueCat iOS 配置

1. RevenueCat Dashboard → 你的项目
2. 点击 "+ Add App" → iOS
3. 输入 Bundle ID：`com.example.toxic_tracker`
4. 粘贴 App Store Connect 共享密钥
5. 保存

## 3. Android 配置（可选）

### 3.1 Google Play Console 配置

1. 登录 https://play.google.com/console/
2. 选择应用 → 变现 → 产品
3. 创建订阅：
   - 产品 ID：`pro_monthly`
   - 名称：毒舌教练月度订阅
   - 价格：¥9.9/月

### 3.2 获取 Service Account

1. Google Play Console → 设置 → API 访问权限
2. 关联 Google Cloud 项目
3. 创建 Service Account
4. 下载 JSON 密钥文件

### 3.3 RevenueCat Android 配置

1. RevenueCat Dashboard → "+ Add App" → Android
2. 输入 Package Name：`com.example.toxic_tracker`
3. 上传 Service Account JSON 文件
4. 保存

## 4. 配置 Entitlements 和 Offerings

### 4.1 创建 Entitlement

1. RevenueCat Dashboard → Entitlements
2. 创建 Entitlement：`pro`
3. 关联订阅商品 `pro_monthly`

### 4.2 创建 Offering

1. RevenueCat Dashboard → Offerings
2. 创建 Offering：`default`
3. 添加 Package：
   - Identifier: `monthly`
   - Package Type: `$rc_monthly`
   - Product: `pro_monthly`

## 5. 获取 API Key

1. RevenueCat Dashboard → ⚙️ 设置 → API Keys
2. 复制 **Apple App Store API Key**（iOS）
3. 复制 **Google Play Store API Key**（Android）

## 6. 更新代码

编辑 `lib/services/purchase_service.dart`：

```dart
static const String _apiKey = 'YOUR_REVENUECAT_API_KEY';
```

替换为你的 API Key。

## 7. 测试购买

### iOS 沙盒测试

1. App Store Connect → 用户和职能 → 沙盒技术测试员
2. 创建测试账号
3. 在设备上登录沙盒账号测试购买

### Android 测试

1. Google Play Console → 设置 → 许可测试
2. 添加测试邮箱
3. 使用测试账号进行购买测试

## 常见问题

**Q: Web 端能使用 RevenueCat 吗？**
A: 不能，RevenueCat 仅支持 iOS/Android。Web 端会显示 "MissingPluginException"，这是正常行为。

**Q: 如何测试购买流程？**
A: 使用沙盒环境测试，不会产生真实扣款。

**Q: 订阅如何续费？**
A: 沙盒环境续费周期缩短（1个月=5分钟），方便测试。
