// SPDX-License-Identifier: MIT

import "./IAcademicArticlesRead.sol";
import "./AcademicArticlesData.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRead is IAcademicArticlesRead, AcademicArticlesData {
    function SearchArticlesId(uint256 startIndex, uint256 endIndex) 
    public view 
    returns (bytes32[] memory result, uint256 currentSize) {
        currentSize = _article.tokens.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new bytes32[](0);
        }
        else {
            uint256 count = endIndex - startIndex + 1;
            uint256 actualCount = (count <= currentSize - startIndex) ? count : currentSize - startIndex;

            result = new bytes32[](actualCount);

            for (uint256 i = 0; i < actualCount; i++) {
                result[i] = _article.tokens[startIndex + i];
            }
        }
    }

    function SearchArticlesPoster(bytes32[] memory articlesId) 
    public view 
    returns (address[] memory result) {
        result = new address[](articlesId.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.poster[articlesId[i]];
        }
    }

    function SearchArticlesInstitutionStamp(bytes32[] memory articlesId) 
    public view 
    returns (address[] memory result) {
        result = new address[](articlesId.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.institutionStamp[articlesId[i]];
        }
    }

    function SearchInstitutionsAccount(uint256 startIndex, uint256 endIndex)
    public view
    returns (address[] memory result, uint256 currentSize) {
        currentSize = _institution.accounts.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new address[](0);
        }
        else {
            uint256 count = endIndex - startIndex + 1;
            uint256 actualCount = (count <= currentSize - startIndex) ? count : currentSize - startIndex;

            result = new address[](actualCount);

            for (uint256 i = 0; i < actualCount; i++) {
                result[i] = _institution.accounts[startIndex + i];
            }
        }
    }


    function SearchInstitutionsAffiliates(address[] memory institutionsAccount, uint256 startIndex, uint256 endIndex) 
    public view 
    returns (address[][] memory result, uint256[] memory currentSize) {
        currentSize = new uint256[](institutionsAccount.length);
        result = new address[][](institutionsAccount.length);

        uint256 count;
        uint256 actualCount;

        for (uint256 i = 0; i < result.length; i++) {
            currentSize[i] = _institution.affiliates[institutionsAccount[i]].length;

            if (startIndex >= currentSize[i] || startIndex > endIndex) {
                result[i] = new address[](0);
            }
            else {
                count = endIndex - startIndex + 1;
                actualCount = (count <= currentSize[i] - startIndex) ? count : currentSize[i] - startIndex;

                result[i] = new address[](actualCount);

                for (uint256 ii = 0; ii < actualCount; ii++) {
                    result[i][ii] = _institution.affiliates[institutionsAccount[i]][startIndex + ii];       
                }         
            }                     
        }         
    }
}


