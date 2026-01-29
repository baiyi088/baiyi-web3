// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// HARDHAT - 链接外部库

contract test{
    const ExLib = await hre.ethers.getContractFactory("Library");
    const lib = await ExLib.deploy();
    await lib.deployed();

    
    await hre.ethers.getContractFactory("TestExLib", {
    libraries: {
    Library: lib.address,
    },})
}