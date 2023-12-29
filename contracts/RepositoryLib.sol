// SPDX-License-Identifier: MIT

import "./DelimitationLib.sol";

pragma solidity ^0.8.23;

library RepositoryLib {  
    struct Article {
        bytes32[] ids;
        mapping(bytes32 id => address) poster;
        mapping(bytes32 id => address) institution;
        mapping(bytes32 id => DelimitationLib.Article) content; 
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address[]) authenticators;
    }
}
