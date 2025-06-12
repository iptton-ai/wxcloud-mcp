#!/bin/bash

# wxcloud-mcp 快速安装脚本

echo "🚀 wxcloud-mcp 安装程序"
echo "========================="

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 需要安装 Node.js (版本 16 或更高)"
    echo "请访问 https://nodejs.org 下载安装"
    exit 1
fi

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 错误: 需要安装 npm"
    exit 1
fi

echo "✅ Node.js 和 npm 已安装"

# 检查微信云开发 CLI
if ! command -v wxcloud &> /dev/null; then
    echo "⚠️  微信云开发 CLI 未安装，正在安装..."
    npm install -g @wxcloud/cli
    if [ $? -ne 0 ]; then
        echo "❌ 微信云开发 CLI 安装失败"
        exit 1
    fi
    echo "✅ 微信云开发 CLI 安装成功"
else
    echo "✅ 微信云开发 CLI 已安装"
fi

# 构建项目
echo "🔨 构建 wxcloud-mcp..."
npm install
npm run build

if [ $? -ne 0 ]; then
    echo "❌ 构建失败"
    exit 1
fi

echo "✅ 构建成功"

# 创建全局链接
echo "🔗 创建全局链接..."
npm link

if [ $? -ne 0 ]; then
    echo "❌ 全局链接创建失败，请手动运行: npm link"
    exit 1
fi

echo "✅ 安装完成！"
echo ""
echo "📖 使用说明:"
echo "1. 登录微信云开发: wxcloud login"
echo "2. 启动 MCP 服务器: wxcloud-mcp"
echo "3. 在 Claude Desktop 中配置 MCP 服务器"
echo ""
echo "📄 详细使用说明请查看 USAGE.md"
echo "🚀 部署说明请查看 DEPLOYMENT_GUIDE.md"
