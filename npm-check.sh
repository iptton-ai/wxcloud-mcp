#!/bin/bash

# npm 发布准备检查脚本

echo "📦 检查npm发布准备状态..."
echo "================================="

# 检查是否已构建
if [ -d "dist" ] && [ -f "dist/index.js" ]; then
    echo "✅ 构建文件已生成"
else
    echo "❌ 构建文件缺失，请运行: npm run build"
    exit 1
fi

# 检查package.json关键字段
echo "📋 检查package.json配置..."

if grep -q '"name": "wxcloud-mcp"' package.json; then
    echo "✅ 包名配置正确"
else
    echo "❌ 包名配置错误"
fi

if grep -q '"version": "1.0.0"' package.json; then
    echo "✅ 版本号配置正确"
else
    echo "❌ 版本号配置错误"
fi

if grep -q '"bin":' package.json; then
    echo "✅ 可执行文件配置正确"
else
    echo "❌ 可执行文件配置缺失"
fi

# 检查必要文件
echo "📋 检查必要文件..."

required_files=("README.md" "LICENSE" "USAGE.md" "dist/index.js")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 缺失"
    fi
done

# 测试可执行文件
echo "📋 测试可执行文件..."
if node dist/index.js --version > /dev/null 2>&1; then
    echo "✅ 可执行文件运行正常"
else
    echo "❌ 可执行文件运行失败"
fi

# 检查npm登录状态
echo "📋 检查npm登录状态..."
if npm whoami > /dev/null 2>&1; then
    echo "✅ 已登录npm，用户: $(npm whoami)"
else
    echo "⚠️  未登录npm，发布前请运行: npm login"
fi

# 预览发布内容
echo "📋 预览发布内容..."
echo "以下文件将被发布到npm："
npm pack --dry-run 2>/dev/null | grep -E '^\s+[0-9]+' | head -10

echo ""
echo "🚀 准备状态检查完成！"
echo ""
echo "📖 发布步骤："
echo "1. 确保GitHub仓库已创建"
echo "2. 推送代码: git push -u origin main"
echo "3. 登录npm: npm login"
echo "4. 发布包: npm publish"
echo "5. 验证: npm info wxcloud-mcp"
