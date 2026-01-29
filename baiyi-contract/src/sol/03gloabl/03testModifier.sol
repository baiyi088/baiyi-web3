// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 函数修改器是一个语法糖（编译期间扩展到函数的实现）
// 可以用私有函数实现类似效果
contract testModifier {
    modifier over22(uint age) {
        require(age >= 22, "too small age");
        _;
    }

    function marry(uint age) public over22(age) {
        // do something
    }
}
