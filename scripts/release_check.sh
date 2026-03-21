#!/bin/bash
# 发布前检查脚本

set -e

echo "========================================"
echo "  今天鸽了吗 - 发布前检查"
echo "========================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
WARN=0

check_pass() {
    echo -e "${GREEN}[✓]${NC} $1"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}[✗]${NC} $1"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
    ((WARN++))
}

# 1. 代码分析
echo ">>> 代码分析"
if flutter analyze 2>&1 | grep -q "No issues found"; then
    check_pass "代码分析通过"
else
    check_fail "代码分析发现问题"
fi

# 2. 单元测试
echo ""
echo ">>> 单元测试"
if flutter test 2>&1 | grep -q "All tests passed"; then
    check_pass "单元测试通过"
else
    check_fail "单元测试失败"
fi

# 3. Web 构建
echo ""
echo ">>> Web 构建"
if flutter build web --release 2>&1 | grep -q "Built build/web"; then
    check_pass "Web 构建成功"
else
    check_fail "Web 构建失败"
fi

# 4. 检查必要文件
echo ""
echo ">>> 必要文件检查"
files=("README.md" "CHANGELOG.md" "LICENSE" "CONTRIBUTING.md" "TODO.md" "pubspec.yaml")
for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        check_pass "文件存在: $file"
    else
        check_fail "文件缺失: $file"
    fi
done

# 5. 检查文档
echo ""
echo ">>> 文档检查"
docs=("docs/APPSTORE_CHECKLIST.md" "docs/PRIVACY_POLICY.md" "docs/REVENUECAT_SETUP.md")
for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        check_pass "文档存在: $doc"
    else
        check_warn "文档缺失: $doc"
    fi
done

# 6. 检查配置
echo ""
echo ">>> 配置检查"

# 检查 Supabase 配置
if grep -q "YOUR_SUPABASE" lib/main.dart 2>/dev/null; then
    check_warn "Supabase 配置未完成（占位符）"
else
    check_pass "Supabase 配置已设置"
fi

# 检查 RevenueCat 配置
if grep -q "YOUR_REVENUECAT" lib/services/purchase_service.dart 2>/dev/null; then
    check_warn "RevenueCat 配置未完成（占位符）"
else
    check_pass "RevenueCat 配置已设置"
fi

# 7. 检查 CI/CD
echo ""
echo ">>> CI/CD 检查"
if [ -f ".github/workflows/ci.yml" ]; then
    check_pass "CI 工作流已配置"
else
    check_warn "CI 工作流未配置"
fi

if [ -f ".github/workflows/deploy.yml" ]; then
    check_pass "部署工作流已配置"
else
    check_warn "部署工作流未配置"
fi

# 8. Git 状态
echo ""
echo ">>> Git 状态"
if git diff-index --quiet HEAD -- 2>/dev/null; then
    check_pass "工作区干净，无未提交更改"
else
    check_warn "存在未提交的更改"
fi

# 总结
echo ""
echo "========================================"
echo "  检查结果"
echo "========================================"
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo -e "${YELLOW}警告: $WARN${NC}"
echo ""

if [ $FAIL -gt 0 ]; then
    echo -e "${RED}存在失败项，请修复后再发布。${NC}"
    exit 1
elif [ $WARN -gt 0 ]; then
    echo -e "${YELLOW}存在警告项，建议处理后再发布。${NC}"
    exit 0
else
    echo -e "${GREEN}所有检查通过，可以发布！${NC}"
    exit 0
fi
