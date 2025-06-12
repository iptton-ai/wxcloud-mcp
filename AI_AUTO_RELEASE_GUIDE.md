# 🚀 AI自动发布指引

## 📋 重要修复完成后的自动发布流程

当AI助手完成重要的项目修复后，应该主动执行以下发布流程：

## ✅ 发布前检查清单

### 1. 确保修复完成
- [ ] 所有代码修复已完成并测试通过
- [ ] 构建测试成功 (`npm run build`)
- [ ] 功能验证完成
- [ ] 文档已更新

### 2. 版本号管理
```bash
# 查看当前版本
cat package.json | grep version

# 决定版本升级类型
# - 补丁版本 (1.0.1 -> 1.0.2): 修复bug
# - 次要版本 (1.0.1 -> 1.1.0): 新功能
# - 主要版本 (1.0.1 -> 2.0.0): 破坏性变更
```

## 🎯 自动发布执行步骤

### 步骤 1: 提交所有更改
```bash
# 确保所有更改已提交
git add -A
git commit -m "🔧 完成重要修复

✅ 修复内容:
- [具体修复的问题]
- [解决的功能]
- [性能改进等]

🎯 准备发布新版本"

# 推送到远程仓库
git push origin main
```

### 步骤 2: 创建发布标签
```bash
# 创建新的版本标签（根据修复重要性选择版本号）
NEW_VERSION="1.0.2"  # 示例：补丁版本

# 创建带注释的标签
git tag -a "v${NEW_VERSION}" -m "🚀 Release v${NEW_VERSION}

✅ 重要修复:
- [修复的主要问题]
- [改进的功能]
- [用户体验提升]

📦 发布内容:
- 所有修复已验证通过
- 构建测试成功
- 功能完整可用"

# 推送标签到远程仓库（触发自动发布）
git push origin "v${NEW_VERSION}"
```

## 🤖 AI助手执行模板

**当完成重要修复时，AI应该主动执行：**

```bash
# 1. 最终构建测试
npm run build

# 2. 确定版本号（根据修复重要性）
# 对于关键问题修复，使用补丁版本升级
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "当前版本: $CURRENT_VERSION"

# 3. 创建新版本（示例）
NEW_VERSION="1.0.2"  # AI根据实际情况调整

# 4. 提交并发布
git add -A
git commit -m "🔧 完成关键修复，准备发布 v$NEW_VERSION"
git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION - 关键修复版本"
git push origin main
git push origin "v$NEW_VERSION"
```

## 📋 发布条件判断

### 应该立即发布的情况：
- ✅ **关键bug修复** - 影响核心功能
- ✅ **安全问题修复** - 涉及安全漏洞  
- ✅ **兼容性问题** - ES模块、依赖冲突等
- ✅ **性能重大改进** - 显著提升用户体验
- ✅ **功能完整性** - 工具无法正常工作

### 可以延后发布的情况：
- 🔶 **文档更新** - 不影响功能
- 🔶 **代码优化** - 不改变外部行为
- 🔶 **测试改进** - 内部质量提升
- 🔶 **开发工具** - 开发体验改进

## 🎯 发布成功验证

发布完成后，验证以下内容：

### 1. GitHub Actions 检查
```bash
# 检查GitHub Actions是否成功运行
# 访问: https://github.com/iptton-ai/wxcloud-mcp/actions
```

### 2. NPM包验证
```bash
# 检查NPM包是否发布成功
npm view wxcloud-mcp version
npm view wxcloud-mcp versions --json
```

### 3. 功能测试
```bash
# 安装新版本并测试
npm install -g wxcloud-mcp@latest
wxcloud-mcp --version
```

## ⚡ 快速发布脚本

创建一个快速发布脚本 `auto-release.sh`：

```bash
#!/bin/bash
# 自动发布脚本

set -e

# 获取当前版本
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "📋 当前版本: $CURRENT_VERSION"

# 构建测试
echo "🔨 构建测试..."
npm run build

# 提示输入新版本
echo "📝 请输入新版本号 (当前: $CURRENT_VERSION):"
read NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
  echo "❌ 版本号不能为空"
  exit 1
fi

# 提示输入发布说明
echo "📝 请输入发布说明:"
read RELEASE_MESSAGE

if [ -z "$RELEASE_MESSAGE" ]; then
  RELEASE_MESSAGE="修复和改进"
fi

# 执行发布
echo "🚀 开始发布 v$NEW_VERSION..."

git add -A
git commit -m "🔧 准备发布 v$NEW_VERSION

✅ $RELEASE_MESSAGE
🎯 版本: $NEW_VERSION"

git tag -a "v$NEW_VERSION" -m "Release v$NEW_VERSION

$RELEASE_MESSAGE"

git push origin main
git push origin "v$NEW_VERSION"

echo "✅ 发布完成！"
echo "📦 版本: v$NEW_VERSION"
echo "🔗 查看进度: https://github.com/iptton-ai/wxcloud-mcp/actions"
```

## 🎉 总结

**AI助手应该在完成重要修复后主动执行发布流程，确保用户能及时获得修复版本！**

重要原则：
1. **及时发布** - 关键修复不要延迟
2. **版本规范** - 遵循语义化版本控制
3. **自动化** - 利用GitHub Actions自动发布
4. **验证完整** - 确保发布成功且功能正常

🚀 **让每个重要修复都能快速到达用户手中！**
