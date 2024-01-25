// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AIOLog {
    event MetadataSended(bytes32 indexed id);
    event MetadataCleaned(bytes32 indexed id);
    event SenderSigned(address indexed sender);
    event SignatureTransferred(address indexed newSender);
}