# 🔧 NPM发布认证问题解决方案

## 问题描述
GitHub Actions在执行自动发布时出现错误：
```
npm error need auth You need to authorize this machine using `npm adduser`
```

## 🎯 解决方案

### 1. 根本原因
GitHub Actions缺少NPM认证令牌，无法向NPM发布包。

### 2. 修复措施

#### A. 改进了GitHub Actions工作流程
- ✅ 添加NPM Token验证步骤
- ✅ 增加认证状态检查
- ✅ 改进错误处理和调试信息
- ✅ 添加自动创建GitHub Release

#### B. 创建了设置指南
- 📋 `NPM_TOKEN_SETUP.md` - 详细的NPM Token创建和设置步骤
- 🔍 `npm-token-verify.sh` - 自动验证脚本

## 📋 必需的设置步骤

### 第1步: 创建NPM访问令牌
1. 登录 https://www.npmjs.com/
2. 头像 → **Access Tokens** → **Generate New Token**
3. 选择 **Automation** 类型
4. 复制生成的令牌

### 第2步: 在GitHub添加Secret
1. 访问: https://github.com/iptton-ai/wxcloud-mcp/settings/secrets/actions
2. 点击 **New repository secret**
3. Name: `NPM_TOKEN`
4. Value: 粘贴NPM令牌
5. 点击 **Add secret**

### 第3步: 验证设置
运行验证脚本：
```bash
cd /Users/zxnap/code/MyWorks/wxcloud-mcp
./npm-token-verify.sh
```

## 🚀 测试发布

设置完成后，可以通过以下方式测试：

### 方法1: 手动触发
1. GitHub仓库 → **Actions** → **Publish to NPM**
2. 点击 **Run workflow**

### 方法2: 创建版本标签
```bash
# 更新版本
npm version patch  # 或 minor, major

# 推送标签触发自动发布
git push origin v新版本号
```

## 🔍 改进的工作流程特性

新的发布工作流程包含：

1. **Token验证**: 在发布前检查NPM_TOKEN是否存在
2. **认证检查**: 使用 `npm whoami` 验证认证状态
3. **详细日志**: 提供清晰的错误信息和调试输出
4. **自动Release**: 发布成功后自动创建GitHub Release
5. **错误处理**: 在关键步骤失败时提供有用的提示

## 📊 检查清单

完成设置后，确认以下各项：

- [ ] 在NPM创建了Automation类型的访问令牌
- [ ] 在GitHub仓库Secrets中添加了NPM_TOKEN
- [ ] 运行了验证脚本确认设置正确
- [ ] 工作流程文件已更新并推送
- [ ] 可以正常触发发布流程

## 🎉 成功标志

设置正确后，你会看到：

1. **GitHub Actions日志**:
   ```
   ✅ NPM_TOKEN is available
   ✅ npm whoami: iptton
   ✅ Publishing package to NPM...
   ```

2. **NPM发布成功**:
   ```
   + wxcloud-mcp@1.0.x
   ```

3. **自动创建GitHub Release**

## 🔐 安全注意事项

- 🚫 **永远不要**在代码中硬编码NPM令牌
- 🔄 **定期轮换**访问令牌（建议每6个月）
- 👀 **监控**NPM下载统计，发现异常及时处理
- 🗑️ **及时删除**不再使用的令牌

## 💡 故障排除

如果仍然遇到问题：

1. **检查令牌权限**: 确保NPM令牌有发布权限
2. **验证包名**: 确认包名在NPM上可用且你有权限
3. **查看Actions日志**: GitHub Actions提供详细的错误信息
4. **本地测试**: 使用 `npm publish --dry-run` 测试

---

**现在你的自动发布流程应该能正常工作了！** 🎯
