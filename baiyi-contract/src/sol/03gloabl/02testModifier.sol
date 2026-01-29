// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 用修改器修饰一个函数， 用来添加函数的行为，如检查输入条件、控制访问、重入控制
contract testModifier {
    address public owner;
    uint private deposited;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(deposited);
    }
}
