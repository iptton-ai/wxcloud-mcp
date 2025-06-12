#!/bin/bash

# npm 发布脚本

echo "📦 wxcloud-mcp npm 发布助手"
echo "=============================="

# 检查构建状态
echo "🔨 检查构建状态..."
if [ ! -f "dist/index.js" ]; then
    echo "❌ 构建文件不存在，正在构建..."
    npm run build
    if [ $? -ne 0 ]; then
        echo "❌ 构建失败！"
        exit 1
    fi
fi
echo "✅ 构建文件存在"

# 检查npm登录状态
echo "👤 检查npm登录状态..."
if ! npm whoami > /dev/null 2>&1; then
    echo "❌ 未登录npm，请先运行: npm login"
    exit 1
fi
echo "✅ 已登录npm，用户: $(npm whoami)"

# 检查包名可用性
echo "🔍 检查包名可用性..."
if npm view wxcloud-mcp > /dev/null 2>&1; then
    echo "⚠️  包名已存在，检查版本..."
    CURRENT_VERSION=$(npm view wxcloud-mcp version 2>/dev/null)
    LOCAL_VERSION=$(node -p "require('./package.json').version")
    echo "📦 远程版本: $CURRENT_VERSION"
    echo "📦 本地版本: $LOCAL_VERSION"
    
    if [ "$CURRENT_VERSION" = "$LOCAL_VERSION" ]; then
        echo "❌ 版本冲突！请更新package.json中的版本号"
        echo "💡 建议运行: npm version patch"
        exit 1
    fi
else
    echo "✅ 包名可用"
fi

# 运行测试（如果存在）
echo "🧪 运行基本验证..."
if node dist/index.js --version > /dev/null 2>&1; then
    echo "✅ 可执行文件验证通过"
else
    echo "❌ 可执行文件验证失败"
    exit 1
fi

# 显示将要发布的内容
echo "📋 发布内容预览:"
npm pack --dry-run | grep -E "📦|Tarball Contents" -A 20

echo ""
echo "🚀 准备发布到npm..."
echo "包名: wxcloud-mcp"
echo "版本: $(node -p "require('./package.json').version")"
echo "作者: $(node -p "require('./package.json').author")"
echo ""

# 确认发布
read -p "❓ 确认发布到npm？(y/N): " confirm
if [[ $confirm =~ ^[Yy]$ ]]; then
    echo ""
    echo "🚀 正在发布..."
    
    if npm publish; then
        echo ""
        echo "🎉 发布成功！"
        echo ""
        echo "📦 你的包现在可以通过以下方式安装："
        echo "👉 npm install -g wxcloud-mcp"
        echo ""
        echo "🔗 npm包页面:"
        echo "👉 https://www.npmjs.com/package/wxcloud-mcp"
        echo ""
        echo "📊 验证安装:"
        echo "👉 npm info wxcloud-mcp"
        echo ""
        echo "🌟 下一步建议:"
        echo "1. 更新GitHub仓库的README，添加npm安装说明"
        echo "2. 创建GitHub Release"
        echo "3. 分享到开发者社区"
        echo ""
        echo "🎊 恭喜！wxcloud-mcp已成功发布到npm！"
    else
        echo ""
        echo "❌ 发布失败！"
        echo "💡 常见问题:"
        echo "1. 网络连接问题"
        echo "2. 权限问题"
        echo "3. 版本冲突"
        echo ""
        echo "🔧 可以重新运行此脚本或手动执行: npm publish"
    fi
else
    echo "❌ 发布已取消"
fi
