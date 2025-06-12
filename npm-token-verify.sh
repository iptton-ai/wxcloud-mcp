#!/bin/bash

# NPM Token 验证脚本

echo "🔍 NPM Token 设置验证"
echo "========================"

# 检查本地NPM认证
echo "1. 检查本地NPM认证状态..."
if npm whoami > /dev/null 2>&1; then
    echo "✅ 本地NPM已认证，用户: $(npm whoami)"
else
    echo "❌ 本地NPM未认证"
    echo "💡 请运行: npm login"
fi

echo ""

# 检查包信息
echo "2. 检查包信息..."
if [ -f package.json ]; then
    PACKAGE_NAME=$(cat package.json | grep '"name"' | cut -d'"' -f4)
    PACKAGE_VERSION=$(cat package.json | grep '"version"' | cut -d'"' -f4)
    echo "✅ 包名: $PACKAGE_NAME"
    echo "✅ 当前版本: $PACKAGE_VERSION"
else
    echo "❌ 未找到 package.json"
    exit 1
fi

echo ""

# 检查NPM上的包状态
echo "3. 检查NPM上的包状态..."
if npm view $PACKAGE_NAME > /dev/null 2>&1; then
    PUBLISHED_VERSION=$(npm view $PACKAGE_NAME version)
    echo "✅ 包已发布在NPM上"
    echo "📦 NPM上的版本: $PUBLISHED_VERSION"
    echo "📦 本地版本: $PACKAGE_VERSION"
    
    if [ "$PACKAGE_VERSION" = "$PUBLISHED_VERSION" ]; then
        echo "⚠️  版本相同，发布前请更新版本号"
    else
        echo "✅ 版本不同，可以发布"
    fi
else
    echo "📦 包尚未发布到NPM或包名不存在"
fi

echo ""

# 检查GitHub工作流程文件
echo "4. 检查GitHub工作流程..."
if [ -f .github/workflows/publish.yml ]; then
    echo "✅ 发布工作流程文件存在"
    if grep -q "NPM_TOKEN" .github/workflows/publish.yml; then
        echo "✅ 工作流程配置了NPM_TOKEN"
    else
        echo "❌ 工作流程未配置NPM_TOKEN"
    fi
else
    echo "❌ 未找到发布工作流程文件"
fi

echo ""

# GitHub设置提醒
echo "5. GitHub设置检查..."
echo "📋 请确认以下设置已完成:"
echo "   □ 在NPM创建了访问令牌"
echo "   □ 在GitHub仓库添加了NPM_TOKEN密钥"
echo "   □ 令牌类型为 Automation 或 Publish"
echo ""

echo "🔗 GitHub Secrets 设置链接:"
echo "   https://github.com/iptton-ai/wxcloud-mcp/settings/secrets/actions"

echo ""
echo "✨ 验证完成！"

# 提供下一步操作建议
echo ""
echo "📝 下一步操作:"
if [ "$PACKAGE_VERSION" = "$PUBLISHED_VERSION" ]; then
    echo "1. 更新版本号: npm version patch|minor|major"
    echo "2. 推送标签: git push origin v新版本号"
else
    echo "1. 创建并推送标签: git tag v$PACKAGE_VERSION && git push origin v$PACKAGE_VERSION"
    echo "2. 或者手动触发GitHub Actions工作流程"
fi
