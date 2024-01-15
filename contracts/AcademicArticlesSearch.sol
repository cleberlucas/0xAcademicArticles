// SPDX-License-Identifier: MIT

import "./IAcademicArticlesSearch.sol";
import "./AcademicArticlesData.sol";
import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesSearch is IAcademicArticlesSearch, AcademicArticlesData {

    function ArticleTokens(address externalContractAccount) 
    public view 
    returns (bytes32[] memory articleTokens) { 

        articleTokens = _article.tokens[externalContractAccount];
    }

    function ArticlePublisher(bytes32 articleToken) 
    public view 
    returns (address articlePublisher) {

        articlePublisher = _article.publisher[articleToken];
    }

    function ArticleEncode(bytes32 articleToken) 
    public view 
    returns (bytes memory articleEncode) {

        articleEncode = _article.encode[articleToken];
    }

    function ExternalContract()
    public view
    returns (AcademicArticlesDataModel.ExternalContract memory externalContract) {

        externalContract = _externalContract;
    }
}