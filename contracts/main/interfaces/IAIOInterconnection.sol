// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAIOInterconnection {
    function Initialize() external payable;
    function TransferSignature(address newSender) external payable;
}