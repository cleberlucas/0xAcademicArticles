// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IACARSearch.sol";
import "./ACARStorage.sol";

abstract contract ACARSearch is IACARSearch, ACARStorage {
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

    function ContractSignature(address contractAccount)
    public view
    returns (string memory contractSignature) {
        contractSignature = _contract.signature[contractAccount];
    }
}