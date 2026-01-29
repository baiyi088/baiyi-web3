// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 抽象合约
// • abstract 抽象合约
// • 不能被部署， 可包含没有实现的纯虚函数
// • super：调用父合约函数
// • virtual： 表示函数可以被重写
// • overide： 表示重写了父合约函数

abstract contract A {
    uint public a;

    function add(uint x) public virtual;
}

contract B is A {
    uint public b;

    constructor() {
        b = 2;
    }

    function add(uint x) public virtual override {
        b += x;
    }
}

contract C is B {
    function add(uint x) public virtual override {
        super.add(x);
        b += x;
    }
}
