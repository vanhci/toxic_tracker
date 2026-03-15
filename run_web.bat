@echo off
echo ========================================
echo 今天鸽了吗 - Web 浏览器测试
echo ========================================
echo.

REM 设置 Flutter 环境变量
set PATH=E:\works\flutter_sdk\flutter\bin;%PATH%
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo [1/3] 检查 Flutter 环境...
flutter --version
echo.

echo [2/3] 安装项目依赖...
flutter pub get
echo.

echo [3/3] 启动 Web 服务器...
echo 浏览器将自动打开 http://localhost:xxxx
echo 按 Ctrl+C 可以停止服务器
echo.
flutter run -d chrome

pause
