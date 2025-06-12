#!/bin/bash

# 智能版本发布脚本
# 用法: ./smart-release.sh [版本号]
# 例如: ./smart-release.sh 1.0.3

set -e

echo "🚀 wxcloud-mcp 智能版本发布"
echo "=========================="

# 检查参数
if [ $# -eq 0 ]; then
    echo "❌ 请提供版本号"
    echo "用法: $0 <版本号>"
    echo "例如: $0 1.0.3"
    exit 1
fi

NEW_VERSION=$1

# 验证版本号格式
if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ 版本号格式无效: $NEW_VERSION"
    echo "请使用语义化版本号格式，例如: 1.0.3"
    exit 1
fi

# 检查Git状态
echo "1. 检查Git状态..."
if ! git diff --quiet; then
    echo "❌ 工作区有未提交的更改，请先提交或暂存"
    git status --short
    exit 1
fi

if ! git diff --cached --quiet; then
    echo "❌ 暂存区有未提交的更改，请先提交"
    git status --short
    exit 1
fi

echo "✅ 工作区干净"

# 获取当前版本
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "当前版本: $CURRENT_VERSION"
echo "新版本: $NEW_VERSION"

# 检查版本是否已存在
if git tag -l | grep -q "^v$NEW_VERSION$"; then
    echo "❌ 标签 v$NEW_VERSION 已存在"
    echo "现有标签:"
    git tag -l | grep "^v" | sort -V | tail -5
    exit 1
fi

# 检查NPM上是否已存在此版本
echo ""
echo "2. 检查NPM版本..."
if npm view wxcloud-mcp@$NEW_VERSION > /dev/null 2>&1; then
    echo "❌ 版本 $NEW_VERSION 已在NPM上发布"
    echo "NPM上的版本:"
    npm view wxcloud-mcp version
    exit 1
fi

echo "✅ 版本号可用"

# 确认发布
echo ""
echo "3. 发布确认..."
echo "准备发布版本: $NEW_VERSION"
echo "这将会:"
echo "  - 创建Git标签 v$NEW_VERSION"
echo "  - 推送到GitHub"
echo "  - 触发自动发布到NPM"
echo "  - 创建GitHub Release"
echo ""

read -p "确认发布? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 发布已取消"
    exit 1
fi

# 创建标签
echo ""
echo "4. 创建Git标签..."
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION

- 版本: $NEW_VERSION
- 日期: $(date)
- 提交: $(git rev-parse --short HEAD)

自动化发布到NPM和GitHub Release"

echo "✅ 标签 v$NEW_VERSION 已创建"

# 推送标签
echo ""
echo "5. 推送到GitHub..."
git push origin "v$NEW_VERSION"

echo "✅ 标签已推送到GitHub"

# 提供监控链接
echo ""
echo "🎉 发布流程已启动!"
echo ""
echo "📊 监控发布进度:"
echo "  GitHub Actions: https://github.com/iptton-ai/wxcloud-mcp/actions"
echo "  NPM包页面: https://www.npmjs.com/package/wxcloud-mcp"
echo ""
echo "⏱️  预计5-10分钟内完成发布"
echo ""
echo "🔍 如果发布失败，请检查:"
echo "  1. NPM_TOKEN是否在GitHub Secrets中正确设置"
echo "  2. GitHub Actions工作流程日志"
echo "  3. NPM权限是否正确"

echo ""
echo "✨ 发布脚本完成!"
