#!/bin/bash
# 《今天鸽了吗》发布脚本

set -e

echo "🧨 今天鸽了吗 - 发布脚本"
echo "========================"

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装，请先安装 Flutter SDK"
    exit 1
fi

# 清理
echo ""
echo "📦 清理构建缓存..."
flutter clean

# 获取依赖
echo ""
echo "📥 获取依赖..."
flutter pub get

# 运行分析
echo ""
echo "🔍 代码分析..."
flutter analyze

# 运行测试
echo ""
echo "🧪 运行测试..."
flutter test

# 构建
echo ""
echo "🔨 构建生产版本..."

read -p "选择构建平台 (1=Web, 2=iOS, 3=Android, 4=全部): " choice

case $choice in
    1)
        echo "构建 Web 版本..."
        flutter build web --release
        echo "✅ Web 构建完成: build/web/"
        ;;
    2)
        echo "构建 iOS 版本..."
        flutter build ios --release
        echo "✅ iOS 构建完成"
        ;;
    3)
        echo "构建 Android 版本..."
        flutter build apk --release
        echo "✅ Android APK: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    4)
        echo "构建所有平台..."
        flutter build web --release
        flutter build ios --release
        flutter build apk --release
        echo "✅ 全部构建完成"
        ;;
    *)
        echo "无效选择，退出"
        exit 1
        ;;
esac

echo ""
echo "🎉 发布准备完成！"
