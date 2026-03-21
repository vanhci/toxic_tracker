# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 提供在此仓库中工作的指导。

**重要：始终使用中文回答及编写文档。**

## 环境准备

Flutter 通过 Homebrew 安装：
```bash
brew install --cask flutter
```

安装后验证：
```bash
flutter doctor
```

## 常用命令

```bash
# 安装依赖
flutter pub get

# 在 Chrome 中运行（推荐）
flutter run -d chrome

# 在连接的设备/模拟器上运行
flutter run

# 构建 Web
flutter build web

# 运行测试
flutter test
```

## 架构说明

Flutter 应用，无状态管理库——每个 `StatefulWidget` 通过 `setState` 在本地管理状态。各屏幕直接实例化 `TaskStorage` 并在用户操作时调用。

**数据层：** `TaskStorage` 封装 `SharedPreferences`，将 `List<Task>` 序列化为 JSON。每次增删改都是完整的读-改-写循环。

**Task 模型：** `Task` 除 `consecutiveFails` 和 `lastFailDate` 外均不可变，更新时使用 `copyWith()`。惩罚触发阈值硬编码为 `consecutiveFails >= 3`，位于 `HomeScreen._markAsFailed()`。

**页面流转：**
- `HomeScreen` → 任务列表，"鸽了"按钮累加 `consecutiveFails`，达到 3 次触发惩罚弹窗
- `AddTaskScreen` → 创建新任务的表单，保存后 pop 返回
- `PunishmentScreen` → 30 秒锁定页面（通过 `PopScope` 禁用返回键），接收 `punishmentType` 和 `taskTitle` 作为构造参数

## 设计风格

全局粗野主义（Brutalist）风格，关闭 Material 3 柔和效果（`useMaterial3: false`）。关键常量：
- 主色调：`Color(0xFFCCFF00)`（荧光黄）
- 危险/逾期：`Color(0xFFFF3333)`（红色）
- 硬阴影：`BoxShadow(color: Colors.black, offset: Offset(4,4), blurRadius: 0)`，零模糊是刻意为之
- 所有页面使用自定义 Header，替代标准 `AppBar`
