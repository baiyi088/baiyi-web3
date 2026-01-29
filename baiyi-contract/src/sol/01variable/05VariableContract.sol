// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 地址类型。
contract VariableAddress {
    // 创建合约可使用 New 关键字
    // 每个合约都是一个类型，可声明一个合约类型。
    //如：Counter c; 则可以使用c.count() 调用函数
    Counter counter;

    function test() public {
        counter = new Counter();
        counter.count;
        // 合约类型可以显式转换为address类型，从而可以使用地址类型的成员函数。
    }
}

contract Counter {
    function count() public {}
}
