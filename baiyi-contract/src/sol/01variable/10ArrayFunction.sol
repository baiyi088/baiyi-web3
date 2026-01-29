// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 数组类型
contract TestArray {
    // • length 属性：表示当前数组的长度
    // • push()：添加新的零初始化元素到数组末尾，返回引用
    // • push(x)： 动态数组末尾添加一个给定的元素
    // • pop(): 从数组末尾删除元素

    uint[10] tens;
    uint[] public numbers;

    function copy(uint[] calldata arrs) public returns (uint len) {
        numbers = arrs;
        return numbers.length;
    }

    function test(uint len) public pure {
        string[4] memory adaArr = ["This", "is", "an", "array"];
        uint[] memory c = new uint[](len);
    }

    function add(uint x) public {
        numbers.push(x);
    }
}
