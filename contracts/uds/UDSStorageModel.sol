// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title UDSStorageModel
 * @dev Library defining the storage model for Unified Data Storage (UDS).
 * @notice This library includes two main structs: Interconnection and Token.
 */
library UDSStorageModel {
    
    struct Interconnection {  
        address[] senders;                              // Array containing the addresses of all senders.
        mapping(address sender => bytes32) signature;   // Mapping from sender address to their associated signature.
        mapping(bytes32 signature => address) sender;   // Mapping from signature to the corresponding sender address.
    }

    struct Data {   
        mapping(bytes32 signature => bytes32[]) classifications;                                                   // Mapping from signature to an array of classifications.
        mapping(bytes32 signature => mapping(bytes32 classification => bytes32[])) ids;                            // Mapping from signature and classification to an array of ids.
        mapping(bytes32 signature => mapping(bytes32 classification => mapping(bytes32 id => bytes))) metadata;    // Mapping from signature, classification, and id to actual metadata.
    }
}