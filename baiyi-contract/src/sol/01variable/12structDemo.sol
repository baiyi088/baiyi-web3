// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract testStruct {
    struct Person {
        address account;
        bool gender;
        uint8 age;
    }
    Person public chairman; // 定义变量

    function setChairman(address _acc, bool _g, uint8 _age) public {
        chairman = Person(_acc, _g, _age); // 创建变量
        // Person memory person = Person({gender: _g, account: _acc, age: _age}) ;
    }

    function getChairman() public view returns (address, bool, uint8) {
        return (chairman.account, chairman.gender, chairman.age); // 使用 . 获取成员
    }
}
