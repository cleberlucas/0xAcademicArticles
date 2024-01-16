// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AcademicArticlesDataModel {

    struct Article {   
        mapping(address interconnectionContract => bytes32[]) tokens;
        mapping(bytes32 token => address) publisher;
        mapping(bytes32 token => bytes) encoded;
    }

    struct Interconnection {  
        address[] contracts;
    }
}