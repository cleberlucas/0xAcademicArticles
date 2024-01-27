// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAIOSignature {
    function SIGNATURE() external pure returns (bytes32 signature);
}