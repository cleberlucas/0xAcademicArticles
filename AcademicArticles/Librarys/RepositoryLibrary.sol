// SPDX-License-Identifier: MIT
import "./DelimitationLibrary.sol";

pragma solidity >=0.8.22;

library RepositoryLibrary {  
    struct Article {
        bytes32[] hashIdentifiers;
        mapping(bytes32 hashIdentifier => address) poster;
        mapping(bytes32 hashIdentifier => address) authenticatingInstitution;
        mapping(bytes32 hashIdentifier => DelimitationLibrary.Article) content; 
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address[]) authenticators;
        mapping(address account => DelimitationLibrary.Institution) content;
    }
}
