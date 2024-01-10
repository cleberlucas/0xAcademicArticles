// SPDX-License-Identifier: MIT

import "./AcademicArticlesModelLib.sol";

pragma solidity ^0.8.23;

library AcademicArticlesDataLib {  
    struct Article {
        bytes32[] ids;
        mapping(bytes32 id => address) poster;
        mapping(bytes32 id => address) institutionStamp;
        mapping(bytes32 id => AcademicArticlesModelLib.Article) content; 
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address[]) affiliates;
    }
}
