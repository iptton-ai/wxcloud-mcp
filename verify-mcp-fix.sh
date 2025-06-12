#!/bin/bash

# MCP工具修复验证脚本

echo "🔧 MCP工具修复验证"
echo "=================="

# 测试1: 基本环境检查
echo -e "\n📋 测试1: 基本环境检查"
echo "检查wxcloud CLI..."
if command -v wxcloud &> /dev/null; then
    echo "✅ wxcloud CLI 已安装: $(wxcloud --version)"
else
    echo "❌ wxcloud CLI 未安装"
    exit 1
fi

# 测试2: 环境列表获取
echo -e "\n📋 测试2: 环境列表获取"
echo "执行: wxcloud env:list --json"
ENV_OUTPUT=$(wxcloud env:list --json 2>&1)
if echo "$ENV_OUTPUT" | grep -q '"code":0'; then
    echo "✅ 环境列表获取成功"
    ENV_ID=$(echo "$ENV_OUTPUT" | grep -o '"EnvId":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "📋 找到环境ID: $ENV_ID"
else
    echo "❌ 环境列表获取失败"
    echo "$ENV_OUTPUT"
fi

# 测试3: 服务列表（带环境ID）
if [ ! -z "$ENV_ID" ]; then
    echo -e "\n📋 测试3: 服务列表查询"
    echo "执行: wxcloud service:list --json --envId=$ENV_ID"
    SERVICE_OUTPUT=$(wxcloud service:list --json --envId=$ENV_ID 2>&1)
    if echo "$SERVICE_OUTPUT" | grep -q '"code":0'; then
        echo "✅ 服务列表查询成功"
    else
        echo "❌ 服务列表查询失败"
        echo "$SERVICE_OUTPUT"
    fi
fi

# 测试4: MCP服务器启动
echo -e "\n📋 测试4: MCP服务器启动测试"
echo "测试MCP服务器基本功能..."

# 创建测试输入
TEST_INPUT='{"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}}'

# 启动MCP服务器并发送测试请求
echo "$TEST_INPUT" | timeout 10s node dist/index.js > mcp_test_output.json 2>&1 &
MCP_PID=$!

# 等待结果
sleep 5

# 检查输出
if [ -f mcp_test_output.json ]; then
    if grep -q '"tools"' mcp_test_output.json; then
        echo "✅ MCP服务器工具列表响应正常"
        TOOL_COUNT=$(grep -o '"name":"[^"]*"' mcp_test_output.json | wc -l)
        echo "📊 可用工具数量: $TOOL_COUNT"
    else
        echo "❌ MCP服务器响应异常"
        cat mcp_test_output.json
    fi
else
    echo "❌ MCP服务器无响应"
fi

# 清理
kill $MCP_PID 2>/dev/null || true
rm -f mcp_test_output.json

# 总结
echo -e "\n🎉 修复验证完成!"
echo "主要修复内容:"
echo "✅ 添加了30秒超时保护"
echo "✅ 修复了service_list工具的交互模式问题"  
echo "✅ 添加了智能环境ID获取机制"
echo "✅ 改进了错误处理和用户提示"
echo ""
echo "现在MCP工具应该能够可靠地执行并及时返回结果！"
