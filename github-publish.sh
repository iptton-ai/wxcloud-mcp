#!/bin/bash

# GitHub 仓库创建助手脚本

echo "🚀 wxcloud-mcp GitHub 发布助手"
echo "=================================="

echo "📋 请按照以下步骤创建GitHub仓库："
echo ""
echo "1️⃣  打开浏览器，访问："
echo "    👉 https://github.com/iptton-ai"
echo ""
echo "2️⃣  点击 'New repository' 按钮"
echo ""
echo "3️⃣  填写仓库信息："
echo "    📝 Repository name: wxcloud-mcp"
echo "    📝 Description: A Model Context Protocol (MCP) server for WeChat Cloud CLI"
echo "    🌍 选择 Public"
echo "    ❌ 不要勾选 Initialize this repository with:"
echo ""
echo "4️⃣  点击 'Create repository'"
echo ""

# 等待用户确认
read -p "✅ 仓库创建完成后，按 Enter 继续推送代码..." 

echo ""
echo "📤 正在推送代码到GitHub..."

# 推送代码
if git push -u origin main; then
    echo ""
    echo "🎉 代码推送成功！"
    echo ""
    echo "📖 你的项目现在可以在这里访问："
    echo "👉 https://github.com/iptton-ai/wxcloud-mcp"
    echo ""
    echo "🔧 用户现在可以通过以下方式安装："
    echo "📦 npm install -g github:iptton-ai/wxcloud-mcp"
    echo ""
    echo "📱 或者克隆并构建："
    echo "📥 git clone https://github.com/iptton-ai/wxcloud-mcp.git"
    echo ""
    echo "🌟 建议下一步："
    echo "1. 在GitHub仓库中创建Release (v1.0.0)"
    echo "2. 添加Topics标签: mcp, model-context-protocol, wxcloud"
    echo "3. 分享到开发者社区！"
    echo ""
    echo "🎊 恭喜！wxcloud-mcp 项目发布成功！"
else
    echo ""
    echo "❌ 推送失败，请检查："
    echo "1. GitHub仓库是否创建成功"
    echo "2. 网络连接是否正常"
    echo "3. Git配置是否正确"
    echo ""
    echo "💡 可以手动运行: git push -u origin main"
fi
