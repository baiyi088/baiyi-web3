// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "forge-std/console.sol";

// Console.log 最多支持 4 个参数、4 个类型：uint、string、bool、address
// • 还有一些变种函数：
// • console.logInt(int i)
// • console.logString(string memory s)
// • console.logBytes1()、 console.logBytes2(bytes2 b) …
// • 支持打印格式化内容: %s, %d
// • console.log("Changing owner from %s to %s", currentOwner, newOwner)
// • 在测试网、主网上执行时，无效，但会消耗 gas
// https://getfoundry.sh/reference/forge-std/console-log/

// 被调用时，将在控制台打印出日志
contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        number = newNumber;
        console.log("Number set to", number);
    }

    function increment() public {
        number++;
        console.log("Number incremented to", number);
    }
}
