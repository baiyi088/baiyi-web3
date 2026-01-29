// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 自定义类型
// • 定义一个自定义类型：type UserType is ValueType;
// • 让类型有含义， wrap() / unwrap() 用来和底层类型的转换
contract testUserDefinedType {
    type Duration is uint256;
    type Timestamp is uint256;

    function TimePassed(
        Timestamp curr,
        Duration pass
    ) public view returns (Timestamp) {
        uint t = Timestamp.unwrap(curr) + Duration.unwrap(pass);
        return Timestamp.wrap(t);
    }
}
