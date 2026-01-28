// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {BigBank} from "./02BigBank.sol";

contract Admin {
    // 在 Admin 合约里
    BigBank public bigBank;

    constructor() {
        bigBank = new BigBank(address(this));
    }
}
