// SPDX-License-Identifier: MIT
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";
import "../Extensions/RepositoryExtension.sol";
import "../Utils.sol";

pragma solidity >=0.8.22;

abstract contract ViewHandler is RepositoryExtension, Utils {
    function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) 
    public view 
    returns (bytes32[] memory result, uint256 size) {

        size = _institution.accounts.length;
        result = new bytes32[]((endIndex - startIndex + 1) > size ? size: (endIndex - startIndex + 1));

        for (uint256 i = 0; i < result.length; i++) {
            if (startIndex + i < _article.ids.length) {
                result[i] = _article.ids[(reverse ? (_article.ids.length - i - 1) : i)];  
            }                        
        }
    }

    function ArticlePoster(bytes32[] memory articleIds) 
    public view 
    returns (address[] memory result) {

        result = new address[](articleIds.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.poster[articleIds[i]];
        }
    }

    function ArticleInstitution(bytes32[] memory articleIds) 
    public view 
    returns (address[] memory result) {

        result = new address[](articleIds.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.institution[articleIds[i]];
        }
    }

    function ArticleContent(bytes32[] memory articleIds) 
    public view 
    returns (DelimitationLibrary.Article[] memory result) {

        result = new DelimitationLibrary.Article[](articleIds.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _article.content[articleIds[i]];
        }   
    }

    function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse)
    public view
    returns (address[] memory result, uint256 size){

        size = _institution.accounts.length;
        result = new address[]((endIndex - startIndex + 1) > size ? size: (endIndex - startIndex + 1));

        for (uint256 i = 0; i < result.length; i++) {
            if (startIndex + i < _institution.accounts.length) {
                 result[i] = _institution.accounts[(reverse ? (_institution.accounts.length - i - 1) : i)];       
            }
        }
    }

    function InstitutionAuthenticators(address[] memory institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) 
    public view 
    returns (address[][] memory result, uint256[] memory size) {
        
        result = new address[][](institutionAccounts.length);
        size = new uint256[](institutionAccounts.length);

        for (uint256 i = 0; i < result.length; i++) {
            size[i] = _institution.authenticators[institutionAccounts[i]].length;
            result[i] = new address[]((endIndex - startIndex + 1) > size[i] ? size[i]: (endIndex - startIndex + 1));
            
            for (uint256 ii = 0; ii < result[i].length; ii++) {
                if (startIndex + i < _institution.authenticators[institutionAccounts[i]].length) {
                    result[i][ii] = _institution.authenticators[institutionAccounts[i]][(reverse ? (_institution.authenticators[institutionAccounts[i]].length - ii - 1) : ii)];       
                }         
            }                 
        }         
    }
}


