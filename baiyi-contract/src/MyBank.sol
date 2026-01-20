// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyBank {
    // bank合约，别人可以来存钱。
    // 1. 合约部署时，需要指定一个token地址。
    // 2. 合约部署时，需要指定一个管理员地址。
    // 3. 管理员可以给用户授权。
    // 4. 用户可以向合约转账token。
    // 5. 用户可以从合约转账token。
    function deposit(address _token, uint256 _amount) external {
        ERC20(_token).transferFrom(msg.sender, address(this), _amount);
    }
}
