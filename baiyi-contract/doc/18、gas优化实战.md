<font style="color:rgb(31, 31, 31);">如何通过</font>**<font style="color:rgb(31, 31, 31);">精细的数据结构设计</font>**<font style="color:rgb(31, 31, 31);">和</font>**<font style="color:rgb(31, 31, 31);">合约模式选择</font>**<font style="color:rgb(31, 31, 31);">来优化以太坊（EVM）上的 Gas 消耗 。</font>

## 案例
### 案例分析1
创建一个“学校”智能合约来收集学生地址。合约必须具有3个主要功能：

1. 在合约中添加或删除学生。

2. 询问给定的学生地址是否属于学校。

3. 获取所有学生的名单。

#### Mapping实现: SchoolMapping.sol
```solidity
pragma solidity ^0.8.0;

contract SchoolMapping {
  
  mapping(address => bool) students;
  
  constructor()  {
  }
  
  function addStudent(address student ) public {
    require(!isStudent(student));
    students[student] = true;
  }
  
  
  function removeStudent(address student) public {
    require(isStudent(student));
    students[student] = false;
  }

  function isStudent(address student) public view returns (bool) {
      return students[student];
  }
  
  function getStudents(uint256 k) public view returns(address[] memory) {
    
    
  }
  
  
} 
```

[https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolMapping.sol](https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolMapping.sol)

#### 数组实现：SchoolBaseArray.sol
```solidity
pragma solidity ^0.8.0;

contract SchoolBaseArray {
  
  address[] students;
  
  constructor()  {
  }
  
  function addStudent(address student ) public {
      require(!isStudent(student));
      students.push(student);
  }
  
  
  function removeStudent(address student) public {
    (bool found, uint256 index) =  _getStudentIndex(student);
    require(found);

    for (uint256 i = index; i<students.length; ++i ) {
      students[i-1] = students[i];
    }
    students.pop();
  }

  function isStudent(address student) public view returns (bool) {
    (bool found, ) =  _getStudentIndex(student);
    return found;
  }
  
  function getStudents() public view returns(address[] memory) {
    return students;
  }

  function _getStudentIndex(address student) internal view returns (bool, uint256) {
    for (uint256 i = 0; i< students.length; ++i) {
      if (student == students[i]) {
        return (true, i);
      }
    }
    return (false, 0);
  }
  
  
} 
```

[https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolBaseArray.sol](https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolBaseArray.sol)



#### Gas 对比
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386632224-82408e60-13b8-415b-818f-12c53732a127.png)





#### 可迭代链表
SchoolMappingList.sol

```solidity
pragma solidity ^0.8.0;

contract SchoolMappingList {
  
  mapping(address => address) _nextStudents;
  uint public listSize;

  address constant GUARD = address(1);
  
  constructor()  {
    _nextStudents[GUARD] = GUARD;
  }
  
  function addStudent(address student ) public {
    require(!isStudent(student));

    _nextStudents[student] = _nextStudents[GUARD];
    _nextStudents[GUARD] = student;
    listSize ++;
  }
  
  
  function removeStudent(address student) public {
    require(isStudent(student));
    address prevStudent = _getPrevStudent(student);
    _nextStudents[prevStudent] = _nextStudents[student];

    _nextStudents[prevStudent] = address(0);
    listSize --;
  }

  function removeStudent2(address student, address prevStudent) public {
    require(isStudent(student));
    require(_nextStudents[prevStudent] == student);

    _nextStudents[prevStudent] = _nextStudents[student];
    _nextStudents[student] = address(0);
    listSize --;
  }

  function _getPrevStudent(address student) internal view returns (address) {
    address currentAddress = GUARD;
    while (_nextStudents[currentAddress] != GUARD) {
      if (_nextStudents[currentAddress] == student) {
        return currentAddress;
      }
      currentAddress = _nextStudents[currentAddress];
    }
    return address(0);
  }

  function isStudent(address student) public view returns (bool) {
      return _nextStudents[student] != address(0);
  }
  
  function getStudents() public view returns (address[] memory) {
    address[] memory students = new address[](listSize);
    address currentAddress = _nextStudents[GUARD];
    for(uint256 i =0 ; currentAddress != GUARD; ++i) {
      students[i] = currentAddress;
      currentAddress = _nextStudents[currentAddress];
    }
    return students;
  }
  
  
} 
```



[https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolMappingList.sol](https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolMappingList.sol)

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386652121-35ca1cab-0fae-4c51-bb99-35e5bda31485.png)



#### 可迭代链表 - 添加
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386663561-bbf1e510-821f-45b4-a8f8-0188b2c7be8f.png)

#### 可迭代链表 - 删除
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386699026-89525c91-23b3-4c27-9449-9604f944354f.png)

#### 可迭代链表 - 性能
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386733581-0cd2ce3e-55d0-48ff-bad7-ce6eac3cea72.png)



### 案例2
需要根据分数来维持学生的排序，功能需求如下：

1. 将新学生添加到根据分数排序的列表中

2. 提高学生分数（保持列表有序）

3. 降低学生分数（保持列表有序）

4. 从名单中删除学生

5. 获取前K名学生名单



#### 可迭代链表 - 有序插入
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386957706-eabebb6d-bd07-4b9c-bf66-108506fa0838.png)

#### 可迭代链表 - 列表删除
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386974324-fb5950b7-695c-49fe-ad7c-42d26eb9a093.png)

#### 可迭代链表 - 更新分数
<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770386986869-a26c55d9-4062-4c39-b388-0e9396ac667d.png)



#### 优化的可迭代链表
[https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolOptimized.sol](https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/SchoolOptimized.sol)



### 案例3
之前的 TokenBank 合约的前 3 名，修改为前 10 名，并用可迭代的链表保存。

[https://decert.me/challenge/753d5050-e5e4-4a0d-8ad9-9ecd7e0e0788](https://decert.me/challenge/753d5050-e5e4-4a0d-8ad9-9ecd7e0e0788)



### 案例4
• 给所有的集训营学员（白名单）发纪念勋章？

#### 白名单实现
• 映射：mapping(address => bool) public whitelist; //

• 后台离线签名，省 gas ，比较灵活（需要从后端获取）

#### 默克尔树 （Merkle Tree）
构建好树之后，

验证证明只需要对数级的时间！

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770387133263-1f11acdd-e36b-4f97-b63c-80797de0e7ff.png)

验证 L1 只需要 Hash0-1 和 Hash 1



• 构建白名单默克尔树 （Merkle Tree）

[https://github.com/OpenSpace100/blockchain-tasks/tree/main/merkle_distributor](https://github.com/OpenSpace100/blockchain-tasks/tree/main/merkle_distributor)

• 在合约里验证是在默克尔树中

[https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/MerkleAirdrop.sol](https://github.com/OpenSpace100/blockchain-tasks/blob/main/solidity_sample_code/MerkleAirdrop.sol)



参考文章：[https://learnblockchain.cn/article/4613](https://learnblockchain.cn/article/4613)



## MultiCall
• 可否多个交易(调用) 封在一个交易里

• 减少每笔手续费的 21000 base gas

• 减少数据的冷加载

• 如何在同一个交易里同时调用合约里的多个（次）函数？

### MultiCall 写 - 交易
```solidity
function multicall(bytes[] calldata data) external returns (bytes[] memory results) {
  results = new bytes[](data.length);
  for (uint256 i = 0; i < data.length; i++) {
  results[i] = delegateCall(data[I]);
  }
  return results;
}
```

在自己合约实现

openzeppelin-contracts/blob/master/contracts/utils/Multicall.sol

testMultiCall.sol



### MULTICALL - 读
• 打包读取和打包写入， 在一次 RPC 请求封装多个请求

• 降低网络请求

• 保证数据来自一个区块

• Viem 有原生集成：[https://viem.sh/docs/contract/multicall#multicalladdress-optional](https://viem.sh/docs/contract/multicall#multicalladdress-optional)

• 打包写入，仅使用于不关注 msg.sender 情况。



[https://github.com/mds1/multicall/blob/main/src/Multicall3.sol](https://github.com/mds1/multicall/blob/main/src/Multicall3.sol)



```solidity
function aggregate3(Call3[] calldata calls) public payable returns (Result[] memory returnData) {
  uint256 length = calls.length;
  returnData = new Result[](length);
  Call3 calldata calli;
  for (uint256 i = 0; i < length;) {
  Result memory result = returnData[i];
  calli = calls[i];
  (result.success, result.returnData) = calli.target.call(calli.callData);
  assembly {
  // …
  }
  unchecked { ++i; }
  }
}
```

公共合约

[https://cn.etherscan.com/address/0xcA11bde05977b3631167028862bE2a173976CA11#code](https://cn.etherscan.com/address/0xcA11bde05977b3631167028862bE2a173976CA11#code)



### NFT 批量铸造
基于 OpenZepplin 实现

```solidity
function mintNFT(uint256 quantity) public {
  for (uint i = 0; i < quantity; i++) {
    uint index = totalSupply();
    _safeMint(msg.sender, index);
  }
}
function _safeMint( address to,
                   uint256 tokenId) internal {
  _balances[to] += 1;
  _owners[tokenId] = to;
  emit Transfer(address(0), to, tokenId);
}
```

mint 1个NFT就需要进行至少2次SSTORE

2 N * SSTORE Gas

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770387785630-a7b95f6f-de73-4267-8f0f-34da6c1bab37.png)



#### ERC721A - Lazy Minting
ERC721A 实现: Lazy Minting ， 等到需要的时候再更新槽

铸造 N 个NFT 与1 NFT 的成本相当

```solidity
function mintNFT(address to, uint256 quantity) {
  uint index = totalSupply() + 1;
  _owners[index] = to;
  _balances[to] += quantity;
  …
}
function ownerOf(uint256 _tokenId) external view returns (address)
{
  for (uint256 curr = tokenId; curr >= 0;curr--) {
    address owner = _owners[curr];
    if (owner != address(0)) {
      return owner;
    }
  }
}
```

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770387775316-d048861e-4d01-4519-9ee6-4d8bea48e1f4.png)

#### ERC721A - 转移
```solidity
function _transfer(address from,address to,uint256 tokenId) private {
  require(from == ownerOf(tokenId));
  balance[from] -= 1;
  balance[to] += 1;
  _owners[tokenId] = to;
  uint256 nextTokenId = tokenId + 1;
  if (_owners[nextTokenId] == address(0) && _exists(nextTokenId)) {
    _owners[nextTokenId] = from;
  }
  emit Transfer(from,to,tokenId);
}
```

<!-- 这是一张图片，ocr 内容为： -->
![](https://cdn.nlark.com/yuque/0/2026/png/21482780/1770387826757-8c7ba812-950f-422c-814a-cf56f0ce6b3c.png)





### 练习题
• 组合使用 Multicall (delegateCall) 、 默克尔树、erc20 permit 授权， 实现一个默克尔树优惠价格（100 Token）

购买名单， 使用 Multicall. 调用 2 个方法：

• 合约： AirdopMerkleNFTMarket:

• permitPrePay : 完成预授权

• claimNFT( ) ： 验证白名单，如果通过，直接使用 permitPrePay 的授权，转入 100 token， 并转出 NFT



[https://decert.me/quests/faa435a5-f462-4f92-a209-3a7e8fdc4d81](https://decert.me/quests/faa435a5-f462-4f92-a209-3a7e8fdc4d81)





## <font style="color:rgb(31, 31, 31);">一、 Gas 优化技巧</font>
• 修改变量顺序 -> 合并槽（但尽量使用 uint256 的变量）、 需要时使用 unchecked

• 控制交易内状态（如重入锁），用瞬态存储 transient，常量或 immutable 代替变量

• 精确声明 Solidity 合约函数的可见性

• 避免无限制的循环、线性增长

• 合约中没有引用的变量，用事件 （[https://learnblockchain.cn/article/880](https://learnblockchain.cn/article/880)）

• 减少链上数据：IPFS 链下存储

• 使用代理进行大规模部署（复用实现合约）

• 区分交易 Gas （变量） 和 部署 Gas (字节码) 

• 链下计算、链上验证（如: 数组用链表实现、可迭代的链表）

• 在合约验证数据，而不是存储数据（如使用 Merkle 树）





## <font style="color:rgb(31, 31, 31);">二、 深度理解：用 Mapping 实现“链表”</font>
<font style="color:rgb(31, 31, 31);">这是文档的核心案例，解决的是</font>**<font style="color:rgb(31, 31, 31);">数组（Array）在处理大规模数据时的性能瓶颈</font>**<font style="color:rgb(31, 31, 31);">。</font>

#### <font style="color:rgb(31, 31, 31);">1. 为什么数组很“贵”？</font>
<font style="color:rgb(31, 31, 31);">在传统的数组实现中，如果你要从一个 100 人的名单里删除一个学生：</font>

+ **<font style="color:rgb(31, 31, 31);">数组做法</font>**<font style="color:rgb(31, 31, 31);">：删除中间一个后，通常需要把后面的元素一个个往前挪，或者在查找时遍历整个数组。</font>
+ **<font style="color:rgb(31, 31, 31);">Gas 成本</font>**<font style="color:rgb(31, 31, 31);">：随着人数增加，Gas 消耗呈</font>**<font style="color:rgb(31, 31, 31);">线性增长</font>**<font style="color:rgb(31, 31, 31);">。从 PDF 的对比数据看，删除 100 个学生中的一个，数组实现需消耗约 </font>**<font style="color:rgb(31, 31, 31);">41.6万 Gas</font>**<font style="color:rgb(31, 31, 31);">，而 Mapping 链表仅需约 </font>**<font style="color:rgb(31, 31, 31);">1.3万 Gas</font>**<font style="color:rgb(31, 31, 31);">。</font>

#### <font style="color:rgb(31, 31, 31);">2. 通俗理解“Mapping 链表”</font>
<font style="color:rgb(31, 31, 31);">文档引入了**可迭代链表（Iterable Linked List）**的概念：</font>

+ **<font style="color:rgb(31, 31, 31);">结构</font>**<font style="color:rgb(31, 31, 31);">：不再使用 </font>`<font style="color:rgb(68, 71, 70);">Student[]</font>`<font style="color:rgb(31, 31, 31);"> 数组，而是使用 </font>`<font style="color:rgb(68, 71, 70);">mapping(address => address)</font>`<font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">逻辑</font>**<font style="color:rgb(31, 31, 31);">：Map 的 </font>**<font style="color:rgb(31, 31, 31);">Key</font>**<font style="color:rgb(31, 31, 31);"> 是当前学生，</font>**<font style="color:rgb(31, 31, 31);">Value</font>**<font style="color:rgb(31, 31, 31);"> 是“指向”的下一个学生 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">哨兵 (GUARD)</font>**<font style="color:rgb(31, 31, 31);">：设置一个特殊的 </font>`<font style="color:rgb(68, 71, 70);">0x0a</font>`<font style="color:rgb(31, 31, 31);"> 地址作为开头和结尾，形成一个环 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">优势</font>**<font style="color:rgb(31, 31, 31);">：</font>
    - **<font style="color:rgb(31, 31, 31);">添加/删除是常数级的</font>**<font style="color:rgb(31, 31, 31);">：只需要修改相邻两个节点的“指向”关系，无论名单里有 10 个人还是 10,000 个人，Gas 消耗几乎一致 </font><font style="color:rgb(31, 31, 31);">。</font>
    - **<font style="color:rgb(31, 31, 31);">可遍历</font>**<font style="color:rgb(31, 31, 31);">：通过 Map 的 Value 不断寻找下一个 Key，就可以把整个名单拉出来 </font><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">三、 默克尔树 (Merkle Tree)：白名单的终极方案</font>
<font style="color:rgb(31, 31, 31);">如果你要给 1 万个白名单用户发勋章，直接把 1 万个地址存进合约会让你破产。</font>

+ **<font style="color:rgb(31, 31, 31);">方案</font>**<font style="color:rgb(31, 31, 31);">：只在合约里存一个 </font>**<font style="color:rgb(31, 31, 31);">Merkle Root</font>**<font style="color:rgb(31, 31, 31);">（一个哈希值）</font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">理解</font>**<font style="color:rgb(31, 31, 31);">：这就像把 1 万个名字锁进了一个保险箱，但你只需要拿着保险箱的“特征码”留在链上。</font>
+ **<font style="color:rgb(31, 31, 31);">验证</font>**<font style="color:rgb(31, 31, 31);">：用户领取时，自己提供一条“证明路径”（Proof）。合约只需要做几次简单的哈希计算（对数级时间复杂度），就能验证这个用户是否在名单里 </font><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">四、 ERC721A 的“懒政”哲学</font>
<font style="color:rgb(31, 31, 31);">ERC721A 是一种极度优化的 NFT 标准，其核心是 </font>**<font style="color:rgb(31, 31, 31);">Lazy Minting（延迟更新）</font>**<font style="color:rgb(31, 31, 31);">。</font>

+ **<font style="color:rgb(31, 31, 31);">普通 NFT (OpenZeppelin)</font>**<font style="color:rgb(31, 31, 31);">：铸造 10 个 NFT，要在存储里写 10 次 Owner 信息，非常贵 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">ERC721A</font>**<font style="color:rgb(31, 31, 31);">：如果你一次铸造 10 个，它只在第 1 个 NFT 上写你的名字，后面 9 个先空着 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">查询逻辑</font>**<font style="color:rgb(31, 31, 31);">：当有人查第 5 个 NFT 是谁的时，程序会</font>**<font style="color:rgb(31, 31, 31);">往回找</font>**<font style="color:rgb(31, 31, 31);">，看到第 1 个是你的，那第 5 个肯定也是你的 </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">效果</font>**<font style="color:rgb(31, 31, 31);">：铸造 1 个 NFT 和铸造 N 个 NFT 的成本几乎相当，极大地节省了批量铸造的 Gas </font><font style="color:rgb(31, 31, 31);">。</font>

---

## <font style="color:rgb(31, 31, 31);">五、 MultiCall：打包交易省小钱</font>
+ **<font style="color:rgb(31, 31, 31);">原理</font>**<font style="color:rgb(31, 31, 31);">：将多个函数调用封装在一个交易中执行（使用 </font>`<font style="color:rgb(68, 71, 70);">delegateCall</font>`<font style="color:rgb(31, 31, 31);">） </font><font style="color:rgb(31, 31, 31);">。</font>
+ **<font style="color:rgb(31, 31, 31);">通俗理解</font>**<font style="color:rgb(31, 31, 31);">：每一笔以太坊交易都有 </font>**<font style="color:rgb(31, 31, 31);">21,000 Gas 的起步费</font>**<font style="color:rgb(31, 31, 31);">。如果你要调 3 个函数，分 3 次调就要付 3 次起步费；用 MultiCall 打包，只需付 1 次起步费。同时还能保证这些调用在同一个区块、同一个状态下完成 </font><font style="color:rgb(31, 31, 31);">。</font>

<font style="color:rgb(31, 31, 31);"></font>

## <font style="color:rgb(31, 31, 31);">总结建议</font>
<font style="color:rgb(31, 31, 31);">如果你想写出“高手”级别的合约：</font>

1. **<font style="color:rgb(31, 31, 31);">能链下算就别链上算</font>**<font style="color:rgb(31, 31, 31);">（如排序、复杂搜索）。</font>
2. **<font style="color:rgb(31, 31, 31);">能验证就别存储</font>**<font style="color:rgb(31, 31, 31);">（如使用 Merkle Tree）。</font>
3. **<font style="color:rgb(31, 31, 31);">善用数据结构</font>**<font style="color:rgb(31, 31, 31);">（如用 Mapping 替代动态数组进行增删操作）。</font>
4. **<font style="color:rgb(31, 31, 31);">关注成熟的优化标准</font>**<font style="color:rgb(31, 31, 31);">（如 ERC721A、MultiCall）。</font>

