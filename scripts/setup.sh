#!/bin/bash
# 项目初始化脚本

set -e

echo "========================================"
echo "  今天鸽了吗 - 项目初始化"
echo "========================================"
echo ""

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装"
    echo "请访问 https://flutter.dev 获取安装指南"
    exit 1
fi

echo "Flutter 版本:"
flutter --version
echo ""

# 安装依赖
echo ">>> 安装依赖..."
flutter pub get

# 生成代码（如果需要）
# flutter pub run build_runner build

# 运行分析
echo ""
echo ">>> 代码分析..."
flutter analyze

# 运行测试
echo ""
echo ">>> 运行测试..."
flutter test

echo ""
echo "========================================"
echo "  初始化完成！"
echo "========================================"
echo ""
echo "下一步:"
echo "1. 配置 Supabase: 编辑 lib/main.dart"
echo "2. 配置 RevenueCat: 编辑 lib/services/purchase_service.dart"
echo "3. 运行应用: flutter run -d chrome"
echo ""
echo "查看更多命令: make help"
