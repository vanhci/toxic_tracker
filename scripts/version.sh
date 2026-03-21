#!/bin/bash
# 版本更新脚本

set -e

if [ -z "$1" ]; then
    echo "使用方法: ./scripts/version.sh <version>"
    echo "示例: ./scripts/version.sh 1.0.1"
    exit 1
fi

VERSION=$1
CURRENT_VERSION=$(grep "version:" pubspec.yaml | head -1 | sed 's/version: //')

echo "当前版本: $CURRENT_VERSION"
echo "目标版本: $VERSION"

# 更新 pubspec.yaml
sed -i '' "s/version: .*/version: $VERSION+1/" pubspec.yaml

# 更新 CHANGELOG.md
if [ -f CHANGELOG.md ]; then
    # 在第一个 ## 后插入新版本
    sed -i '' "s/## \[.*\]/## [$VERSION] - $(date +%Y-%m-%d)/" CHANGELOG.md
fi

echo "✅ 版本已更新到 $VERSION"
echo ""
echo "下一步:"
echo "1. 更新 CHANGELOG.md 添加更新内容"
echo "2. 运行: git add . && git commit -m 'chore: bump version to $VERSION'"
echo "3. 运行: git tag v$VERSION"
echo "4. 运行: git push && git push --tags"
