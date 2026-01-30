// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// 导入Test合约: 提供了基本的日志和断言功能
import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    // 每个测试用例运行前都会运行
    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    // 前缀test 的函数作为测试用例运行
    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    // [PASS] testFuzz_SetNumber(uint256) (runs: 256, μ: 28144, ~: 30477)
    // 运行256次，每次平均耗时28144 gas，中位数耗时30477 gas
    // testFuzz 模糊测试：测试用例的参数值，由 foundry 随机抽样
    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
