// SPDX-License-Identifier: MIT
import "./DelimitationLibrary.sol";

pragma solidity ^0.8.23;

library RepositoryLibrary {  
    struct Article {
        bytes32[] ids;
        mapping(bytes32 id => address) poster;
        mapping(bytes32 id => address) institution;
        mapping(bytes32 id => DelimitationLibrary.Article) content; 
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address[]) authenticators;
    }
}
