// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IERCXInterconnection {
    function Initialize() external payable;
    function TransferSignature(address newSender) external payable;
}