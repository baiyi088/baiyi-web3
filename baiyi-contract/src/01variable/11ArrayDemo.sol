// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 数组类型
contract TestArrayDemo {
    uint[10] numbers;

    constructor() {
        numbers[0] = 1;
        numbers[1] = 2;
        numbers[2] = 3;
        numbers[3] = 4;
        numbers[4] = 5;
    }

    function dosome() public {
        uint len = numbers.length;
        for (uint i = 0; i < len; i++) {
            // do...
        }
    }

    function remove(uint index) public {
        uint len = numbers.length;
        if (index == len - 1) {
            // numbers.pop();
            // break;
        } else {
            numbers[index] = numbers[len - 1];
            // numbers.pop();
            // break;
        }
    }
}
