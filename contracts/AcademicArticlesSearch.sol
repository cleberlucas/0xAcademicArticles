// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IAcademicArticlesSearch.sol";
import "./AcademicArticlesStorage.sol";

abstract contract AcademicArticlesSearch is IAcademicArticlesSearch, AcademicArticlesStorage {
    function ArticleTokens(address contractAccount) 
    public view 
    returns (bytes32[] memory articleTokens) {
        articleTokens = _article.tokens[contractAccount];
    }

    function ArticlePublisher(bytes32 articleToken) 
    public view 
    returns (address articlePublisher) {
        articlePublisher = _article.publisher[articleToken];
    }

    function ArticleData(bytes32 articleToken) 
    public view 
    returns (bytes memory articleData) {
        articleData = _article.data[articleToken];
    }

    function ContractAccounts()
    public view
    returns (address[] memory contractAccounts) {
        contractAccounts = _contract.accounts;
    }

    function ContractName(address contractAccount)
    public view
    returns (string memory contractName) {
        contractName = _contract.name[contractAccount];
    }
}