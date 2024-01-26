// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIOStorageModel
 * @notice Library defining the storage model for the AIO (All In One) system.
 */
library AIOStorageModel {
    // Struct defining the token-related storage
    struct Token {   
        // Mapping from a signature to an array of associated token IDs
        mapping(string signature => bytes32[]) ids;

        // Mapping from a token ID to its associated signature
        mapping(bytes32 id => string) signature;

        // Mapping from a token ID to its associated metadata
        mapping(bytes32 id => bytes) metadata;
    }

    // Struct defining the interconnection-related storage
    struct Interconnection {  
        // Array containing all registered senders
        address[] senders;

        // Mapping from a sender's address to their associated signature
        mapping(address sender => string) signature;

        // Mapping from a signature to the associated sender's address
        mapping(string signature => address) sender;
    }
}