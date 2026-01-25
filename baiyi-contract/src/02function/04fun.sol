// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 函数体
// 由表达式和控制语句构成
// for/if/else/while/do/
// break/continue/return
//
// 没有 goto/switch
contract Counter {
    function testFor() public pure {
        for (uint256 i = 0; i < 10; i++) {
            if (i == 3) {
                continue; // 忽略下一次循环
            }
            if (i == 5) {
                break; // 退出
            }
        }
    }

    function testWhile() public pure returns (uint) {
        uint256 i;
        while (i < 10) {
            i++;
            if (i == 5 || i == 8) {
                // …
            }
        }
        return i;
    }
}
