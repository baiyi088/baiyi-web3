// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    // 状态变量
    uint256 public number;

    constructor() {
        number = 0;
    }

    //添加事件日志记录，用于跟踪number变量的变化
    event NumberSet(uint256 newNumber);

    // 合约函数
    function setNumber(uint256 newNumber) public {
        number = newNumber;
        //触发NumberSet事件，记录新的number值
        emit NumberSet(newNumber);
    }

    function increment() public {
        number++;
    }
}
