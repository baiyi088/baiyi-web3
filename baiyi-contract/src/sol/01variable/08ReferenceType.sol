// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 值类型赋值 = 拷贝 （Uint a = b;）
// 引用类型太大（>32个字节），拷贝开销很大，可使用“引用”方式，指向同一个变量。
// 引用类型太大， 不同的位置，不同的gas费用，需要有一个属性（memory、storage、calldata）来标识数据的存储位置:

// • memory（内存）: 生命周期只存在于函数调用期间
// • storage（存储）: 状态变量保存的位置，gas 开销最大
// • transient (瞬态存储）: 类似状态变量，但写入的值仅在一个交易内有效（仅支持值类型）
// • calldata（调用数据）: 用于函数参数不可变存储区域
// 不同的位置 赋值的时候做拷贝
