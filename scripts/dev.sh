#!/bin/bash
# 开发服务器启动脚本

set -e

echo "🚀 启动开发服务器..."
echo ""

# 检查依赖
if [ ! -d ".dart_tool" ]; then
    echo "📦 安装依赖..."
    flutter pub get
fi

# 运行 Web 版本
echo "🌐 启动 Web 应用..."
flutter run -d chrome "$@"
