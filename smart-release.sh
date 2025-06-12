#!/bin/bash

# 智能版本发布脚本
echo "🚀 wxcloud-mcp 智能版本发布"
echo "=========================="

if [ $# -eq 0 ]; then
    echo "❌ 请提供版本号"
    echo "用法: $0 <版本号>"
    echo "例如: $0 1.0.3"
    exit 1
fi

NEW_VERSION=$1
echo "准备发布版本: $NEW_VERSION"

# 验证版本号格式
if [[ ! $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ 版本号格式无效: $NEW_VERSION"
    echo "请使用语义化版本号格式，例如: 1.0.3"
    exit 1
fi

# 检查Git状态
echo "检查Git状态..."
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "❌ 工作区有未提交的更改，请先提交"
    git status --short
    exit 1
fi

# 检查标签是否存在
if git tag -l | grep -q "^v$NEW_VERSION$"; then
    echo "❌ 标签 v$NEW_VERSION 已存在"
    exit 1
fi

# 确认发布
echo "准备创建标签 v$NEW_VERSION 并触发发布"
read -p "确认继续? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 发布已取消"
    exit 1
fi

# 创建并推送标签
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"
git push origin "v$NEW_VERSION"

echo "✅ 标签已创建并推送"
echo "🎉 发布流程已启动！"
echo "📊 查看进度: https://github.com/iptton-ai/wxcloud-mcp/actions"
