# 今天鸽了吗 (Toxic Tracker)

[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Tests](https://img.shields.io/badge/Tests-64%20passed-brightgreen)](test/)

一款极简风格的自律应用，没有温柔的鼓励，只有无情的嘲讽。连续鸽了3次，你的死党将有权远程处刑。

**[快速开始](QUICKSTART.md)** · **[用户指南](docs/USER_GUIDE.md)** · **[开发文档](DEVELOPMENT.md)**

---

## 截图

<p align="center">
  <img src="docs/screenshots/home.png" width="200" alt="首页"/>
  <img src="docs/screenshots/punishment.png" width="200" alt="惩罚页面"/>
  <img src="docs/screenshots/coach.png" width="200" alt="教练选择"/>
</p>

---

## 功能特性

### 核心功能
- 📝 添加任务并设置截止日期
- ⏰ 实时显示剩余天数和逾期状态
- 🔥 记录连续鸽了多少次
- ⚡ 连续鸽3次触发惩罚模式

### 社交裂变引擎
- 📸 **强制拍照留证**：鸽了必须拍照，没有照片不算数
- 🔗 **分享给死党判决**：生成分享链接，让死党当行刑官
- 💀 **远程处刑**：死党选择"立刻处刑"，App 端触发30秒惩罚锁屏

### 商业化闭环
- 🎭 **教练选妃系统**：6位毒舌教练人设
- 💰 **订阅方案**：月度¥9.9 / 年度¥68 / 终身¥98

### 功能增强
- 📸 **耻辱海报生成器**：受罚后生成带二维码的精美海报
- 🏆 **成就系统**：连续完成 N 天获得徽章
- 📊 **数据统计**：可视化展示鸽了多少次
- 🌙 **深色模式**：自动适应系统主题
- 🌍 **多语言**：支持中/英文

### 技术优化
- 📴 **离线模式**：断网时照片暂存本地，联网后自动上传
- 📱 **桌面小组件**：iOS/Android 小组件实时显示任务状态
- ⌚ **Apple Watch**：配套应用查看任务统计
- 🔔 **推送通知**：任务提醒和截止日期通知
- 🎤 **自定义教练声音**：TTS 语音 + 可配置音调/语速

### 企业版（团队监督）
- 🏢 **团队管理**：创建团队，邀请成员
- 📈 **鸽子排行榜**：查看团队成员鸽子次数排名
- 👥 **成员管理**：查看成员完成率统计

## 快速开始

### 前置要求

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode（用于移动端调试）

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

### 构建

```bash
# 构建 Web 版本
flutter build web

# 构建 iOS
flutter build ios

# 构建 Android
flutter build apk
```

### 使用 Makefile（推荐）

```bash
make install      # 安装依赖
make run-web      # 运行 Web 应用
make build        # 构建所有平台
make test         # 运行测试
make analyze      # 代码分析
make check        # 分析 + 测试
make clean        # 清理构建缓存
```

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/
│   ├── task.dart               # 任务数据模型
│   ├── coach.dart              # 教练模型（6位教练人设）
│   ├── achievement.dart        # 成就模型
│   └── team.dart               # 团队模型
├── screens/
│   ├── home_screen.dart        # 首页（任务列表 + 拍照上传 + 分享）
│   ├── add_task_screen.dart    # 添加任务页面
│   ├── punishment_screen.dart  # 30秒惩罚锁屏页
│   ├── coach_selection_screen.dart # 教练选妃列表 + 付费墙
│   ├── achievement_screen.dart # 成就展示页面
│   └── team_screen.dart        # 团队管理页面
├── services/
│   ├── task_storage.dart       # SharedPreferences 封装
│   ├── upload_service.dart     # Supabase Storage 上传服务
│   ├── verdict_service.dart    # 判决服务（轮询监听）
│   ├── purchase_service.dart   # RevenueCat 内购服务
│   ├── notification_service.dart # 推送通知服务
│   ├── widget_service.dart     # 桌面小组件服务
│   ├── voice_service.dart      # 教练语音服务
│   ├── offline_service.dart    # 离线模式服务
│   ├── theme_service.dart      # 主题服务
│   ├── locale_service.dart     # 国际化服务
│   ├── achievement_service.dart # 成就服务
│   ├── shame_poster_service.dart # 耻辱海报服务
│   └── team_service.dart       # 团队服务
└── l10n/
    └── app_localizations.dart  # 多语言支持

ios/ToxicTrackerWidget/          # iOS 小组件
android/app/src/main/kotlin/    # Android 小组件
ios/ToxicTrackerWatch/           # Apple Watch 应用
judge/
└── index.html                  # H5 判决页面（部署在 Vercel）
```

## 技术架构

### 前端
- **Flutter**：跨平台框架
- **状态管理**：StatefulWidget + setState（无第三方状态管理库）
- **UI 风格**：粗野主义（Brutalist）设计

### 后端服务
- **Supabase**：
  - Storage：存储拍照证据
  - Database：记录判决数据、团队数据
  - Auth：匿名认证
- **RevenueCat**：订阅支付管理

### 部署
- **H5 判决页**：Vercel（https://judge-self.vercel.app）

### CI/CD
- **GitHub Actions**：自动化测试和构建
- **代码质量**：分析 + 测试
- **自动构建**：Web + Android APK
- **自动部署**：GitHub Pages

## 设计风格

全局粗野主义（Brutalist）风格：

- 主色调：`#CCFF00`（荧光黄）
- 危险/逾期：`#FF3333`（红色）
- 硬阴影：零模糊，`BoxShadow(offset: Offset(4,4), blurRadius: 0)`
- Material 3：已禁用（`useMaterial3: false`）

## 完整流程

```
用户创建任务
    ↓
点击"鸽了"按钮
    ↓
连续鸽3次 → 触发惩罚流程
    ↓
强制拍照 → 上传到 Supabase Storage
    ↓
生成分享链接 → 分享给死党
    ↓
死党打开 H5 判决页 → 选择"算他过了"或"立刻处刑"
    ↓
App 轮询监听判决结果
    ↓
如果"立刻处刑" → 播放教练语音 → 进入30秒惩罚锁屏
```

## 配置清单

详细配置请参考 [TODO.md](./TODO.md)

### 必需配置
1. **Supabase**：创建项目，配置 Storage 和 Database ✅ 已完成
2. **Vercel**：部署 H5 判决页 ✅ 已完成
3. **RevenueCat**：配置订阅商品（商业化需要）

### 可选配置
- Apple Watch：在 Xcode 中添加 Watch Target
- 团队功能：在 Supabase 创建 teams 和 team_members 表

## 相关文档

- [TODO.md](./TODO.md) - 待实现功能清单
- [CLAUDE.md](./CLAUDE.md) - Claude Code 开发指南
- [docs/enterprise_design.md](./docs/enterprise_design.md) - 企业版设计文档

## 许可证

MIT License
