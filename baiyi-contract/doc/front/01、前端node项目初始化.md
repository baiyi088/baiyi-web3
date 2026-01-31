## node项目初始化

```
mkdir my-node-app
cd my-node-app

pnpm init -y

# 创建源代码目录（推荐把代码都放 src 里）
mkdir src
touch src/index.ts   # 或 src/index.js 如果不用 ts

# 如果想用 TypeScript（强烈推荐 2026 年新项目）
pnpm add -D typescript @types/node tsx

# 生成 tsconfig.json（用最新 Node 推荐的配置）
npx tsc --init --target es2022 --module es2020 --moduleResolution node --outDir ./dist --rootDir ./src --strict --esModuleInterop

# 可选：改成 ESM（推荐新项目用 import/export 语法），ESM 模块是 Node.js 默认支持的模块系统，不需要额外配置。
# 在 package.json 里加这一行（或手动加）
# "type": "module"

```
然后在 package.json 的 scripts 里加常用命令：

```
"scripts": {
  "dev": "tsx watch src/index.ts",
  "start": "node dist/index.js",
  "build": "tsc"
}
```
以后开发就直接 pnpm dev 即可热重载运行。


### tsc和tsx的区别
1、tsc 是 TypeScript 编译器，用于将 TypeScript 代码编译为 JavaScript 代码。
2、tsx 是一个基于 ts-node 的工具，用于直接运行 TypeScript 代码，无需先编译。

### tsconfig.json 作用
tsconfig.json 是 TypeScript 项目中最核心的配置文件，它的存在本身就标志着“这个目录是一个 TypeScript 项目根目录”。

tsconfig.json 告诉 TypeScript 编译器（tsc）应该编译哪些文件、用什么规则编译、输出到哪里、类型检查要多严格，以及影响 IDE（VS Code 等）的智能提示、自动补全、跳转定义等行为。

没有 tsconfig.json 时，tsc 会用默认设置（很宽松，很多严格检查关闭），但实际项目几乎没人这么用。











