// SPDX-License-Identifier: MIT

import "./IAcademicArticlesSearch.sol";
import "./AcademicArticlesData.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesSearch is IAcademicArticlesSearch, AcademicArticlesData {
    function ArticleTokens() 
    public view 
    returns (bytes32[] memory articleTokens) {    
        articleTokens = _article.tokens;
    }

    function ArticlePublisher(bytes32 articleToken) 
    public view 
    returns (address articlePublisher) {
        articlePublisher = _article.publisher[articleToken];
    }

    function ArticleAbi(bytes32 articleToken, address contractAccount) 
    public view 
    returns (string memory articleAbi) {
        articleAbi = _article.abi[articleToken][contractAccount];
    }

    function ExternalContracts()
    public view
    returns (address[] memory externalContracts) {
        externalContracts = _external.contracts;
    }
}