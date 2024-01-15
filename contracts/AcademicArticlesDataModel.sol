// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library AcademicArticlesDataModel {

    struct Article {   
        mapping(address externalContractAccount => bytes32[]) tokens;
        mapping(bytes32 token => address) publisher;
        mapping(bytes32 token => bytes) encode;
    }

    struct ExternalContract {  
        address[] accounts;
    }
}