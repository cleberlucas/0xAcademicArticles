// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AIOStorageModel {
    struct Token {   
        mapping(string signature => bytes32[]) ids;
        mapping(bytes32 id => string) signature;
        mapping(bytes32 id => bytes) metadata;
    }

    struct Interconnection {  
        address[] senders;
        mapping(address sender => string) signature;
        mapping(string signature => address) sender;
    }
}