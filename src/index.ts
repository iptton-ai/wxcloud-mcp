#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool
} from '@modelcontextprotocol/sdk/types.js';
import { exec } from 'child_process';
import { promisify } from 'util';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

// 获取当前文件的目录路径（ES模块兼容）
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const execAsync = promisify(exec);

// 处理命令行参数
function handleCommandLineArgs() {
  const args = process.argv.slice(2);
  
  if (args.includes('--help') || args.includes('-h')) {
    console.log(`
wxcloud-mcp v1.0.1 - 微信云开发CLI的MCP服务器

用法:
  wxcloud-mcp              启动MCP服务器
  wxcloud-mcp --help       显示此帮助信息
  wxcloud-mcp --version    显示版本信息

功能:
  通过Model Context Protocol (MCP) 为AI助手提供微信云开发CLI操作能力

支持的操作:
  • 服务管理 (创建、查看、配置、删除)
  • 应用部署
  • 云函数上传
  • 环境管理
  • 文件存储操作

配置说明:
  在Claude Desktop等MCP客户端中添加以下配置:
  {
    "mcpServers": {
      "wxcloud": {
        "command": "wxcloud-mcp"
      }
    }
  }

前置要求:
  1. 安装微信云开发CLI: npm install -g @wxcloud/cli
  2. 完成登录: wxcloud login

更多信息:
  https://github.com/iptton-ai/wxcloud-mcp
`);
    process.exit(0);
  }
  
  if (args.includes('--version') || args.includes('-v')) {
    console.log('wxcloud-mcp v1.0.1');
    process.exit(0);
  }
}

// 在启动前处理命令行参数
handleCommandLineArgs();

class WxCloudMCPServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'wxcloud-mcp',
        version: '1.0.0',
      }
    );

    this.setupToolHandlers();
    this.setupErrorHandling();
  }

  private setupErrorHandling(): void {
    this.server.onerror = (error) => {
      console.error('[MCP Error]', error);
    };

    process.on('SIGINT', async () => {
      await this.server.close();
      process.exit(0);
    });
  }

  private setupToolHandlers(): void {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      return {
        tools: [
          {
            name: 'wxcloud_service_list',
            description: '查看微信云托管服务列表',
            inputSchema: {
              type: 'object',
              properties: {
                envId: {
                  type: 'string',
                  description: '环境ID（必需，使用 wxcloud_env_list 获取）'
                },
                serviceName: {
                  type: 'string',
                  description: '服务名称（可选）'
                }
              },
              required: ['envId']
            }
          },
          {
            name: 'wxcloud_service_create',
            description: '创建新的微信云托管服务',
            inputSchema: {
              type: 'object',
              properties: {
                serviceName: {
                  type: 'string',
                  description: '服务名称'
                },
                envId: {
                  type: 'string',
                  description: '环境ID'
                },
                isPublic: {
                  type: 'boolean',
                  description: '是否开通外网访问',
                  default: false
                }
              },
              required: ['serviceName', 'envId']
            }
          },
          {
            name: 'wxcloud_service_config',
            description: '查看或更新服务配置',
            inputSchema: {
              type: 'object',
              properties: {
                action: {
                  type: 'string',
                  enum: ['read', 'update'],
                  description: '操作类型：read（查看）或 update（更新）',
                  default: 'read'
                },
                serviceName: {
                  type: 'string',
                  description: '服务名称'
                },
                envId: {
                  type: 'string',
                  description: '环境ID'
                },
                cpu: {
                  type: 'string',
                  description: 'CPU配置（更新时使用）'
                },
                mem: {
                  type: 'string',
                  description: '内存配置（更新时使用）'
                },
                minNum: {
                  type: 'number',
                  description: '最小实例数（更新时使用）'
                },
                maxNum: {
                  type: 'number',
                  description: '最大实例数（更新时使用）'
                },
                envParams: {
                  type: 'string',
                  description: '环境变量，格式：key1=value1&key2=value2（更新时使用）'
                }
              },
              required: ['serviceName', 'envId']
            }
          },
          {
            name: 'wxcloud_service_remove',
            description: '删除微信云托管服务',
            inputSchema: {
              type: 'object',
              properties: {
                serviceName: {
                  type: 'string',
                  description: '服务名称'
                },
                envId: {
                  type: 'string',
                  description: '环境ID'
                },
                noConfirm: {
                  type: 'boolean',
                  description: '跳过删除确认',
                  default: false
                }
              },
              required: ['serviceName', 'envId']
            }
          },
          {
            name: 'wxcloud_deploy',
            description: '部署应用到微信云托管',
            inputSchema: {
              type: 'object',
              properties: {
                envId: {
                  type: 'string',
                  description: '环境ID（必需，使用 wxcloud_env_list 获取）'
                },
                serviceName: {
                  type: 'string',
                  description: '服务名称'
                },
                port: {
                  type: 'number',
                  description: '端口号',
                  default: 3000
                },
                dryRun: {
                  type: 'boolean',
                  description: '不执行实际部署，仅预览',
                  default: false
                }
              },
              required: ['envId']
            }
          },
          {
            name: 'wxcloud_function_upload',
            description: '上传云函数',
            inputSchema: {
              type: 'object',
              properties: {
                functionPath: {
                  type: 'string',
                  description: '云函数代码目录路径'
                },
                functionName: {
                  type: 'string',
                  description: '函数名'
                },
                envId: {
                  type: 'string',
                  description: '环境ID'
                },
                remoteNpmInstall: {
                  type: 'boolean',
                  description: '是否云端安装依赖',
                  default: false
                }
              },
              required: ['functionPath', 'envId']
            }
          },
          {
            name: 'wxcloud_env_list',
            description: '查看环境列表',
            inputSchema: {
              type: 'object',
              properties: {}
            }
          },
          {
            name: 'wxcloud_storage_upload',
            description: '上传文件到云存储',
            inputSchema: {
              type: 'object',
              properties: {
                localPath: {
                  type: 'string',
                  description: '本地文件路径'
                },
                cloudPath: {
                  type: 'string',
                  description: '云端文件路径'
                },
                envId: {
                  type: 'string',
                  description: '环境ID'
                }
              },
              required: ['localPath', 'cloudPath', 'envId']
            }
          },
          {
            name: 'wxcloud_storage_download',
            description: '从云存储下载文件',
            inputSchema: {
              type: 'object',
              properties: {
                cloudPath: {
                  type: 'string',
                  description: '云端文件路径'
                },
                localPath: {
                  type: 'string',
                  description: '本地保存路径'
                },
                envId: {
                  type: 'string',
                  description: '环境ID'
                }
              },
              required: ['cloudPath', 'localPath', 'envId']
            }
          }
        ] as Tool[]
      };
    });

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        switch (name) {
          case 'wxcloud_service_list':
            return await this.handleServiceList(args);
          
          case 'wxcloud_service_create':
            return await this.handleServiceCreate(args);
          
          case 'wxcloud_service_config':
            return await this.handleServiceConfig(args);
          
          case 'wxcloud_service_remove':
            return await this.handleServiceRemove(args);
          
          case 'wxcloud_deploy':
            return await this.handleDeploy(args);
          
          case 'wxcloud_function_upload':
            return await this.handleFunctionUpload(args);
          
          case 'wxcloud_env_list':
            return await this.handleEnvList(args);
          
          case 'wxcloud_storage_upload':
            return await this.handleStorageUpload(args);
          
          case 'wxcloud_storage_download':
            return await this.handleStorageDownload(args);
          
          default:
            throw new Error(`Unknown tool: ${name}`);
        }
      } catch (error) {
        return {
          content: [
            {
              type: 'text',
              text: `Error executing ${name}: ${error instanceof Error ? error.message : String(error)}`
            }
          ]
        };
      }
    });
  }

  private async executeWxCloudCommand(command: string): Promise<{ stdout: string; stderr: string }> {
    try {
      // 添加超时控制，防止命令挂起
      const timeoutMs = 30000; // 30秒超时
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), timeoutMs);
      
      const result = await execAsync(command, {
        signal: controller.signal,
        timeout: timeoutMs
      });
      
      clearTimeout(timeoutId);
      return result;
    } catch (error: any) {
      // 处理超时和其他错误
      if (error.name === 'AbortError' || error.code === 'ETIME') {
        return {
          stdout: '',
          stderr: `❌ 命令执行超时 (30秒)。可能原因：\n1. 命令进入交互模式\n2. 网络连接问题\n3. 未登录wxcloud CLI\n\n执行的命令: ${command}`
        };
      }
      
      // 即使命令返回非零退出码，也可能包含有用的输出
      return {
        stdout: error.stdout || '',
        stderr: error.stderr || error.message || String(error)
      };
    }
  }

  // 获取默认环境ID的辅助方法
  private async getDefaultEnvId(): Promise<{ envId?: string; error?: string }> {
    try {
      const envResult = await this.executeWxCloudCommand('wxcloud env:list --json');
      
      if (envResult.stderr) {
        return { error: `获取环境列表失败：${envResult.stderr}` };
      }

      // 处理包含动画字符的输出，提取JSON部分
      let output = envResult.stdout;
      
      // 移除所有控制字符和动画字符
      output = output.replace(/\x1b\[[0-9;]*[mGK]/g, ''); // ANSI escape codes
      output = output.replace(/[\u2800-\u28FF]/g, ''); // Braille patterns (spinner chars)
      output = output.replace(/[⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏]/g, ''); // Common spinner characters
      output = output.replace(/[^\x20-\x7E\n\r\t{}[\]",:]/g, ''); // Keep only printable ASCII and JSON chars
      
      // 查找JSON内容，通常以{"code": 开始
      const jsonStart = output.indexOf('{"code"');
      if (jsonStart === -1) {
        return { error: `未找到有效的JSON响应。原始输出：${output.substring(0, 100)}...` };
      }
      
      const jsonStr = output.substring(jsonStart).trim();
      
      try {
        const jsonData = JSON.parse(jsonStr);
        
        if (jsonData && jsonData.data && jsonData.data.length > 0) {
          return { envId: jsonData.data[0].EnvId };
        } else {
          return { error: '没有找到可用的环境。请先创建环境。' };
        }
      } catch (parseError) {
        return { error: `JSON解析失败：${parseError}。提取的内容：${jsonStr.substring(0, 200)}...` };
      }
      
    } catch (error) {
      return { error: `获取环境列表异常：${error}。请手动指定环境ID。` };
    }
  }

  private async handleServiceList(args: any) {
    // 如果没有提供envId，提示用户手动指定
    if (!args.envId) {
      return {
        content: [
          {
            type: 'text',
            text: `❌ 请指定环境ID参数。

使用方法：
1. 先查看可用环境：调用 wxcloud_env_list 工具
2. 然后指定环境ID调用此工具

示例：
{
  "envId": "prod-7g8u1mb18fbf5ba5",
  "serviceName": "your-service-name"  // 可选
}

这样可以避免交互模式导致的超时问题。`
          }
        ]
      };
    }

    let command = `wxcloud service:list --json --envId=${args.envId}`;
    
    if (args.serviceName) {
      command += ` --serviceName=${args.serviceName}`;
    }

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `服务列表查询结果 (环境: ${args.envId})：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleServiceCreate(args: any) {
    let command = `wxcloud service:create --envId=${args.envId} --serviceName=${args.serviceName} --json`;
    
    if (args.isPublic) {
      command += ' --isPublic';
    }

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `服务创建结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleServiceConfig(args: any) {
    let command = `wxcloud service:config ${args.action || 'read'} --envId=${args.envId} --serviceName=${args.serviceName}`;
    
    if (args.action === 'update') {
      if (args.cpu) command += ` --cpu=${args.cpu}`;
      if (args.mem) command += ` --mem=${args.mem}`;
      if (args.minNum !== undefined) command += ` --minNum=${args.minNum}`;
      if (args.maxNum !== undefined) command += ` --maxNum=${args.maxNum}`;
      if (args.envParams) command += ` --envParams="${args.envParams}"`;
      command += ' --noConfirm';
    }

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `服务配置${args.action === 'update' ? '更新' : '查询'}结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleServiceRemove(args: any) {
    let command = `wxcloud service:remove --envId=${args.envId} --serviceName=${args.serviceName}`;
    
    if (args.noConfirm) {
      command += ' --noConfirm';
    }

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `服务删除结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleDeploy(args: any) {
    // 确保有环境ID，避免进入交互模式
    if (!args.envId) {
      return {
        content: [
          {
            type: 'text',
            text: `❌ 请指定环境ID参数。

使用方法：
1. 先查看可用环境：调用 wxcloud_env_list 工具
2. 然后指定环境ID调用此工具

示例：
{
  "envId": "prod-7g8u1mb18fbf5ba5",
  "serviceName": "your-service-name",
  "port": 3000,
  "dryRun": true
}`
          }
        ]
      };
    }

    let command = `wxcloud deploy --envId=${args.envId}`;
    
    if (args.serviceName) command += ` --serviceName=${args.serviceName}`;
    if (args.port) command += ` --port=${args.port}`;
    if (args.dryRun) command += ' --dryRun';

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `部署${args.dryRun ? '预览' : ''}结果 (环境: ${args.envId})：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleFunctionUpload(args: any) {
    let command = `wxcloud function:upload "${args.functionPath}" --envId=${args.envId}`;
    
    if (args.functionName) {
      command += ` --name=${args.functionName}`;
    }
    if (args.remoteNpmInstall) {
      command += ' --remoteNpmInstall';
    }

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `云函数上传结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleEnvList(args: any) {
    const command = 'wxcloud env:list --json';
    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `环境列表查询结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleStorageUpload(args: any) {
    const command = `wxcloud storage:upload "${args.localPath}" "${args.cloudPath}" --envId=${args.envId}`;
    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `文件上传结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  private async handleStorageDownload(args: any) {
    const command = `wxcloud storage:download "${args.cloudPath}" "${args.localPath}" --envId=${args.envId}`;
    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `文件下载结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  async run(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('WxCloud MCP server running on stdio');
  }
}

const server = new WxCloudMCPServer();
server.run().catch(console.error);
