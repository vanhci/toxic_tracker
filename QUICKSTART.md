# 快速启动指南

## 5 分钟快速开始

### 1. 克隆项目

```bash
git clone https://github.com/vanhci/toxic_tracker.git
cd toxic_tracker
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. 配置后端（必需）

#### Supabase 配置

1. 访问 [supabase.com](https://supabase.com) 创建项目
2. 获取 Project URL 和 Anon Key
3. 运行 SQL 脚本创建表：

```bash
# 在 Supabase SQL Editor 中运行
cat supabase/migrations.sql
```

4. 更新 `lib/main.dart`：

```dart
const supabaseUrl = 'https://your-project.supabase.co';
const supabaseAnonKey = 'your-anon-key';
```

### 4. 运行应用

```bash
# Web（推荐开发调试）
flutter run -d chrome

# iOS 模拟器
flutter run -d ios

# Android 模拟器
flutter run -d android
```

## 可选配置

### RevenueCat（订阅功能）

1. 访问 [revenuecat.com](https://revenuecat.com) 创建账号
2. 获取 API Key
3. 更新 `lib/services/purchase_service.dart`：

```dart
static const String _apiKey = 'your-revenuecat-api-key';
```

### Apple Watch

在 Xcode 中添加 Watch Target：
1. 打开 `ios/Runner.xcworkspace`
2. File → New → Target → watchOS → App
3. 复制 `ios/ToxicTrackerWidget/` 中的代码

### 桌面小组件

小组件代码已就绪，iOS/Android 会自动识别。

## 开发命令

```bash
make install      # 安装依赖
make run-web      # 运行 Web
make build        # 构建所有平台
make test         # 运行测试
make analyze      # 代码分析
```

## 常见问题

**Q: Web 端相机无法使用？**
A: 浏览器限制，会自动降级为文件选择器。

**Q: 图片上传失败？**
A: 检查 Supabase Storage 配置和 RLS 策略。

**Q: 测试失败？**
A: 运行 `flutter clean && flutter pub get` 后重试。

## 下一步

- 阅读 [用户指南](docs/USER_GUIDE.md)
- 查看 [开发文档](DEVELOPMENT.md)
- 准备 [App Store 上架](docs/APPSTORE_CHECKLIST.md)

## 获取帮助

- GitHub Issues: https://github.com/vanhci/toxic_tracker/issues
- 文档: `/docs` 目录
