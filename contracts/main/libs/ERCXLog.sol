// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library ERCXLog {
    event MetaDataSended(bytes32 indexed token);
    event MetaDataCleaned(bytes32 indexed token);
    event SenderSigned(address indexed sender);
    event SignatureTransferred(address indexed newSender);
}