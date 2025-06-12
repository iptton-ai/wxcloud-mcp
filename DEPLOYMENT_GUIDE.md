# GitHub 仓库创建说明

由于系统中未安装GitHub CLI，请按以下步骤手动创建GitHub仓库：

## 步骤 1: 在GitHub上创建仓库

1. 访问 https://github.com/iptton-ai
2. 点击 "New repository" 按钮
3. 设置仓库名称为: `wxcloud-mcp`
4. 添加描述: "A Model Context Protocol (MCP) server for WeChat Cloud CLI"
5. 选择 "Public" (如果希望开源)
6. **不要**初始化README、.gitignore或license (因为我们已经有了)
7. 点击 "Create repository"

## 步骤 2: 推送代码到GitHub

创建仓库后，在本地项目目录运行以下命令：

```bash
cd /Users/zxnap/code/MyWorks/wxcloud-mcp

# 添加远程仓库
git remote add origin https://github.com/iptton-ai/wxcloud-mcp.git

# 推送代码
git branch -M main
git push -u origin main
```

## 步骤 3: 发布到npm (可选)

如果要发布到npm，请运行：

```bash
# 登录npm
npm login

# 发布包
npm publish
```

## 完成后的使用方法

仓库创建后，用户可以通过以下方式安装和使用：

```bash
# 从npm安装 (如果已发布)
npm install -g wxcloud-mcp

# 或从GitHub直接安装
npm install -g github:iptton-ai/wxcloud-mcp

# 或克隆并本地构建
git clone https://github.com/iptton-ai/wxcloud-mcp.git
cd wxcloud-mcp
npm install
npm run build
npm link
```
