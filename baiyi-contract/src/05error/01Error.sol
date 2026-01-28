// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 在程序发生错误时的处理方式：EVM通过回退状态来处理错误的，以便保证状态修改的事务性
// assert() 和 require()用来进行条件检查，并在条件不满足时抛出异常
contract TestError {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function testRequire() public view {
        // assert() 和 require()用来进行条件检查，并在条件不满足时抛出异常
        // assert(): Panic ， 应对错误的代码
        assert(1 == 2);

        // require() ：检查合约调用者是否为合约所有者，否则抛出 NotOwner 错误
        require(msg.sender == owner, "Not owner");
    }

    // Error 定义错误 、 revert Error()
    error NotOwner();

    // revert(“msg”) ：终止运行并撤销状态更改
    function testAssert() public view {
        if (msg.sender != owner) revert NotOwner();
    }
}
