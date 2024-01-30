// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IUDSWrite {
    function Sign(bytes32 signature) external;
    function TransferSignature(address sender) external;
    function SendMetadata(bytes32 classification, bytes32 key, bytes calldata metadata) external;
    function UpdateMetadata(bytes32 classification, bytes32 key, bytes calldata metadata) external;
    function CleanMetadata(bytes32 classification, bytes32 key) external;
}