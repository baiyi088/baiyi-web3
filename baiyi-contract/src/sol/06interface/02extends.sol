// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 和大多数高级语言一样，Solidity 也支持继承
// • 使用关键字 is
// • 继承时，链上实际只有一个合约被创建，基类合约的代码会被编译进派生合约。
// • 派生合约可以访问基类合约内的所有非私有（private）成员，因此内部（internal）函数和状态变量在派生合约里是可以直接使用的

contract A {
    uint public a;

    constructor() {
        a = 1;
    }
}

// 在部署B时候，可以查看到a为1，b为2。
contract B is A {
    uint public b;

    constructor() {
        b = 2;
    }
}
