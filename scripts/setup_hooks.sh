#!/bin/bash
# 设置 Git Hooks

set -e

echo "🔧 设置 Git Hooks..."

# 创建 .git/hooks 目录
mkdir -p .git/hooks

# 创建 pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "🔍 运行代码分析..."
flutter analyze --fatal-infos

echo "🧪 运行测试..."
flutter test

echo "✅ 所有检查通过"
EOF

chmod +x .git/hooks/pre-commit

echo "✅ Git Hooks 设置完成"
echo ""
echo "已安装的 hooks:"
echo "  - pre-commit: 提交前自动运行分析和测试"
