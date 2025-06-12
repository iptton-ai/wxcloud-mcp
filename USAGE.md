# 使用示例

## 先决条件

1. 安装微信云开发CLI：
```bash
npm install -g @wxcloud/cli
```

2. 登录微信云开发：
```bash
wxcloud login
```

## 在Claude Desktop中配置

在 `~/Library/Application Support/Claude/claude_desktop_config.json` 中添加：

```json
{
  "mcpServers": {
    "wxcloud": {
      "command": "npx",
      "args": ["wxcloud-mcp"]
    }
  }
}
```

## 支持的操作

### 1. 查看服务列表
询问Claude：
> 帮我查看微信云托管的服务列表

### 2. 创建新服务
询问Claude：
> 在环境ID为 env-xxx 中创建一个名为 my-service 的云托管服务

### 3. 部署应用
询问Claude：
> 将当前应用部署到微信云托管的 my-service 服务

### 4. 上传云函数
询问Claude：
> 将 ./functions/hello 目录上传为云函数

### 5. 管理文件存储
询问Claude：
> 上传本地文件 ./image.jpg 到云存储的 images/avatar.jpg 路径

## 命令行使用

也可以直接在命令行中使用：

```bash
# 启动MCP服务器
wxcloud-mcp

# 或者通过npx使用
npx wxcloud-mcp
```
