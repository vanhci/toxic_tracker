# 今天鸽了吗 (Toxic Tracker)

一款极简作死记录应用，帮助你追踪那些你一直在拖延的任务。

## 功能特性

- 📝 添加作死任务并设置截止日期
- ⏰ 实时显示剩余天数和逾期状态
- 🔥 记录连续鸽了多少次
- ⚡ 连续鸽3次触发惩罚模式
- 🎯 极简 UI，专注核心功能

## 开始使用

### 前置要求

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (用于运行模拟器)

### 安装依赖

```bash
cd toxic_tracker
flutter pub get
```

### 运行应用

```bash
flutter run
```

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/
│   └── task.dart            # 任务数据模型
├── screens/
│   ├── home_screen.dart     # 首页（任务列表）
│   ├── add_task_screen.dart # 添加任务页面
│   └── punishment_screen.dart # 惩罚页面
└── services/
    └── task_storage.dart    # 本地存储服务
```

## 技术栈

- Flutter
- SharedPreferences (本地数据持久化)
- Material Design 3

## 许可证

MIT License
