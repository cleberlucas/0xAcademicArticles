// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./IAcademicArticlesSearch.sol";
import "./AcademicArticlesData.sol";
import "./AcademicArticlesDataModel.sol";

abstract contract AcademicArticlesSearch is IAcademicArticlesSearch, AcademicArticlesData {

    function ArticleTokens(address connectedContract) 
    public view 
    returns (bytes32[] memory articleTokens) {
        articleTokens = _article.tokens[connectedContract];
    }

    function ArticlePublisher(bytes32 articleToken) 
    public view 
    returns (address articlePublisher) {
        articlePublisher = _article.publisher[articleToken];
    }

    function ArticleEncoded(bytes32 articleToken) 
    public view 
    returns (bytes memory articleEncoded) {
        articleEncoded = _article.encoded[articleToken];
    }

    function Connected()
    public view
    returns (AcademicArticlesDataModel.Connected memory connected) {
        connected = _connected;
    }
}