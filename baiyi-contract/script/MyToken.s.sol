// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "./BaseScript.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract MyTokenScript is BaseScript {
    MyToken public myToken;

    function run() public broadcaster {
        myToken = new MyToken("MyToken", "MTK");
        console.log("MyToken deployed on %s", address(myToken));

        saveContract("MyToken", address(myToken));
    }
}
