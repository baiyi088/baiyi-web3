### npx是什么
npx 是 npm（Node Package Manager）生态中的一个内置命令行工具，全称 Node Package eXecute（Node 包执行器）。它从 npm 5.2.0 版本开始（2017 年左右）就默认捆绑在 npm 里了，所以只要你安装了现代版的 Node.js（基本上 Node 8+ 以后都自带），直接就能用 npx 命令，不需要额外安装。

### npx 的主要作用（一句话总结）
让运行 npm 包里的可执行命令变得超级简单、零全局污染、零配置。它解决了 npm 时代的一个痛点：很多工具包（如 create-react-app、typescript 的 tsc、eslint、vite 等）提供了 CLI 命令，但你不想为了偶尔用一次就全局安装（npm install -g xxx），因为全局安装容易导致版本冲突、环境污染。npx 帮你做到：如果本地项目已安装 → 直接运行本地版本（node_modules/.bin/ 里的）

如果本地没安装 → 自动从 npm registry 下载最新版、临时执行、用完就丢（不留在项目里，也不全局安装）
总是优先用最新版（或指定版本）

npm = “下载和管理包的仓库管理员”
npx = “npm 附赠的快递小哥”：帮你临时取包、拆开运行、用完就扔，不占地方

### 创建新项目（最经典用法）bash
1. npx create-react-app my-app          # 不需要全局安装 create-react-app，新项目不推荐。
2. npx create-vite@latest my-vite-app   # Vite 项目  创建一个轻量、纯前端（通常是 SPA 单页应用） 的现代开发环境，开发体验极快，适合快速原型、组件库、Dashboard、工具类前端项目。
3. npx create-next-app@latest simple-front # 创建一个全栈 React 框架项目（Next.js），开箱即用服务器端渲染（SSR）、静态生成（SSG）、路由、API 等，适合需要 SEO、性能优化、生产级 Web 应用的场景。
4. npx degit user/repo my-project       # 快速克隆模板


### 运行一次性工具（不污染全局）bash

npx cowsay Hello                     # 临时玩一下 cowsay
npx http-server ./dist               # 快速起个静态服务器
npx eslint --init                    # 初始化 ESLint 配置

### 运行项目本地安装的工具（推荐写在 scripts 里，但 npx 更灵活）bash

npx tsc --init                       # 生成 tsconfig.json
npx prettier --write .               # 格式化代码
npx vitest                           # 运行测试（如果项目装了 vitest）

### 指定版本或 GitHub 仓库bash

npx typescript@5.0.0 --version
npx github:user/repo#branch          # 直接跑 GitHub 上的包


