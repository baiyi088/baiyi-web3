// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Bank} from "./01Bank_V1.sol";

// • 编写一个 BigBank 合约继承自 Bank，要求：
// • 仅 >0.001 ether（用 modifier 权限控制）可以存款
// • 把管理员转移给 Admin 合约，Admin 调用 BigBank 的 withdraw().
// 练习题
// https://decert.me/quests/063c14be-d3e6-41e0-a243-54e35b1dde58
contract BigBank is Bank {

    constructor(address _admin){
        admin = _admin;
    }

    modifier onlyDeposit(uint256 _amount) {
        require(_amount > 0.01 ether, "No balance");
        _;
    }

    function deposit() public payable override onlyDeposit(msg.value) {
        super.deposit();
    }

    function withdraw() public override {
        super.withdraw();
    }
}
