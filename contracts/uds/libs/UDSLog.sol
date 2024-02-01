// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library UDSLog {
    event MetadataSended(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key, bytes32 metadata);
    event MetadataUpdated(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key, bytes32 metadata);
    event MetadataCleaned(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key);
    event SenderSigned(address indexed sender, bytes32 signature);
    event SignatureTransferred(address indexed sender, bytes32 signature);
}