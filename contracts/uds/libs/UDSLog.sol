// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library UDSLog {
    event MetadataSended(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key);
    event MetadataUpdated(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key);
    event MetadataCleaned(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key);
    event SenderSigned(address indexed sender);
    event SignatureTransferred(address indexed newSender);
}