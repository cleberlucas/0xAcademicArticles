// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IACARSignature {
    function SIGNATURE() external pure returns (string memory signature);
}