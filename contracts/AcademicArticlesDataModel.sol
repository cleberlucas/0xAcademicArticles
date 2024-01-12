// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library AcademicArticlesDataModel {  
    struct Article {
        bytes32[] tokens;
        mapping(bytes32 token => address) poster;
        mapping(bytes32 token => address) institutionStamp;
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address[]) affiliates;
    }
}
