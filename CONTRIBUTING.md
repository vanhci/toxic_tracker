# 贡献指南

感谢你对「今天鸽了吗」项目的关注！

## 开发环境设置

### 前置要求

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode（用于移动端开发）
- VS Code 或其他 IDE

### 安装依赖

```bash
flutter pub get
```

### 运行应用

```bash
# Web 浏览器（推荐用于开发调试）
flutter run -d chrome

# iOS 模拟器
flutter run -d ios

# Android 模拟器
flutter run -d android
```

## 代码规范

### 分析检查

```bash
flutter analyze
```

目标：0 warnings, 0 errors

### 测试

```bash
flutter test
```

目标：所有测试通过

### 构建验证

```bash
# Web 构建
flutter build web

# iOS 构建
flutter build ios

# Android 构建
flutter build apk
```

## 项目结构

```
lib/
├── main.dart           # 应用入口
├── models/             # 数据模型
├── screens/            # UI 页面
├── services/           # 业务服务
└── l10n/               # 国际化

test/                   # 单元测试
```

## 设计风格

本项目采用粗野主义（Brutalist）设计风格：

- 主色调：`#CCFF00`（荧光黄）
- 危险色：`#FF3333`（红色）
- 硬阴影：零模糊
- Material 3：禁用

## 提交规范

```
feat: 新功能
fix: 修复 bug
docs: 文档更新
style: 代码格式化
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

## 后端配置

### Supabase

1. 创建 Supabase 项目
2. 运行 `supabase/migrations.sql` 创建表
3. 配置 Storage bucket
4. 更新 `lib/main.dart` 中的配置

### RevenueCat

1. 注册 RevenueCat 账号
2. 配置 iOS/Android 应用
3. 更新 `lib/services/purchase_service.dart` 中的 API Key

## 发布清单

- [ ] 代码分析通过
- [ ] 测试通过
- [ ] Web 构建成功
- [ ] iOS 构建成功
- [ ] Android 构建成功
- [ ] 更新 CHANGELOG.md
- [ ] 更新版本号

## 许可证

MIT License
