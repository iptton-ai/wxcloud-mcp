#!/usr/bin/env node

/**
 * 简单的测试脚本，用于验证MCP服务器的基本功能
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('🧪 测试 wxcloud-mcp 服务器...\n');

// 启动MCP服务器
const serverPath = path.join(__dirname, '../dist/index.js');
const server = spawn('node', [serverPath], {
  stdio: ['pipe', 'pipe', 'pipe']
});

let receivedData = '';

server.stdout.on('data', (data) => {
  receivedData += data.toString();
  console.log('📤 服务器输出:', data.toString());
});

server.stderr.on('data', (data) => {
  console.log('📤 服务器stderr:', data.toString());
});

// 发送MCP初始化消息
setTimeout(() => {
  console.log('📝 发送初始化消息...');
  
  const initMessage = {
    jsonrpc: '2.0',
    id: 1,
    method: 'initialize',
    params: {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: {
        name: 'test-client',
        version: '1.0.0'
      }
    }
  };
  
  server.stdin.write(JSON.stringify(initMessage) + '\n');
}, 100);

// 发送工具列表请求
setTimeout(() => {
  console.log('📝 请求工具列表...');
  
  const toolsMessage = {
    jsonrpc: '2.0',
    id: 2,
    method: 'tools/list',
    params: {}
  };
  
  server.stdin.write(JSON.stringify(toolsMessage) + '\n');
}, 500);

// 清理
setTimeout(() => {
  console.log('🏁 测试完成，关闭服务器');
  server.kill();
}, 2000);

server.on('close', (code) => {
  console.log(`\n✅ 服务器已关闭，退出码: ${code}`);
  if (receivedData.includes('wxcloud-mcp')) {
    console.log('✅ 基本功能测试通过！');
  } else {
    console.log('❌ 测试可能未通过，请检查输出');
  }
});
