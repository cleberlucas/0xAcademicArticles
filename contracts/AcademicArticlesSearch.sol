// SPDX-License-Identifier: MIT

import "./IAcademicArticlesSearch.sol";
import "./AcademicArticlesData.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesSearch is IAcademicArticlesSearch, AcademicArticlesData {
    function ArticleTokens(uint256 startIndex, uint256 endIndex) 
    public view 
    returns (bytes32[] memory result, uint256 currentSize) {
        currentSize = _article.tokens.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new bytes32[](0);
        }
        else {
            uint256 size = endIndex - startIndex + 1;
            uint256 sizeUpdated = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            result = new bytes32[](sizeUpdated);

            for (uint256 i = 0; i < sizeUpdated; i++) {
                result[i] = _article.tokens[startIndex + i];
            }
        }
    }

    function ArticlePoster(bytes32[] memory articlesToken) 
    public view 
    returns (address[] memory result) {
        result = new address[](articlesToken.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.poster[articlesToken[i]];
        }
    }

    function ArticleInstitutionStamp(bytes32[] memory articlesToken) 
    public view 
    returns (address[] memory result) {
        result = new address[](articlesToken.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.institutionStamp[articlesToken[i]];
        }
    }

    function InstitutionAccounts(uint256 startIndex, uint256 endIndex)
    public view
    returns (address[] memory result, uint256 currentSize) {
        currentSize = _institution.accounts.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new address[](0);
        } 
        else {
            uint256 size = endIndex - startIndex + 1;
            uint256 sizeUpdated = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            result = new address[](sizeUpdated);

            for (uint256 i = 0; i < sizeUpdated; i++) {
                result[i] = _institution.accounts[startIndex + i];
            }
        }
    }

    function InstitutionAffiliates(address institutionsAccount, uint256 startIndex, uint256 endIndex) 
    public view 
    returns (address[] memory result, uint256 currentSize) {
        currentSize = _institution.affiliates[institutionsAccount].length;
  
        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new address[](0);
        }
        else {
            uint256 size = endIndex - startIndex + 1;
            uint256 sizeUpdated = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            result = new address[](sizeUpdated);

            for (uint256 i = 0; i < sizeUpdated; i++) {
                result[i] = _institution.affiliates[institutionsAccount][startIndex + i];       
            }         
        }                              
    }

    function ExternalContracts(uint256 startIndex, uint256 endIndex)
    public view
    returns (address[] memory result, uint256 currentSize) {
        currentSize = _external.contracts.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new address[](0);
        } 
        else {
            uint256 size = endIndex - startIndex + 1;
            uint256 sizeUpdated = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            result = new address[](sizeUpdated);

            for (uint256 i = 0; i < sizeUpdated; i++) {
                result[i] = _external.contracts[startIndex + i];
            }
        }
    }
}