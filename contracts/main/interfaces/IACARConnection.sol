// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IACARConnection {
    function SIGNATURE() external pure returns (string memory signature);
    function Wipe() external payable;
}