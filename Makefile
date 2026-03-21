.PHONY: help install run run-web build build-web build-ios build-android test test-coverage analyze clean format check release version

help:
	@echo "今天鸽了吗 - 开发命令"
	@echo ""
	@echo "使用: make [命令]"
	@echo ""
	@echo "开发命令:"
	@echo "  install        安装依赖"
	@echo "  run            运行应用（默认设备）"
	@echo "  run-web        运行 Web 应用"
	@echo "  clean          清理构建缓存"
	@echo ""
	@echo "构建命令:"
	@echo "  build          构建所有平台"
	@echo "  build-web      构建 Web 版本"
	@echo "  build-ios      构建 iOS 版本"
	@echo "  build-android  构建 Android APK"
	@echo ""
	@echo "测试命令:"
	@echo "  test           运行测试"
	@echo "  test-coverage  运行测试并生成覆盖率报告"
	@echo "  analyze        代码分析"
	@echo "  format         格式化代码"
	@echo "  check          分析 + 测试"
	@echo ""
	@echo "发布命令:"
	@echo "  release        清理、检查、构建"
	@echo "  version        显示当前版本"

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

test-coverage:
	flutter test --coverage
	@echo "覆盖率报告: coverage/lcov.info"

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

# 显示版本
version:
	@echo "当前版本: 1.0.0+1"
	@grep "version:" pubspec.yaml | head -1
