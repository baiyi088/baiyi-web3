// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// 编写一个 Bank 合约（代码提交到github）：
// • 通过 Metamask 向Bank合约存款（转账ETH）
// • 在Bank合约记录每个地址存款金额
// • 用数组记录存款金额前 3 名
// • 编写 Bank合约 withdraw(), 实现只有管理员提取出所有的 ETH
// 练习题
// https://decert.me/quests/c43324bc-0220-4e81-b533-668fa644c1c3

contract Bank {
    mapping(address => uint256) public balances;
    address[] public top3;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable virtual {
        balances[msg.sender] += msg.value;
        updateTop3(msg.sender);
    }

    function updateTop3(address user) internal {
        // 先把 user 放进去（可能重复）
        bool alreadyIn = false;
        for (uint i = 0; i < top3.length; i++) {
            if (top3[i] == user) {
                alreadyIn = true;
                break;
            }
        }
        if (!alreadyIn && top3.length < 3) {
            top3.push(user);
        }

        // 冒泡或直接排序（3个元素随便写）
        for (uint i = 0; i < top3.length; i++) {
            for (uint j = i + 1; j < top3.length; j++) {
                if (balances[top3[i]] < balances[top3[j]]) {
                    (top3[i], top3[j]) = (top3[j], top3[i]);
                }
            }
        }

        // 如果超过3个，砍掉最后一个（但因为我们控制了长度，通常不会）
        while (top3.length > 3) {
            top3.pop();
        }
    }

    function withdraw() public virtual {
        require(msg.sender == admin, "Only admin can withdraw");
        uint256 amount = address(this).balance;
        // 合约账户向管理员账户转账所有的 ETH
        // payable(admin).transfer(amount);
        (bool success, ) = admin.call{value: amount}("");
        require(success, "Transfer failed");
    }

    receive() external payable {
        deposit(); // 直接调用 deposit，记录余额 & 更新排行
    }

    fallback() external payable {
        deposit();
    }
}
