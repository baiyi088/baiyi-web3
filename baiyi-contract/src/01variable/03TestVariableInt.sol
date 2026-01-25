// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 变量类型学习
contract TestVariableInt {
    // 在使用整型时，要特别注意整型的大小及所能容纳的最大值和最小值， 如uint8的最大值为0xﬀ（255），最小值是0
    // 从 solidity 0.6.0 版本开始可以通过 Type(T).min 和 Type(T).max 获得整型的最小值与最大值。
    // 整型： int/uint , uint8、uint16、 … uint256

    // 预测一下2个函数分别的结果是什么？ 为什么？
    // 出现了算数溢出
    function add1() public pure returns (uint8) {
        uint8 x = 128;
        uint8 y = x * 2;
        return y;
    }

    // 出现了算数溢出
    function add2() public pure returns (uint8) {
        uint8 i = 240;
        uint8 j = 16;
        uint8 k = i + j;
        return k;
    }
}
