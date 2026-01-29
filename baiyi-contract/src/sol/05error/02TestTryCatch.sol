// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// try/catch: 捕获合约中外部调用的异常
// 即便是不存在的函数调用也可以捕获
// 例外：
// • 无法捕获对不存在的合约调用（对一个不存在的合约的调用，EVM 不会执行）
// • 注意：out of gas 错误不是程序异常，错误不能捕获。

contract Foo {
    function myFunc(uint x) public pure returns (uint) {
        require(x != 0, "require failed");
        return x + 1;
    }
}

contract trycatch {
    Foo public foo;
    uint public y;

    constructor() {
        foo = new Foo();
    }

    function tryCatchExternalCall(uint _i) public {
        try foo.myFunc(_i) returns (uint result) {
            y = result;
        } catch {
            // ..
        }
    }
}
