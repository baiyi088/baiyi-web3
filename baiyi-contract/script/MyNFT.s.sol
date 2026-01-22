// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

import "./BaseScript.s.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract MyNftScript is BaseScript {
    MyNFT public myNft;

    function run() public {
        vm.startBroadcast();

        myNft = new MyNFT("MyNFT", "MNFT");
        console.log("MyNFT deployed on %s", address(myNft));
        saveContract("MyNFT", address(myNft));

        vm.stopBroadcast();
    }
}
