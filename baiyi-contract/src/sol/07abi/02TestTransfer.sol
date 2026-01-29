// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.2.0) (utils/Address.sol)

pragma solidity ^0.8.20;

/**
 * @dev Collection of functions related to the address type
 */
contract Address {
    function sendValue(address payable recipient, uint256 amount) internal {
        // 2300 gas 限制
        recipient.transfer(1 ether);

        // 没有限制
        (bool success, bytes memory returndata) = recipient.call{value: amount}(
            ""
        );
        if (!success) {
            revert("Address: call failed");
        }
    }
}
