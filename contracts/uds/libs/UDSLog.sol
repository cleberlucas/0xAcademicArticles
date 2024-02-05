// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library UDSLog {
    event MetadataSended(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key, bytes32 metadata);
    event MetadataUpdated(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key, bytes32 metadata);
    event MetadataCleaned(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed key);
    event SenderSigned(bytes32 indexed signature, address sender);
    event SignatureTransferred(bytes32 indexed signature, address sender);
}