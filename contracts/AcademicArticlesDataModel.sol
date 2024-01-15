// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library AcademicArticlesDataModel {

    struct Article {   
        bytes32[] tokens;
        mapping(bytes32 token => address) publisher;
        mapping(bytes32 token => mapping(address externalContractAccount => bytes)) encode;
    }

    struct ExternalContract {  
        address[] accounts; 
    }
}