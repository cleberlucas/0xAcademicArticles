// SPDX-License-Identifier: MIT
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";
import "../Extensions/RepositoryExtension.sol";
import "../Utils.sol";

pragma solidity >=0.8.22;

abstract contract ViewHandler is RepositoryExtension, Utils {
    function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) 
    public view 
    returns (bytes32[] memory articleIds) {

        articleIds = new bytes32[](endIndex - startIndex + 1);

        for (uint256 i = 0; i < articleIds.length; i++) {
            if (startIndex + i < _article.ids.length)
                articleIds[i] = _article.ids[(reverse ? (_article.ids.length - i - 1) : i)];       
            else 
                break;
        }
    }

    function ArticlePosters(bytes32[] memory articleIds) 
    public view 
    returns (address[] memory articlePosters) {

        articlePosters = new address[](articleIds.length);

        for (uint256 i = 0; i < articlePosters.length; i++)
            articlePosters[i] = _article.poster[articleIds[i]];
    }

    function ArticleAuthenticatingInstitutions(bytes32[] memory articleIds) 
    public view 
    returns (address[] memory articleAuthenticatingInstitutions) {

        articleAuthenticatingInstitutions = new address[](articleIds.length);

        for (uint256 i = 0; i < articleAuthenticatingInstitutions.length; i++)
            articleAuthenticatingInstitutions[i] = _article.authenticatingInstitution[articleIds[i]];
    }

    function ArticleContents(bytes32[] memory articleIds) 
    public view 
    returns (DelimitationLibrary.Article[] memory articleContents) {

        articleContents = new DelimitationLibrary.Article[](articleIds.length);

        for (uint256 i = 0; i < articleContents.length; i++)
            articleContents[i] = _article.content[articleIds[i]];
    }

    function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse)
    public view
    returns (address[] memory institutionAccounts){

        institutionAccounts = new address[](endIndex - startIndex + 1);

        for (uint256 i = 0; i < institutionAccounts.length; i++) {
            if (startIndex + i < _institution.accounts.length)
                institutionAccounts[i] = _institution.accounts[(reverse ? (_institution.accounts.length - i - 1) : i)];       
            else 
                break;
        }
    }

    function InstitutionAuthenticators(address[] memory institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) 
    public view 
    returns (address[][] memory institutionAuthenticators) {

        institutionAuthenticators = new address[][](institutionAccounts.length);

        for (uint256 i = 0; i < institutionAuthenticators.length; i++){
            institutionAuthenticators[i] = new address[](endIndex - startIndex + 1);

            for (uint256 ii = 0; ii < institutionAuthenticators[i].length; ii++)
                if (startIndex + i < _institution.authenticators[institutionAccounts[i]].length)
                    institutionAuthenticators[i][ii] = _institution.authenticators[institutionAccounts[i]][(reverse ? (_institution.authenticators[institutionAccounts[i]].length - ii - 1) : ii)];       
                else 
                    break;
                   
        }         
    }
    
    function InstitutionContents(address[] memory institutionAccounts) 
    public view 
    returns (DelimitationLibrary.Institution[] memory institutionContents) {

        institutionContents = new DelimitationLibrary.Institution[](institutionAccounts.length);

        for (uint256 i = 0; i < institutionContents.length; i++)
            institutionContents[i] = _institution.content[institutionAccounts[i]];
    }


}


