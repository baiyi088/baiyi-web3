// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 数组类型
contract ArrayType {
    // • T[k] : 元素类型为T，固定长度为k的数组
    uint[10] tens;

    // • T[ ] : 元素类型为T，长度动态调整
    uint[] public numbers;

    // • bytes、string 是一种特殊的数组
    bytes a;
    string str;

    // • 数组通过下标进行访问，序号是从0开始
    // • tens[0], numbers[1]
    function read() public view returns (uint) {
        return numbers[1];
    }
}
