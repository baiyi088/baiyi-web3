// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// • 类型声明（函数的抽象），广泛用于合约之间的调用
// • 无任何实现的函数
// • 不能继承自其他接口
// • 没有构造方法
// • 没有状态变量
interface ICounter {
    function count() external view returns (uint);

    function increment() external;
}

contract Counter is ICounter {
    uint public count;

    function increment() external {
        count += 1;
    }
}

contract MyContract {
    function incrementCounter(address _counter) external {
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}
