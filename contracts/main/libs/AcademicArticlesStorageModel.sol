// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AcademicArticlesStorageModel {
    struct Article {   
        mapping(address contractAccount => bytes32[]) tokens;
        mapping(bytes32 token => address) contractAccount;
        mapping(bytes32 token => address) publisher;
        mapping(bytes32 token => bytes) data;
    }

    struct Contract {  
        address[] accounts;
        mapping(address account => string) signature;
    }
}