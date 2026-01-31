### ts和js的区别
1、.ts 文件是 TypeScript 代码，而 .js 文件是 JavaScript 代码。
2、.ts 文件需要编译成 .js 文件才能在 Node.js 或浏览器中运行。
3、.ts 文件可以使用 TypeScript 特有的类型检查和语法，而 .js 文件只能使用 JavaScript 语法。


### 最直观的代码对比纯 .js（动态类型，运行时才炸）
```
// utils.js
function greet(name) {
  return "Hello " + name.toUpperCase();   // 如果 name 是 undefined 或 null → 运行时报错
}

console.log(greet("Alice"));
console.log(greet(123));          // 运行时才发现问题
```
同功能用 .ts（静态检查，写代码就报错）
```
// utils.ts
function greet(name: string) {    // 强制要求 string 类型
  return "Hello " + name.toUpperCase();
}

console.log(greet("Alice"));
// console.log(greet(123));       // IDE 立刻红线报错：Argument of type 'number' is not assignable to parameter of type 'string'
```

### Node.js 项目里的实际区别（常见痛点）
1. 运行方式不同
.js → node src/index.js 或 tsx src/index.js（如果用了 ESM）
.ts → 通常用 tsx watch src/index.ts（开发热重载） 或 先 tsc 编译出 dist/*.js 再 node dist/index.js

2. package.json 
"type": "module" 时两者都支持 ESM（import/export）
但 .ts 文件导入时，路径通常要写成 .js 结尾（即使实际文件是 .ts）：ts

```
// 正确写法（TypeScript 要求）
import { add } from './math.js';   // 即使 math 是 math.ts 文件
```

3. 还有 .tsx 变体
.tsx = .ts + 支持 JSX 语法（React 组件常用）
.ts = 纯 TypeScript（工具函数、类型定义、Node 服务逻辑常用）

