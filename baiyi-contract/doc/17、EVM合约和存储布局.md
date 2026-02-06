EVM 是基于栈运行的虚拟机，所有的操作都在栈上进行

```solidity
contract Counter {
  uint public count;
  function get() public view
  returns (uint) {
    return count;
  }
  function inc() public {
    count += 1;
  }
  function setNumber(uint x) public
  {
    count = x;
  }
}
```

执行时

```solidity
object "Counter" {
  code {
    // constructor 逻辑：部署 runtime 部分
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }
  object "runtime" {
    code {
      // 如果发送 ETH，直接 revert
      if gt(callvalue(), 0) {
        revert(0, 0)
      }
      // 获取函数选择器（calldata 前 4 字节）
      let selector := shr(224, calldataload(0))
      switch selector
      case 0x6d4ce63c { // get() -> uint
        // sload(slot 0) => memory[0:32]
        let val := sload(0)
        mstore(0x00, val)
        return(0x00, 32)
      }
      case 0x371303c0 { // inc()
        let val := sload(0)
        sstore(0, add(val, 1))
        return(0, 0) // 空返回
      }
      case 0x55241077 { // setNumber(uint)
        // calldata[4:36] 是 uint 参数
        let x := calldataload(4)
        sstore(0, x)
        return(0, 0)
      }
      default { // fallback
        revert(0, 0)
      }
    }
  }
}
```



### <font style="color:rgb(31, 31, 31);">一、 核心概念：EVM 的“四大仓库”</font>
<font style="color:rgb(31, 31, 31);">合约运行时的空间资源分成了四类，我们可以用生活中的例子来理解：</font>

1. **<font style="color:rgb(31, 31, 31);">存储 (Storage)</font>**<font style="color:rgb(31, 31, 31);">：相当于**“硬盘”**。</font>
    - **<font style="color:rgb(31, 31, 31);">特性</font>**<font style="color:rgb(31, 31, 31);">：永久保存，即使交易结束，数据依然在链上 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">成本</font>**<font style="color:rgb(31, 31, 31);">：非常昂贵 </font><font style="color:rgb(31, 31, 31);">。读写以 32 字节（256位）为单位 </font><font style="color:rgb(31, 31, 31);">。</font>
2. **<font style="color:rgb(31, 31, 31);">内存 (Memory)</font>**<font style="color:rgb(31, 31, 31);">：相当于**“内存条 (RAM)”**。</font>
    - **<font style="color:rgb(31, 31, 31);">特性</font>**<font style="color:rgb(31, 31, 31);">：临时存放，只在函数执行期间有效，执行完就清空 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">成本</font>**<font style="color:rgb(31, 31, 31);">：比存储便宜，但随数据量增大，成本会呈指数级上升 </font><font style="color:rgb(31, 31, 31);">。</font>
3. **<font style="color:rgb(31, 31, 31);">栈 (Stack)</font>**<font style="color:rgb(31, 31, 31);">：相当于**“计算器的中间结果显示框”**。</font>
    - **<font style="color:rgb(31, 31, 31);">特性</font>**<font style="color:rgb(31, 31, 31);">：所有的计算（如加减法）都在这里完成 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">限制</font>**<font style="color:rgb(31, 31, 31);">：最多只能存 1024 个元素，且只能方便地操作最顶部的 16 个 </font><font style="color:rgb(31, 31, 31);">。</font>
4. **<font style="color:rgb(31, 31, 31);">瞬时存储 (Transient Storage - EIP1153)</font>**<font style="color:rgb(31, 31, 31);">：相当于**“便利贴”**。</font>
    - **<font style="color:rgb(31, 31, 31);">特性</font>**<font style="color:rgb(31, 31, 31);">：数据只在一次交易中有效（跨多个函数调用），交易结束即销毁 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">用途</font>**<font style="color:rgb(31, 31, 31);">：最适合做“重入锁”，比普通存储便宜得多 </font><font style="color:rgb(31, 31, 31);">。</font>



:::color4
PS: <font style="color:rgb(31, 31, 31);">未初始化时默认为 0</font>

:::



#### <font style="color:rgb(31, 31, 31);">1、不同数据使用的Gas成本</font>
<font style="color:rgb(31, 31, 31);">Gas 成本：很贵 （EIP-2200, EIP1283, EIP2929, EIP3529 ）</font>

<font style="color:rgb(31, 31, 31);">初始化数据：20,000 （ 从零到非零数据）</font>

<font style="color:rgb(31, 31, 31);">冷数据：Touch （由冷到热, 交易第一次加载）动作消耗 2100</font>

<font style="color:rgb(31, 31, 31);">更新数据：5000 （ 从非零到非零数据）</font>

<font style="color:rgb(31, 31, 31);">热数据(基准): SLOAD / SSTORE = 100</font>

<font style="color:rgb(31, 31, 31);">合约中定义的常量和immutable 变量不会占用空间</font>

---

### <font style="color:rgb(31, 31, 31);">二、 存储布局：Solidity 是如何省钱的？</font>
<font style="color:rgb(31, 31, 31);">这是文档的重点，理解了这一点就能写出更省 Gas 的代码。</font>

+ **<font style="color:rgb(31, 31, 31);">插槽 (Slot) 机制</font>**<font style="color:rgb(31, 31, 31);">：合约存储被分成了一个个编号的“抽屉”，每个抽屉（Slot）大小是 32 字节 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">紧凑打包 (Packing)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - <font style="color:rgb(31, 31, 31);">如果连续定义了几个小变量（如 </font>`<font style="color:rgb(68, 71, 70);">uint8</font>`<font style="color:rgb(31, 31, 31);">），</font><font style="color:black;">连续变量<32字节合并一槽（低位先），</font><font style="color:rgb(31, 31, 31);">Solidity 会尝试把它们塞进同一个插槽里 。</font>
    - **<font style="color:rgb(31, 31, 31);">我的理解</font>**<font style="color:rgb(31, 31, 31);">：这就像打包行李，把零碎的小物品塞进同一个格子里，只需支付一次“托运费”（即一次存储写入指令）。</font>
    - **<font style="color:rgb(31, 31, 31);">注意</font>**<font style="color:rgb(31, 31, 31);">：这种打包只发生在存储中，内存里的变量是不打包的，每个变量都占 32 字节 </font><font style="color:rgb(31, 31, 31);">。</font>

---



### <font style="color:rgb(31, 31, 31);">三、 复杂类型的定位逻辑</font>
<font style="color:rgb(31, 31, 31);">对于动态大小的数据，EVM 用了特殊的“地址计算器”：</font>

+ **<font style="color:rgb(31, 31, 31);">映射 (Mapping)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - <font style="color:rgb(31, 31, 31);">不像数组可以遍历，映射的每一个键值对（Key-Value）是散落在 2^256 个插槽中的 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">位置计算</font>**<font style="color:rgb(31, 31, 31);">：使用 </font>`<font style="color:rgb(68, 71, 70);">keccak256(key, slot_id)</font>`<font style="color:rgb(31, 31, 31);"> 算出具体的插槽位置 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">动态数组 (Array)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - <font style="color:rgb(31, 31, 31);">插槽本身只存储数组的</font>**<font style="color:rgb(31, 31, 31);">长度</font>**<font style="color:rgb(31, 31, 31);">。</font>
    - <font style="color:rgb(31, 31, 31);">真正的元素内容存储在 </font>`<font style="color:rgb(68, 71, 70);">keccak256(slot_id)</font>`<font style="color:rgb(31, 31, 31);"> 开始的连续空间里 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">字符串与字节数组 (String/Bytes)</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - **<font style="color:rgb(31, 31, 31);">短字符串</font>**<font style="color:rgb(31, 31, 31);">（≤31 字节）：数据和长度直接存在一个插槽里，非常高效 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">长字符串</font>**<font style="color:rgb(31, 31, 31);">（>31 字节）：插槽存 </font>`<font style="color:rgb(68, 71, 70);">长度*2+1</font>`<font style="color:rgb(31, 31, 31);">，数据存在哈希后的位置 </font><font style="color:rgb(31, 31, 31);">。</font>

---



### <font style="color:rgb(31, 31, 31);">四、 如何写出“优秀”的合约？</font>
<font style="color:rgb(31, 31, 31);">文档指出了优秀合约的三大标准：</font>**<font style="color:rgb(31, 31, 31);">更少 Gas、更安全、更好用</font>**<font style="color:rgb(31, 31, 31);">。</font>

1. **<font style="color:rgb(31, 31, 31);">Gas 优化技巧</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - **<font style="color:rgb(31, 31, 31);">合并存储</font>**<font style="color:rgb(31, 31, 31);">：将经常一起读写的变量定义在一起（如放在一个结构体中），让它们占用同一个 Slot </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">减少写入</font>**<font style="color:rgb(31, 31, 31);">：尽量避免将数据从零修改为非零（初始化的成本高达 20,000 Gas） </font><font style="color:rgb(31, 31, 31);">。</font>
2. **<font style="color:rgb(31, 31, 31);">工具使用</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - <font style="color:rgb(31, 31, 31);">使用 </font>`<font style="color:rgb(68, 71, 70);">forge inspect <Contract> storageLayout</font>`<font style="color:rgb(31, 31, 31);"> 来检查变量的排布 </font><font style="color:rgb(31, 31, 31);">。</font>
    - <font style="color:rgb(31, 31, 31);">使用内联汇编 (Assembly/Yul) 进行精细化操作，如直接手动计算 Mapping 的插槽位置来节省 Gas </font><font style="color:rgb(31, 31, 31);">。</font>

<font style="color:rgb(31, 31, 31);"></font>

### <font style="color:rgb(31, 31, 31);">评估合约 GAS</font>
<font style="color:rgb(31, 31, 31);">• 理解 EVM 让我们写出更低 Gas 的代码</font>

<font style="color:rgb(31, 31, 31);">• 测试阶段评估 gas ：</font>

<font style="color:rgb(31, 31, 31);">• forge test --gas-report</font>

<font style="color:rgb(31, 31, 31);">• forge snapshot</font>

<font style="color:rgb(31, 31, 31);">• 调用时 gas limit 预估：JSON RPC : eth_estimateGas</font>

<font style="color:rgb(31, 31, 31);">• Viem: publicClient.estimateGas</font>

<font style="color:rgb(31, 31, 31);"></font>

```javascript
mapping(address => uint256) public balances;
function transfer(address to, uint256 amount) external returns (bool success) {
  assembly {
  // 1. 计算 msg.sender 的 balance slot
  mstore(0x00, caller()) // 把 caller()（即 msg.sender）放到内存 [0x00, 0x20]
  mstore(0x20, balances.slot) // balances 在 storage 的 slot 编号
  let senderSlot := keccak256(0x00, 0x40) // 计算 keccak256(msg.sender . slot)
  // 2. 加载 msg.sender 的余额
  let senderBalance := sload(senderSlot)
  if lt(senderBalance, amount) { // 3. 检查余额是否足够
  mstore(0x00, "NotEnoughBalance")
  revert(0x00, 0x20)
  }
  // 4. 计算 to 的 balance slot
  mstore(0x00, to)
  mstore(0x20, balances.slot)
  let toSlot := keccak256(0x00, 0x40)
  // 5. 更新 balances
  sstore(senderSlot, sub(senderBalance, amount))
  sstore(toSlot, add(sload(toSlot), amount))
  mstore(0x00, 1) // 6. 返回 true
  return(0x00, 0x20)
}
```

<font style="color:rgb(31, 31, 31);"></font>

### <font style="color:rgb(31, 31, 31);">作业</font>
#### 作业1
• 先查看当前 NFTMarkmet 的各函数消耗，测试用例的 gas report 记录到 gas_report_v1.md

• 尝试优化 NFTMarknet 合约，尽可能减少 gas ，测试用例的 gas report 记录到 gas_report_v2.md

[https://decert.me/quests/6a5ce6d6-0502-48be-8fe4-e38a0b35df62](https://decert.me/quests/6a5ce6d6-0502-48be-8fe4-e38a0b35df62)



#### 作业2
• 确定 Owner 的 Slot 位置，使用内联汇编读取和修改Owner

[https://decert.me/challenge/163c68ab-8adf-4377-a1c2-b5d0132edc69](https://decert.me/challenge/163c68ab-8adf-4377-a1c2-b5d0132edc69)



#### 作业3
利用存储布局的理解，读取合约私有变量数据

• [https://decert.me/quests/b0782759-4995-4bcb-85c2-2af749f0fde9](https://decert.me/quests/b0782759-4995-4bcb-85c2-2af749f0fde9)







### <font style="color:rgb(31, 31, 31);">总结</font>
<font style="color:rgb(31, 31, 31);">这份 PDF 的核心思想是：</font>**<font style="color:rgb(31, 31, 31);">合约开发者不应只看 Solidity 代码，而应能透过代码看到底层的 Slot 排布。</font>**<font style="color:rgb(31, 31, 31);"> 合理利用存储合并和新特性（如瞬时存储），能显著降低用户的交易成本。</font>







