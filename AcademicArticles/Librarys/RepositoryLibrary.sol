// SPDX-License-Identifier: AFL-3.0
import "./DelimitationLibrary.sol";

pragma solidity >=0.8.22;

library RepositoryLibrary {  
    struct Article {
        bytes32[] hashIdentifiers;
        mapping(bytes32 hashIdentifier => address) poster;
        mapping(bytes32 hashIdentifier => address) authenticator;
        mapping(bytes32 hashIdentifier => DelimitationLibrary.Article) content; 
    }

    struct Institution {
        address[] accounts;
        mapping(address account => address) owner;
        mapping(address account => DelimitationLibrary.Institution) content;
    }

    struct Authenticator {
        mapping(address institution => address[]) accounts;
        mapping(address account => address) institution;
    }
}
