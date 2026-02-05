## 什么是 ABI
• 智能合约应⽤⼆进制接口（Application Binary Interface，简称 ABI）是EVM中与合约交互的标准⽅式：包含接口描述和编码规范

• 标准：⽅便⼈类阅读、定义接口使前后端，其他智能合约能够正确地与合约进⾏交互

### ABI 形同 Web2 API
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291548008-08b0a3c8-99a4-4b45-830e-aef5fd659d3f.png)

### 没有合约ABI时
外界⽆法知晓如何与合约交互

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291642874-4aab4144-ab03-4c51-86b9-13a68d3844d4.png)

### 有合约ABI时
很容易与合约交互

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291661668-eeef2fd0-7035-4f19-a0e1-c6e5e69f1673.png)

很容易解析交易

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291694408-b8c4308e-bae7-464b-a5b7-c6115556d398.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291701022-9a1482f9-deb7-455b-b9e2-9d5365b917cc.png)



## 如何生成 ABI
ABI 是编译的产物（solc），使用 Remix 和 Foundry

• forge build Counter.sol

• 在 /out/Counter.sol/Counter.json 中包含ABI

• forge inspect : 检查和获取智能合约的元数据信息：ABI、字节码…

• forge inspect Counter abi --json > Counter.json



<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291884317-7d604c78-259b-4336-a65e-1f991c42038d.png)



## ABI 接口描述
• ABI 是一个json 对象数组， 每一个json 对象用来描述函数、事件、错误



### 函数
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291937925-f5c3aa1b-95e8-47b4-a175-ac2870cf7deb.png)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770291928267-57c2341f-f06a-4931-935f-c48b79b58440.png)



### 事件
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770292040375-5f58928b-9db0-45e1-808d-52403591b840.png)

### 错误
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770292079002-10249a35-f049-4aa8-ab6b-4f4afc9ed8fc.png)

• JSON对象：

• type： function, event , error

• name： 函数名称、事件名称..

• inputs / outputs： 函数入参，是一个数组对象，每个数组对象会包含：

◦ name： 参数名称；

◦ type： 参数类型

◦ indexed：事件索引字段（字段是 event topic ，则为 true）

◦ components： 供元组（tuple） 类型使用(ABI 里只有预定义类型)；



• stateMutability： 为下列值之一： pure ， view ， nonpayable 和 payable 。



## <font style="color:black;">ABI编码与解码 </font>
### <font style="color:black;">函数/错误编码</font>
+ <font style="color:black;">结构：函数选择器（前4字节） + 参数编码。</font>
+ <font style="color:black;">函数选择器：Keccak256哈希函数签名（函数名 + 参数类型列表，无空格、无参数名、无返回值）。</font>
+ <font style="color:black;">参数编码：从第5字节开始，静态类型扩展到32字节；动态类型用位置偏移、数据大小和真实数据。</font>



### <font style="color:black;">参数编码细节</font>
+ <font style="color:black;">静态类型（uint等）：直接扩展到32字节。</font>
+ <font style="color:black;">动态类型（bytes、string、数组）：在单独位置编码，先放偏移。</font>
+ <font style="color:black;">示例命令：</font><font style="color:black;">cast abi-encode 'enc(uint a, bytes memory b)' 1 0x0123</font><font style="color:black;">。</font>



### <font style="color:black;">事件编码</font>
+ <font style="color:black;">Topic0：Keccak256(事件签名)（非匿名事件）。</font>
+ <font style="color:black;">日志包含：合约地址、topics（最多4个，indexed参数作为topic；数组/结构体用Keccak256编码）。</font>
+ <font style="color:black;">非indexed参数：与函数参数相同编码规则，作为data存储。</font>
+ <font style="color:black;">示例命令：</font><font style="color:black;">cast sig-event 'Transfer(address indexed from, address indexed to, uint256 value)'</font><font style="color:black;"> → 输出哈希值。</font>



### <font style="color:black;">工具与示例</font>
+ <font style="color:black;">Foundry：</font><font style="color:black;">cast abi-encode</font><font style="color:black;"> / </font><font style="color:black;">cast  decode-calldata</font><font style="color:black;">。</font>
+ <font style="color:black;">Solidity：</font><font style="color:black;">abi.decode</font><font style="color:black;"> / </font><font style="color:black;">abi.encode</font><font style="color:black;">。</font>
+ <font style="color:black;">JS库：viem、ethers.js。</font>
+ <font style="color:black;">在线工具：</font>[https://chaintool.tech/calldata](https://chaintool.tech/calldata)<font style="color:black;">、</font>[https://openchain.xyz/](https://openchain.xyz/)
+ <font style="color:black;">ABI数据库：</font>[https://www.4byte.directory/](https://www.4byte.directory/)
+ <font style="color:black;">示例合约：testAbiEncode_Decode.sol。</font>

## 
## <font style="color:black;">作业：ABI实践 (页15)</font>
+ <font style="color:black;">利用ABI逆向解码交易数据。</font>
+ <font style="color:black;">链接：</font><font style="color:black;background-color:transparent;">https://decert.me/quests/0ba0f6e3-2b87-4a9b-b3aa-ae5f323459e1。</font>













