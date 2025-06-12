# GitHub Actions 设置指南

本项目包含三个GitHub Actions工作流程：

## 1. CI工作流程 (`.github/workflows/ci.yml`)

**触发条件：**
- 推送到 `main` 或 `develop` 分支
- 针对 `main` 分支的 Pull Request

**功能：**
- 在多个Node.js版本（16, 18, 20）上测试
- 代码检查和构建验证
- 安装测试

## 2. 发布工作流程 (`.github/workflows/publish.yml`)

**触发条件：**
- 推送标签（格式：`v*`，如 `v1.0.1`）
- 手动触发

**功能：**
- 自动构建和发布到NPM

## 3. 版本发布工作流程 (`.github/workflows/release.yml`)

**触发条件：**
- 手动触发，可选择版本类型（patch, minor, major）

**功能：**
- 自动版本号升级
- 创建Git标签和GitHub Release
- 发布到NPM

## 设置说明

### 必需的GitHub Secrets

在GitHub仓库的Settings > Secrets and variables > Actions中添加：

1. **NPM_TOKEN**
   - 在 https://www.npmjs.com/settings/tokens 创建访问令牌
   - 类型选择 "Automation"
   - 复制令牌并添加到GitHub Secrets

### 使用方法

#### 自动发布（推荐）
1. 使用Release工作流程：
   - 在GitHub仓库中点击 "Actions"
   - 选择 "Release" 工作流程
   - 点击 "Run workflow"
   - 选择版本类型（patch/minor/major）
   - 点击运行

#### 手动发布
1. 本地创建标签：
   ```bash
   git tag v1.0.2
   git push origin v1.0.2
   ```

2. 这将自动触发发布工作流程

### 工作流程状态

所有工作流程都会在GitHub Actions页面显示状态。可以通过以下方式查看：
- 访问 `https://github.com/你的用户名/wxcloud-mcp/actions`
- 点击具体的工作流程查看详细日志

### 注意事项

1. 确保在发布前测试通过
2. 版本号遵循语义化版本控制
3. NPM_TOKEN需要定期更新
4. 发布前检查package.json中的版本号

## 疑难解答

### 发布失败
1. 检查NPM_TOKEN是否有效
2. 确认包名在NPM上可用
3. 检查网络连接

### 构建失败
1. 检查TypeScript配置
2. 确认所有依赖都已安装
3. 验证代码语法正确

### 权限问题
1. 确认GitHub Token有足够权限
2. 检查仓库设置中的Actions权限
