// SPDX-License-Identifier: MIT

import "./ModelLib.sol";

pragma solidity ^0.8.23;

library DataLib {  
    struct Article {
        bytes32[] ids;
        mapping(bytes32 id => address) poster;
        mapping(bytes32 id => address) institutionStamp;
        mapping(bytes32 id => ModelLib.Article) content; 
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address[]) affiliates;
    }
}
