.PHONY: help install run run-web build build-web build-ios build-android test analyze clean format

help:
	@echo "今天鸽了吗 - 开发命令"
	@echo ""
	@echo "使用: make [命令]"
	@echo ""
	@echo "可用命令:"
	@echo "  install      安装依赖"
	@echo "  run          运行应用（默认设备）"
	@echo "  run-web      运行 Web 应用"
	@echo "  build        构建所有平台"
	@echo "  build-web    构建 Web 版本"
	@echo "  build-ios    构建 iOS 版本"
	@echo "  build-android 构建 Android APK"
	@echo "  test         运行测试"
	@echo "  analyze      代码分析"
	@echo "  format       格式化代码"
	@echo "  clean        清理构建缓存"

install:
	flutter pub get

run:
	flutter run

run-web:
	flutter run -d chrome

build: build-web build-android
	@echo "构建完成！"

build-web:
	flutter build web --release
	@echo "Web 构建完成: build/web"

build-ios:
	flutter build ios --release
	@echo "iOS 构建完成"

build-android:
	flutter build apk --release
	@echo "Android APK 构建完成: build/app/outputs/flutter-apk/app-release.apk"

test:
	flutter test

analyze:
	flutter analyze

format:
	dart format .

clean:
	flutter clean
	flutter pub get

# 快捷命令
check: analyze test
	@echo "✅ 代码检查通过"

# 发布准备
release: clean check build
	@echo "✅ 发布准备完成"
