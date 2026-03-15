#!/bin/bash
# Flutter 快速启动脚本（Git Bash）

export FLUTTER_HOME="/e/works/flutter_sdk/flutter"
export PATH="$FLUTTER_HOME/bin:$PATH"

# 配置中国镜像
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"

echo "========================================"
echo "Flutter 开发环境"
echo "========================================"
echo ""
echo "Flutter SDK: $FLUTTER_HOME"
echo ""

# 检查 Flutter 是否存在
if [ ! -f "$FLUTTER_HOME/bin/flutter" ]; then
    echo "错误：Flutter SDK 未找到！"
    echo "请先安装 Flutter SDK 到 $FLUTTER_HOME"
    exit 1
fi

echo "检查 Flutter 环境..."
flutter doctor

echo ""
echo "========================================"
echo "可用命令："
echo "========================================"
echo "flutter devices       - 查看可用设备"
echo "flutter pub get       - 安装依赖"
echo "flutter run           - 运行应用"
echo "flutter clean         - 清理构建"
echo "flutter doctor -v     - 详细环境检查"
echo ""

cd /e/works/toxic_tracker
bash
