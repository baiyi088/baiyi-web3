// SOLIDITY - 事件
// • 合约与外部世界的重要接口，通知外部世界链上状态的变化
// • 事件有时也作为便宜的存储，触发事情会在链上记录一个日志。
// • 使用关键字 event 定义事件，事件不需要实现
// • 事件中使用 indexed 修饰，表示对这个字段建立索引(也称为 Topic )，方便外部对该字段过滤查找
// • 使用关键字 emit 触发事件
// 外部系统可以直接监听

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract testDeposit {
    mapping(address => uint) public deposits;
    event Deposit(address indexed addr, uint value);

    function deposit(uint value) public {
        deposits[msg.sender] = value;
        emit Deposit(msg.sender, value);
    }
}

// web3.eth.getTransactionReceipt('0x....').then(console.log);
