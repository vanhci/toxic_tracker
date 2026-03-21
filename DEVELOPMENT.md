# 开发指南

## 环境配置

### Flutter 安装

```bash
# macOS 通过 Homebrew 安装
brew install --cask flutter

# 验证安装
flutter doctor
```

### IDE 配置

推荐使用 VS Code + Flutter 插件，或 Android Studio。

## 依赖说明

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 本地存储
  shared_preferences: ^2.2.2

  # 图片选择
  image_picker: ^1.0.7

  # 分享功能
  share_plus: ^7.2.2

  # Supabase 后端
  supabase_flutter: ^2.6.0

  # 内购服务
  purchases_flutter: ^8.1.0
```

## 常用命令

```bash
# 安装依赖
flutter pub get

# 运行开发服务器
flutter run -d chrome    # Web
flutter run -d ios       # iOS 模拟器
flutter run -d android   # Android 模拟器

# 构建生产版本
flutter build web
flutter build ios --release
flutter build apk --release

# 运行测试
flutter test

# 代码格式化
dart format .

# 代码分析
flutter analyze
```

## 架构设计

### 状态管理

本项目不使用第三方状态管理库，每个 `StatefulWidget` 通过 `setState` 在本地管理状态。

**设计理由**：
- 应用规模小，无需复杂状态管理
- 保持代码简洁，降低学习成本
- 各屏幕独立，无跨页面状态共享需求

### 数据流

```
┌─────────────────┐
│   HomeScreen    │
│  (Stateful)     │
└────────┬────────┘
         │ 读取/写入
         ▼
┌─────────────────┐
│  TaskStorage    │ ← SharedPreferences 封装
└────────┬────────┘
         │ 序列化 JSON
         ▼
┌─────────────────┐
│   本地存储       │
└─────────────────┘
```

### Task 模型

```dart
class Task {
  final String id;
  final String title;
  final DateTime? deadline;
  final int consecutiveFails;  // 连续鸽了次数
  final DateTime? lastFailDate;
  final bool isPunished;       // 是否已被处刑
  final String? coachId;       // 选择的教练
}
```

**惩罚触发条件**：`consecutiveFails >= 3`

## 后端服务

### Supabase 配置

1. 创建项目：https://supabase.com
2. 获取 Project URL 和 Anon Key
3. 配置 `lib/main.dart`：

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 数据库 Schema

```sql
-- verdicts 表
CREATE TABLE verdicts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  task_id TEXT NOT NULL,
  task_title TEXT NOT NULL,
  photo_url TEXT NOT NULL,
  status TEXT DEFAULT 'pending',  -- pending / pass / punish
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 启用 RLS
ALTER TABLE verdicts ENABLE ROW LEVEL SECURITY;

-- 允许匿名操作
CREATE POLICY "Allow anonymous insert" ON verdicts FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow anonymous update" ON verdicts FOR UPDATE USING (true);
CREATE POLICY "Allow anonymous select" ON verdicts FOR SELECT USING (true);
```

### Storage Bucket

```sql
-- 创建 proofs bucket
INSERT INTO storage.buckets (id, name) VALUES ('proofs', 'proofs');

-- 允许匿名上传/读取
CREATE POLICY "Allow anonymous upload" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'proofs');
CREATE POLICY "Allow anonymous read" ON storage.objects FOR SELECT USING (bucket_id = 'proofs');
```

### 匿名认证

Supabase Dashboard → Authentication → Providers → 启用 **Anonymous**

## H5 判决页

### 部署

```bash
cd judge
vercel --prod
```

已部署域名：https://judge-self.vercel.app

### URL 参数

| 参数 | 说明 |
|------|------|
| `verdict` | 判决记录 ID |
| `photo` | 拍照证据 URL |
| `task` | 任务标题 |

示例：
```
https://judge-self.vercel.app/?verdict=abc123&photo=https://...&task=健身打卡
```

### 判决流程

1. H5 页面从 URL 获取参数
2. 显示照片和任务标题
3. 用户点击"算他过了"或"立刻处刑"
4. 更新 Supabase verdicts 表的 status 字段
5. App 端轮询监听到状态变化

## 内购配置（RevenueCat）

### 配置步骤

1. 注册 RevenueCat 账号：https://revenuecat.com
2. 创建项目，添加 iOS/Android App
3. 配置订阅商品：
   - Product ID: `pro_monthly`
   - 价格: ¥9.9/月
4. 获取 API Key，配置 `lib/services/purchase_service.dart`

### 代码示例

```dart
// 检查是否已订阅
final isPro = await PurchaseService.isPro();

// 发起购买
await PurchaseService.purchasePro();

// 监听购买状态
PurchaseService.addListener(() {
  // 状态变化时刷新 UI
});
```

## 调试技巧

### 查看 Supabase 数据

```bash
# 使用 Supabase CLI
supabase start
supabase db reset
```

或在 Dashboard 直接查看：https://supabase.com/dashboard

### 测试判决流程

手动构造测试 URL：
```
https://judge-self.vercel.app/?verdict=test123&photo=https://via.placeholder.com/400&task=测试任务
```

### 常见问题

**Q: Web 端无法使用相机？**

A: 浏览器安全限制，会自动降级为文件选择器。这是正常行为。

**Q: 图片上传失败？**

A: 确保 Supabase Storage bucket 已创建且配置了匿名上传策略。

**Q: 判决状态不更新？**

A: 检查 Supabase RLS 策略是否允许匿名更新。

## 发布流程

### iOS

1. 注册苹果开发者账号（$99/年）
2. 在 App Store Connect 创建 App
3. 准备截图、描述、隐私政策
4. `flutter build ios --release`
5. 通过 Xcode 上传到 App Store

### Android

1. 注册 Google Play 开发者账号（$25 一次性）
2. 创建应用，配置签名
3. `flutter build apk --release`
4. 上传到 Google Play Console

### Web

```bash
flutter build web
# 部署 build/web 目录到任意静态托管
```

## 代码规范

- 使用 `flutter analyze` 检查问题
- 使用 `dart format .` 格式化代码
- 注释使用中文
- 遵循 Dart 官方代码风格
