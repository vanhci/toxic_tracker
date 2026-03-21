# 今天鸽了吗 (Toxic Tracker)

一款极简风格的自律应用，没有温柔的鼓励，只有无情的嘲讽。连续鸽了3次，你的死党将有权远程处刑。

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
- 🎭 **教练选妃系统**：3位毒舌教练人设
- 💰 **付费墙**：解锁更多教练需订阅（9.9元/月）

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

## 项目结构

```
lib/
├── main.dart                    # 应用入口，Supabase 初始化
├── models/
│   ├── task.dart               # 任务数据模型
│   └── coach.dart              # 教练模型（3位教练人设）
├── screens/
│   ├── home_screen.dart        # 首页（任务列表 + 拍照上传 + 分享）
│   ├── add_task_screen.dart    # 添加任务页面
│   ├── punishment_screen.dart  # 30秒惩罚锁屏页
│   └── coach_selection_screen.dart # 教练选妃列表 + 付费墙
└── services/
    ├── task_storage.dart       # SharedPreferences 封装
    ├── upload_service.dart     # Supabase Storage 上传服务
    ├── verdict_service.dart    # 判决服务（轮询监听）
    └── purchase_service.dart   # RevenueCat 内购服务

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
  - Database：记录判决数据
  - Auth：匿名认证
- **RevenueCat**：订阅支付管理

### 部署
- **H5 判决页**：Vercel（https://judge-self.vercel.app）

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
如果"立刻处刑" → 进入30秒惩罚锁屏
```

## 配置清单

详细配置请参考 [TODO.md](./TODO.md)

### 必需配置
1. **Supabase**：创建项目，配置 Storage 和 Database
2. **Vercel**：部署 H5 判决页（已完成）
3. **RevenueCat**：配置订阅商品（可选，商业化需要）

### 已完成
- ✅ Supabase 配置
- ✅ H5 判决页部署
- ✅ 图片上传 + 分享流程
- ✅ 判决监听 + 惩罚触发

## 相关文档

- [TODO.md](./TODO.md) - 待实现功能清单
- [CLAUDE.md](./CLAUDE.md) - Claude Code 开发指南
- [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) - Supabase 配置指南

## 许可证

MIT License
