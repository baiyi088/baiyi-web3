// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 结构体映射组合使用
// 结构体成员是映射，映射的 Value 是结构体
contract MappingExample {
    struct Student {
        string name;
        mapping(string => uint) score; //使用较少
        int age;
    }
    struct Funder {
        address addr;
        uint amount;
    }
    mapping(uint => Funder) funders;
}
