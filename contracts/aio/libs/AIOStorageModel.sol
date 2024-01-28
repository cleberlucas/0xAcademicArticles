// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AIOStorageModel {
    struct Interconnection {  
        address[] senders;
        mapping(address sender => bytes32) signature;
        mapping(bytes32 signature => address) sender;
    }

    struct Token {   
        mapping(bytes32 signature => bytes32[]) classifications;
        mapping(bytes32 signature => mapping(bytes32 classification => bytes32[])) keys;
        mapping(bytes32 signature => mapping(bytes32 classification => mapping(bytes32 key => bytes))) metadata;
    }
}