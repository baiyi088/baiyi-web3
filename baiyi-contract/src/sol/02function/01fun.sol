// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 函数的定义
// function 函数名([参数列表]) 可见性 [状态可变性] [返回值] {}
contract Counter {
    uint public counter;

    // 定义函数
    function count(uint i) public {
        counter = counter + i;
    }
}
