#!/usr/bin/env node

// MCP工具测试脚本
// 用于测试每个MCP工具是否能正确返回结果

import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// 模拟MCP工具调用的测试
class MCPToolTester {
  // 模拟executeWxCloudCommand方法
  async executeWxCloudCommand(command) {
    console.log(`📞 执行命令: ${command}`);
    const startTime = Date.now();
    
    try {
      // 添加超时控制
      const timeoutMs = 10000; // 10秒超时
      const commandWithTimeout = `timeout ${timeoutMs/1000}s ${command}`;
      
      const result = await execAsync(commandWithTimeout);
      const duration = Date.now() - startTime;
      
      console.log(`✅ 命令执行完成 (${duration}ms)`);
      console.log(`📤 stdout: ${result.stdout?.substring(0, 200)}${result.stdout?.length > 200 ? '...' : ''}`);
      
      return result;
    } catch (error) {
      const duration = Date.now() - startTime;
      console.log(`❌ 命令执行失败 (${duration}ms): ${error.message}`);
      
      return {
        stdout: error.stdout || '',
        stderr: error.stderr || error.message || String(error)
      };
    }
  }

  // 测试 service_list 工具
  async testServiceList(args = {}) {
    console.log('\n🧪 测试 wxcloud_service_list...');
    
    let command = 'wxcloud service:list --json';
    
    if (args.envId) {
      command += ` --envId=${args.envId}`;
    }
    if (args.serviceName) {
      command += ` --serviceName=${args.serviceName}`;
    }

    const result = await this.executeWxCloudCommand(command);
    
    return {
      content: [
        {
          type: 'text',
          text: `服务列表查询结果：\n\n输出：\n${result.stdout}\n\n${result.stderr ? `错误信息：\n${result.stderr}` : ''}`
        }
      ]
    };
  }

  // 测试 env_list 工具
  async testEnvList() {
    console.log('\n🧪 测试 wxcloud_env_list...');
    
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

  // 测试所有查询类工具
  async runAllTests() {
    console.log('🚀 开始MCP工具测试...\n');

    const tests = [
      { name: 'wxcloud_env_list', test: () => this.testEnvList() },
      { name: 'wxcloud_service_list', test: () => this.testServiceList() },
      { name: 'wxcloud_service_list_with_env', test: () => this.testServiceList({ envId: 'test-env' }) }
    ];

    for (const { name, test } of tests) {
      try {
        console.log(`\n=== 测试 ${name} ===`);
        const startTime = Date.now();
        
        const result = await test();
        const duration = Date.now() - startTime;
        
        console.log(`✅ ${name} 测试完成 (${duration}ms)`);
        console.log(`📋 结果预览: ${result.content[0].text.substring(0, 150)}...`);
        
      } catch (error) {
        console.log(`❌ ${name} 测试失败:`, error.message);
      }
    }

    console.log('\n🎉 所有测试完成!');
  }
}

// 运行测试
const tester = new MCPToolTester();
tester.runAllTests().catch(console.error);
