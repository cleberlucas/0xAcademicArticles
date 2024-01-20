// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library ERCXStorageModel {
    struct Data {   
        mapping(string signature => bytes32[]) tokens;
        mapping(bytes32 token => string) signature;
        mapping(bytes32 token => bytes) metadata;
    }

    struct Interconnection {  
        address[] senders;
        mapping(address sender => string) signature;
        mapping(string signature => address) sender;
    }
}