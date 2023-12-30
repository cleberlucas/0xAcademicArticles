// SPDX-License-Identifier: MIT

import "./IRead.sol";
import "./DataExt.sol";

pragma solidity ^0.8.23;

contract Read is IRead, DataExt {
    function SearchArticlesId(uint256 startIndex, uint256 endIndex) 
    public view 
    returns (bytes32[] memory result, uint256 currentSize) {

        currentSize = _article.ids.length;
        result = new bytes32[](endIndex - startIndex + 1);

        for (uint256 i = 0; i < result.length; i++) {
            if (startIndex + i < _article.ids.length) {
                result[i] = _article.ids[i];  
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

    function SearchArticlesValidatingInstitution(bytes32[] memory articlesId) 
    public view 
    returns (address[] memory result) {

        result = new address[](articlesId.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.validatingInstitution[articlesId[i]];
        }
    }

    function SearchArticlesContent(bytes32[] memory articlesId) 
    public view 
    returns (ModelLib.Article[] memory result) {

        result = new ModelLib.Article[](articlesId.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.content[articlesId[i]];
        }   
    }

    function SearchInstitutionsAccount(uint256 startIndex, uint256 endIndex)
    public view
    returns (address[] memory result, uint256 currentSize){

        currentSize = _institution.accounts.length;
        result = new address[](endIndex - startIndex + 1);

        for (uint256 i = 0; i < result.length; i++) {
            if (startIndex + i < _institution.accounts.length) {
                 result[i] = _institution.accounts[i];       
            }
        }
    }

    function SearchInstitutionsAffiliations(address[] memory institutionsAccount, uint256 startIndex, uint256 endIndex) 
    public view 
    returns (address[][] memory result, uint256[] memory currentSize) {
        
        result = new address[][](institutionsAccount.length);
        currentSize = new uint256[](result.length);

        for (uint256 i = 0; i < result.length; i++) {
            currentSize[i] = _institution.affiliations[institutionsAccount[i]].length;
            result[i] = new address[](endIndex - startIndex + 1);
            
            for (uint256 ii = 0; ii < result[i].length; ii++) {
                if (startIndex + ii < _institution.affiliations[institutionsAccount[i]].length) {
                    result[i][ii] = _institution.affiliations[institutionsAccount[i]][(ii)];       
                }         
            }                                
        }         
    }
}


