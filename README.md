# wxcloud-mcp

一个基于微信云开发CLI的模型上下文协议(MCP)服务器，让AI助手能够通过MCP协议直接操作微信云开发服务。

## 功能特性

- 🚀 **服务管理**: 创建、查看、配置、删除微信云托管服务
- 📦 **部署操作**: 智能部署应用到微信云托管
- ⚡ **云函数**: 上传和管理云函数
- 🔧 **环境管理**: 管理云开发环境
- 📊 **存储操作**: 文件存储管理
- 🔐 **认证集成**: 安全的CLI密钥认证

## 安装

### 方法1: 从npm安装（推荐）

```bash
npm install -g wxcloud-mcp
```

### 方法2: 从GitHub安装

```bash
npm install -g github:iptton-ai/wxcloud-mcp
```

### 方法3: 克隆并构建

```bash
git clone https://github.com/iptton-ai/wxcloud-mcp.git
cd wxcloud-mcp
./install.sh
```

## 配置

在使用前，请确保已安装微信云开发CLI：

```bash
npm install -g @wxcloud/cli
```

并完成登录：

```bash
wxcloud login
```

## 使用方法

### 作为MCP服务器启动

```bash
wxcloud-mcp
```

### 支持的MCP工具

#### 服务管理
- `wxcloud_service_list` - 查看服务列表
- `wxcloud_service_create` - 创建新服务
- `wxcloud_service_config` - 查看/更新服务配置
- `wxcloud_service_remove` - 删除服务

#### 部署操作
- `wxcloud_deploy` - 部署应用

#### 云函数
- `wxcloud_function_upload` - 上传云函数

#### 环境管理
- `wxcloud_env_list` - 查看环境列表

#### 存储管理
- `wxcloud_storage_upload` - 上传文件
- `wxcloud_storage_download` - 下载文件

## MCP客户端配置

在Claude Desktop等MCP客户端中配置：

```json
{
  "mcpServers": {
    "wxcloud": {
      "command": "wxcloud-mcp"
    }
  }
}
```

## 许可证

MIT

## 贡献

欢迎提交Issue和Pull Request！

## 相关链接

- [微信云开发CLI文档](https://cloud.weixin.qq.com/cli/guide.html)
- [Model Context Protocol](https://github.com/anthropics/mcp)
- [微信云托管](https://cloud.weixin.qq.com/cloudrun)
