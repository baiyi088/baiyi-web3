// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 定义一个枚举类型：enum 枚举名 { 成员 }
// 枚举成员从 0 编号、不能多于 256 个成员
contract TestEnum {
    enum Color {
        Red,
        White,
        Blue
    }
    Color color;

    function setColor(Color c) public {
        color = c;
    }

    function getMaxValue() public pure returns (Color) {
        return type(Color).max;
    }

    function getMinValue() public pure returns (Color) {
        return type(Color).min;
    }
}
