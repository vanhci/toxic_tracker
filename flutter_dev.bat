@echo off
REM Flutter 快速启动脚本
REM 将此文件放在项目根目录，双击运行

set FLUTTER_HOME=E:\works\flutter_sdk\flutter
set PATH=%FLUTTER_HOME%\bin;%PATH%

REM 配置中国镜像
set PUB_HOSTED_URL=https://pub.flutter-io.cn
set FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo ========================================
echo Flutter 开发环境
echo ========================================
echo.
echo Flutter SDK: %FLUTTER_HOME%
echo.

REM 检查 Flutter 是否存在
if not exist "%FLUTTER_HOME%\bin\flutter.bat" (
    echo 错误：Flutter SDK 未找到！
    echo 请先安装 Flutter SDK 到 %FLUTTER_HOME%
    echo.
    pause
    exit /b 1
)

echo 检查 Flutter 环境...
call flutter doctor

echo.
echo ========================================
echo 可用命令：
echo ========================================
echo flutter devices       - 查看可用设备
echo flutter pub get       - 安装依赖
echo flutter run           - 运行应用
echo flutter clean         - 清理构建
echo flutter doctor -v     - 详细环境检查
echo.
echo 按任意键打开命令行...
pause > nul

cmd /k "cd /d E:\works\toxic_tracker"
