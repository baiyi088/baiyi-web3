// • 与合约类似（一个特殊合约），是函数的封装，用于代码复用。 library 定义库
// • abstract 抽象合约是另一个代码复用的方式
// • 如果库函数都是 internal 的，库代码会嵌入到合约。
// • 如果库函数有external 或 public ，库需要单独部署，并在部署合约时进行链接，使用委托调用
// • 没有状态变量（library）
// • 不能给库发送 Ether （library）
// • （语法糖）给类型扩展功能：Using lib for type; 如： using SafeMath for uint;

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SafeMath {}

library SafeMath2 {}

contract TestLib {
    function add(uint x, uint y, uint z) internal pure returns (uint) {
        uint z = x + y;
        require(z >= x, "uint overflow");

        return z;
    }

    // using SafeMath for uint;
    // using SafeMath2 for uint;

    function add(uint x, uint y) external view returns (uint) {
        // return x.add(y);
        // return SafeMath.add(x, y);
    }

    function mm() public {
        // add(1, 2);  // internal
        this.add(1, 2);
    }
}
