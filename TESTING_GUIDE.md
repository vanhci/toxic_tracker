# 测试指南

## 快速测试步骤

### 方式一：使用批处理脚本（推荐）

1. 双击运行 `run_web.bat`
2. 等待依赖安装（首次运行需要 5-10 分钟）
3. Chrome 浏览器会自动打开应用

### 方式二：手动命令行

打开命令提示符（CMD）或 PowerShell，执行：

```bash
cd E:\works\toxic_tracker

# 设置环境变量
set PATH=E:\works\flutter_sdk\flutter\bin;%PATH%
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 安装依赖（首次运行）
flutter pub get

# 运行 Web 版本
flutter run -d chrome
```

## 首次运行注意事项

1. **首次运行会很慢**：Flutter 需要下载依赖包，可能需要 5-10 分钟
2. **需要 Chrome 浏览器**：确保已安装 Google Chrome
3. **网络要求**：需要稳定的网络连接下载依赖

## 预期结果

成功运行后，你会看到：
- Chrome 浏览器自动打开
- 显示"今天鸽了吗"应用界面
- 可以添加任务、设置截止日期
- 点击"今天又鸽了"按钮测试功能
- 连续鸽 3 次会触发惩罚页面（30 秒倒计时）

## 故障排除

### 问题：flutter 命令找不到
**解决**：确保已设置环境变量，或使用完整路径：
```bash
E:\works\flutter_sdk\flutter\bin\flutter
```

### 问题：依赖下载很慢
**解决**：已配置中国镜像源，如果还是很慢，请检查网络连接

### 问题：Chrome 未找到
**解决**：
1. 安装 Google Chrome 浏览器
2. 或使用其他浏览器：`flutter run -d edge`（Microsoft Edge）

### 问题：端口被占用
**解决**：关闭其他占用端口的程序，或 Flutter 会自动选择其他端口

## 开发模式功能

应用运行后，在命令行中可以使用：
- 按 `r` - 热重载（快速刷新）
- 按 `R` - 热重启（完全重启）
- 按 `q` - 退出应用
- 按 `h` - 查看帮助

## 下一步

测试成功后，你可以：
1. 修改代码（在 `lib/` 目录下）
2. 按 `r` 热重载查看效果
3. 构建 APK：`flutter build apk`
4. 部署到 Android 设备或模拟器

## 技术支持

如遇问题，请查看：
- Flutter 官方文档：https://flutter.dev
- Flutter 中文网：https://flutter.cn
- 项目 GitHub：https://github.com/vanhci/toxic_tracker
