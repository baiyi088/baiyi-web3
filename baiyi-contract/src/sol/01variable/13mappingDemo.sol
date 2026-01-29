// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract MappingExample {
    // 声明形式： mapping(KeyType => ValueType) ， 例如：mapping(address => uint) public balances
    // 映射变量的使用方式类似数组，通过 key 访问，例如： balances[userAddr];
    //• 如果访问一个不存在的键，返回的是默认值。
    //• Public 的映射变量 生成带有参数的 getter 函数（访问器）

    mapping(address => uint) public balances;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }

    function get(address key) public view returns (uint) {
        return balances[key];
    }

    //    • 限制：
    //• 只能作为状态变量（storage）
    //• KeyType 不能是数组（string 和 bytes 是例外)
    //• 映射没有长度、没有 key 的集合或 value 的集合的概念
}
