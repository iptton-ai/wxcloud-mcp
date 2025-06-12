# NPM Token 设置指南

## 🔑 创建NPM访问令牌

### 步骤1: 登录NPM
1. 访问 https://www.npmjs.com/
2. 登录你的NPM账户

### 步骤2: 创建访问令牌
1. 点击头像 → **Access Tokens**
2. 点击 **Generate New Token**
3. 选择 **Automation** 类型（推荐）或 **Publish**
4. 输入令牌名称，如 `wxcloud-mcp-github-actions`
5. 点击 **Generate Token**
6. **⚠️ 重要：立即复制令牌，关闭页面后将无法再次查看**

### 步骤3: 添加GitHub Secret

1. 访问你的GitHub仓库: https://github.com/iptton-ai/wxcloud-mcp
2. 点击 **Settings** 标签
3. 在左侧菜单中点击 **Secrets and variables** → **Actions**
4. 点击 **New repository secret**
5. 设置：
   - **Name**: `NPM_TOKEN`
   - **Value**: 粘贴刚才复制的NPM令牌
6. 点击 **Add secret**

## 🧪 测试设置

设置完成后，你可以通过以下方式测试：

### 方法1: 手动触发工作流程
1. 在GitHub仓库中点击 **Actions** 标签
2. 选择 **Publish to NPM** 工作流程
3. 点击 **Run workflow**
4. 选择分支并点击 **Run workflow**

### 方法2: 创建新标签
```bash
# 本地创建并推送标签
git tag v1.0.2
git push origin v1.0.2
```

## 📋 检查清单

- [ ] NPM账户已登录
- [ ] 创建了Automation类型的访问令牌
- [ ] 令牌已复制保存
- [ ] 在GitHub仓库中添加了NPM_TOKEN密钥
- [ ] 密钥名称正确为 `NPM_TOKEN`
- [ ] 工作流程文件已更新

## 🔍 常见问题

### Q: 我忘记了NPM用户名/密码怎么办？
A: 可以在NPM网站使用"忘记密码"功能重置，或者使用命令行 `npm login` 重新登录

### Q: 令牌创建后找不到了？
A: NPM令牌只能在创建时查看一次，如果丢失需要删除旧令牌并创建新的

### Q: 工作流程仍然失败怎么办？
A: 检查以下几点：
1. NPM_TOKEN密钥是否正确设置
2. NPM令牌是否有发布权限
3. 包名是否已存在且你有权限发布
4. 检查工作流程日志获取详细错误信息

### Q: 如何验证令牌是否有效？
A: 可以在本地使用以下命令测试：
```bash
echo "//registry.npmjs.org/:_authToken=YOUR_TOKEN" > ~/.npmrc
npm whoami
```

## 🔐 安全注意事项

1. **永远不要在代码中硬编码NPM令牌**
2. **定期轮换访问令牌**
3. **为不同项目使用不同的令牌**
4. **及时删除不再使用的令牌**
5. **监控NPM下载统计，发现异常及时处理**

## 🚀 成功后的效果

设置成功后，每当你推送一个新的版本标签（如 `v1.0.2`），GitHub Actions将：

1. ✅ 自动检出代码
2. ✅ 安装依赖并构建项目
3. ✅ 验证NPM认证
4. ✅ 发布到NPM
5. ✅ 创建GitHub Release

你将在Actions页面看到绿色的成功标记，并且新版本会出现在NPM上！
