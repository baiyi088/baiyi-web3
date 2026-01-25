// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 变量类型学习
contract TestVariableBool {
    // bool类型
    bool public isOpen = true;
    bool public isChanged = false;

    function setOpen(bool o) public {
        isOpen = o;
        if (isOpen || tryChange()) {
            // 注意短路
            // ....
        }
    }

    function tryChange() internal returns (bool) {
        isChanged = !isChanged;
        return isChanged;
    }
}
