#!/bin/bash
# H5 判决页测试脚本

echo "🧪 H5 判决页测试"
echo "================="

JUDGE_URL="https://judge-self.vercel.app"

echo ""
echo "测试 URL："
echo ""

# 测试基础访问
echo "1. 基础页面访问："
echo "   $JUDGE_URL"
echo ""

# 测试带参数的 URL
echo "2. 带参数测试 URL："
TEST_URL="$JUDGE_URL/?verdict=test-123&photo=https://via.placeholder.com/400&task=测试任务"
echo "   $TEST_URL"
echo ""

# 测试 Supabase 连接
echo "3. 检查 Supabase 连接..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" "https://iyziuawpbpyvwhomtjkh.supabase.co/rest/v1/verdicts?select=count" -H "apikey: sb_publishable_XtedakJDneCB9Lboa4ZhNA_JjTzbaau" 2>/dev/null || echo "000")

if [ "$RESPONSE" = "200" ]; then
    echo "   ✅ Supabase 连接正常"
else
    echo "   ⚠️ Supabase 连接失败 (HTTP $RESPONSE)"
    echo "   可能需要检查网络或代理设置"
fi

echo ""
echo "📋 手动测试步骤："
echo "1. 运行 App: flutter run -d chrome"
echo "2. 创建任务，点击'鸽了' 3 次"
echo "3. 拍照上传，复制分享链接"
echo "4. 在浏览器打开链接"
echo "5. 点击'立刻处刑'或'算他过了'"
echo "6. 观察 App 是否触发惩罚"
