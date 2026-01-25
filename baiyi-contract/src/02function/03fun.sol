// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 函数的定义
// function 函数名([参数列表]) 可见性 [状态可变性] [返回值] {}

// 状态可变性(可多个)
// • View：表示函数只读取状态 （不需要支付手续费）
// • pure：表示函数不读取状态、也不写（状态）， 仅计算
// • payable: 表示函数可接收以太币
// • 接收的 ETH 值，用 msg.value 获取
// • 自定义修改器 （modifier）
contract Counter {
    uint private counter;
    uint private deposited;

    // 当义函数： function  函数名([参数列表])  可见性  [可变性]  [返回值]  {}
    // 可见性： public / private / internal / external
    // 可变性: view / pure / payable

    function increase() public {
        counter = counter + 1;
    }

    // view  不修改状态
    function addTo(uint256 y) public view returns (uint256) {
        return counter + y;
    }

    // pure
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j;
    }

    function deposit() public payable {
        deposited += msg.value;
    }
}
