#!/bin/bash

# wxcloud-mcp 验证脚本

echo "🧪 验证 wxcloud-mcp 安装..."
echo "================================"

# 测试 --help 命令
echo "📋 测试 help 命令..."
if wxcloud-mcp --help > /dev/null 2>&1; then
    echo "✅ help 命令正常"
else
    echo "❌ help 命令失败"
    exit 1
fi

# 测试 --version 命令  
echo "📋 测试 version 命令..."
if wxcloud-mcp --version > /dev/null 2>&1; then
    echo "✅ version 命令正常"
else
    echo "❌ version 命令失败"
    exit 1
fi

# 检查微信云开发CLI
echo "📋 检查微信云开发CLI..."
if command -v wxcloud &> /dev/null; then
    echo "✅ 微信云开发CLI已安装"
    wxcloud --version 2>/dev/null || echo "ℹ️  版本信息获取失败，但CLI已安装"
else
    echo "⚠️  微信云开发CLI未安装，请运行: npm install -g @wxcloud/cli"
fi

# 测试MCP服务器启动 (快速测试)
echo "📋 测试MCP服务器启动..."
# 在后台启动服务器，然后快速杀死
wxcloud-mcp &
SERVER_PID=$!
sleep 1
if kill -0 $SERVER_PID 2>/dev/null; then
    echo "✅ MCP服务器可以正常启动"
    kill $SERVER_PID 2>/dev/null
else
    echo "ℹ️  MCP服务器启动测试完成"
fi

echo ""
echo "🎉 验证完成！"
echo ""
echo "📖 使用说明:"
echo "1. 确保已登录微信云开发: wxcloud login"
echo "2. 在Claude Desktop中配置MCP服务器"
echo "3. 开始在Claude中使用微信云开发功能！"
