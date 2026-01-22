## 合约部署的系列操作
1、准备metamask钱包。
领水

要将智能合约部署到 **Sepolia测试网**（https://sepolia.etherscan.io），最简单、最高频的方式是通过 **Remix** + **MetaMask** 来完成（适合初学者和快速测试）。下面是2026年当前最实用的完整步骤：

### 准备工作（必须先完成）

1. **安装并配置 MetaMask**
   - 确保你已经安装了 MetaMask 浏览器插件（或手机App）
   - 切换到 Sepolia 网络（如果没有，手动添加）：
     - 网络名称：Sepolia Test Network
     - RPC URL（任选一个稳定节点，2026年常用）：
       - https://rpc.sepolia.org
       - https://ethereum-sepolia-rpc.publicnode.com
       - https://sepolia.infura.io/v3/（需自己Infura key）
     - Chain ID：11155111
     - 货币符号：ETH
     - 浏览器区块浏览器：https://sepolia.etherscan.io

2. **获取一些 Sepolia 测试网 ETH**（用于支付 gas 费）
   - 常用免费水龙头（faucet）：
     - https://sepoliafaucet.com
     - https://faucets.chain.link/sepolia
     - https://www.infura.io/faucet/sepolia （需注册）
     - Alchemy、QuickNode 等平台的水龙头
   - 一般输入你的钱包地址，领 0.1~1 ETH 就够部署大多数合约了

## 部署合约

一、部署和开源一块
forge script .\script\MyToken.s.sol --keystore .\.keystores\main-wallet --rpc-url sepolia --broadcast --verify --etherscan-api-key YOUR_API_KEY_HERE.

部署成功后的结果：

https://sepolia.etherscan.io/address/0x4cb92cee3d86a11323d5eab68259d41dcb19fde8



二、先部署后期开源
1、部署到sepolia
forge script .\script\MyToken.s.sol --rpc-url sepolia --broadcast

2、已发布的合约开源
forge verify-contract 0x021b037Be4454D717Be7fB22c2B8a271f73D5983  --etherscan-api-key U94W3GDIUPXIRQ82HJMGVM7QJMH9ZTG6IG --constructor-args $(cast abi-encode "constructor(string,string)" "My Awesome Token" "MAT") ./src/MyToken.sol:MyToken --chain sepolia --watch


部署成功后的结果
https://sepolia.etherscan.io/address/0x021b037be4454d717be7fb22c2b8a271f73d5983#code



