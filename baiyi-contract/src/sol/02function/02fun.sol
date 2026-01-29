// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 函数的定义
// function 函数名([参数列表]) 可见性 [状态可变性] [返回值] {}
// 可见性关键字来控制函数是否可以被外部使用。
// 四种可见性：public(合约内/外) 、private(内部)、external(外部访问)、internal(内部及继承)
contract Counter {
    uint public data;

    function cal(uint a) public pure returns (uint b) {
        return a + 1;
    }

    function setData(uint a) internal {
        data = a;
    }
}
