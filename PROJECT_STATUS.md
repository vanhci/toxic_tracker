# 《今天鸽了吗》项目说明

## 项目状态

✅ Flutter 项目已创建完成
⏳ Flutter SDK 正在安装中（Git 克隆）

## 项目位置

- **项目目录**: `E:\works\toxic_tracker`
- **Flutter SDK**: `E:\works\flutter_sdk\flutter`

## 当前进度

### 已完成
1. ✅ 创建完整的 Flutter 项目结构
2. ✅ 实现所有核心功能：
   - 首页任务列表
   - 添加任务页面
   - 惩罚页面（连续鸽3次触发）
3. ✅ 配置 Android 和 iOS 构建文件
4. ✅ 创建安装脚本和开发环境脚本
5. ⏳ Flutter SDK 正在通过 Git 克隆（进行中）

### 待完成
1. ⏳ 等待 Flutter SDK 克隆完成（约 5-10 分钟）
2. ⏳ 运行 `flutter doctor` 检查环境
3. ⏳ 安装 Android Studio（用于 Android 开发）
4. ⏳ 安装项目依赖 `flutter pub get`
5. ⏳ 运行应用 `flutter run`

## 快速开始（Flutter SDK 安装完成后）

### 方法一：使用快速启动脚本

双击运行：
```
E:\works\toxic_tracker\flutter_dev.bat
```

这会自动配置环境并打开命令行。

### 方法二：手动配置

1. **配置环境变量**（永久）
   - 打开"系统属性" → "环境变量"
   - 在"用户变量"的 `Path` 中添加：
     ```
     E:\works\flutter_sdk\flutter\bin
     ```
   - 添加新变量：
     - `PUB_HOSTED_URL` = `https://pub.flutter-io.cn`
     - `FLUTTER_STORAGE_BASE_URL` = `https://storage.flutter-io.cn`

2. **重启命令行**，然后运行：
   ```bash
   flutter doctor
   ```

3. **安装项目依赖**：
   ```bash
   cd E:\works\toxic_tracker
   flutter pub get
   ```

4. **运行应用**：
   ```bash
   flutter run
   ```

## 检查 Flutter SDK 安装进度

在命令行中运行：
```bash
cd E:\works\flutter_sdk\flutter
git status
```

如果显示 "On branch stable"，说明克隆完成。

## 安装 Android Studio（必需）

1. 下载：https://developer.android.com/studio
2. 安装时选择：
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)
3. 打开 Android Studio
4. 进入 SDK Manager，确保安装了：
   - Android SDK Platform-Tools
   - Android SDK Build-Tools
   - Android Emulator
5. 创建一个虚拟设备（AVD）用于测试

## 接受 Android 许可

安装 Android Studio 后，运行：
```bash
flutter doctor --android-licenses
```
全部输入 `y` 接受。

## 验证环境

运行以下命令检查所有工具是否正确安装：
```bash
flutter doctor -v
```

应该看到类似输出：
```
[✓] Flutter (Channel stable, 3.24.5, on Microsoft Windows)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code (optional)
[✓] Connected device
```

## 运行项目

### 使用 Android 模拟器
```bash
cd E:\works\toxic_tracker
flutter devices          # 查看可用设备
flutter run              # 运行应用
```

### 使用真机
1. 连接 Android 手机
2. 开启"开发者选项"和"USB 调试"
3. 运行 `flutter devices` 确认设备已连接
4. 运行 `flutter run`

## 常用命令

```bash
# 查看可用设备
flutter devices

# 安装依赖
flutter pub get

# 运行应用
flutter run

# 热重载（应用运行时按 r）
r

# 热重启（应用运行时按 R）
R

# 清理构建
flutter clean

# 构建 APK
flutter build apk

# 构建 iOS（仅 macOS）
flutter build ios
```

## 项目功能说明

### 1. 首页（HomeScreen）
- 显示所有任务列表
- 每个任务显示：
  - 任务标题
  - 截止日期
  - 剩余天数/逾期天数
  - 连续鸽了次数（如果有）
- "今天又鸽了"按钮：点击增加鸽了次数
- 连续鸽3次自动触发惩罚页面

### 2. 添加任务页（AddTaskScreen）
- 输入任务名称
- 选择截止日期
- 保存到本地存储

### 3. 惩罚页面（PunishmentScreen）
- 黑红渐变背景
- 显示"行刑官已降临"
- 30秒倒计时
- 倒计时结束前无法退出
- 倒计时结束后可以点击"逃离地狱"返回

## 技术栈

- **框架**: Flutter 3.24.5
- **语言**: Dart
- **状态管理**: StatefulWidget
- **本地存储**: SharedPreferences
- **UI**: Material Design 3

## 项目结构

```
toxic_tracker/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── models/
│   │   └── task.dart                # 任务数据模型
│   ├── screens/
│   │   ├── home_screen.dart         # 首页
│   │   ├── add_task_screen.dart     # 添加任务
│   │   └── punishment_screen.dart   # 惩罚页面
│   └── services/
│       └── task_storage.dart        # 本地存储服务
├── android/                         # Android 配置
├── ios/                            # iOS 配置
├── pubspec.yaml                    # 依赖配置
├── flutter_dev.bat                 # 快速启动脚本（Windows）
└── flutter_dev.sh                  # 快速启动脚本（Git Bash）
```

## 故障排除

### Flutter 命令找不到
- 确保已将 `E:\works\flutter_sdk\flutter\bin` 添加到 PATH
- 重启命令行窗口

### 下载依赖很慢
- 确保已配置中国镜像源（见上文）

### No devices found
- 启动 Android 模拟器
- 或连接真机并开启 USB 调试

### Android licenses 未接受
- 运行 `flutter doctor --android-licenses`
- 全部输入 `y`

## 下一步

1. 等待 Flutter SDK 克隆完成
2. 运行 `flutter doctor` 检查环境
3. 安装 Android Studio
4. 运行 `flutter pub get` 安装依赖
5. 运行 `flutter run` 启动应用

## 联系与支持

如有问题，请检查：
- Flutter 官方文档：https://flutter.dev/docs
- Flutter 中文网：https://flutter.cn
