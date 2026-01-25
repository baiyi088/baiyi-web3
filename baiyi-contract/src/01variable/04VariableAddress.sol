// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 地址类型。
contract VariableAddress {
    // address：一个20字节的值
    address public owner;

    // address payable：表示可支付地址，可调用transfer和send
    address payable public ownerPayable;

    uint256 balance;

    // 为什么做区分？

    function test() public {
        // 1. 普通地址转为支付地址类型转换
        ownerPayable = payable(owner);

        //2. 成员函数的学习
        // <address>.balance(uint256)： 返回地址的余额
        balance = owner.balance;

        // <address payable>.transfer(uint256 amount)： 向地址发送以太币，失败时抛出异常 （gas：2300）
        ownerPayable.transfer(10);

        // <address payable>.send(uint256 amount) returns (bool): 向地址发送以太币，失败时返回false （gas：2300）
        bool result = ownerPayable.send(10);
    }

    // 测试转账
    function testTrasfer(address payable x) public {
        // 合约转换为地址类型
        address myAddress = address(this);
        if (myAddress.balance >= 10) {
            // 调用 x 的transfer 方法: 向 x 转10 wei
            x.transfer(10);
        }
    }
}
