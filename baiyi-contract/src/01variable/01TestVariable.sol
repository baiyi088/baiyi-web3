// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// https://github.com/OpenSpace100/blockchain-tasks/tree/main/solidity_sample_code

// 变量的定义
contract TestVariable {
    //1. 状态变量 格式：变量类型 [可见性] [可变状态] 变量名 [赋值];
    uint256 public number;
    uint256 private number1;
    uint256 internal number2;
    // constant：不可修改的变量，使用硬编码
    uint256 public constant number3 = 1;
    // 不可修改的变量，在构造时赋值
    uint256 public immutable number4;

    //2. 可见性：public【合约内外】、private【合约内部】、internal【内部及继承】
    // public 的变量会生成一个同名的函数（称为 getter 访问器）
    //3. 可变状态：类似java中的final关键字， constant：不可修改的变量，使用硬编码 immutable: 不可修改的变量，在构造时赋值
    //4. 赋值：可以在定义时赋值，也可以在构造函数中赋值

    constructor() {
        number = 0;
        // number3=3;
        number4 = 2;
    }

    // 合约函数
    function setNumber(uint256 newNumber) public {
        // 本地变量
        uint256 a = 503;
        number = newNumber + a;
    }
}
