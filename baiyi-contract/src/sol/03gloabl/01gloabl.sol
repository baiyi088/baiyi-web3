// • 区块和交易属性
// • 错误处理(require()/revert())
// • 数学及密码学函数
// • 类型信息（tyep(C). creationCode / type(T).min）
// • ABI 编码及解码函数
// • 地址及合约

// • block.number ( uint ): 当前区块号
// • block.timestamp ( uint): 自 unix epoch 起始当前区块以秒计的时间戳
// • msg.sender ( address ): 消息发送者（当前调用）
// • msg.value ( uint ): 随消息发送的 wei 的数量
// • tx.origin (address payable): 交易发起者（完全的调用链）

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract testOwner {
    address public owner;
    uint deposits;

    // mapping(address => uint) public deposits;

    constructor() payable {
        owner = msg.sender;
    }

    function deposit() public payable {
        deposits += msg.value;
    }

    receive() external payable {
        deposits += msg.value;
    }
}
