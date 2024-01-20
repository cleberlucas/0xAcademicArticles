// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IERCXInteract {
    function SendMetaData(bytes calldata metadata) external payable;
    function CleanMetaData(bytes32 token) external payable;
}