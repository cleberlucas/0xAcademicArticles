// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ViewHandler is RepositoryExtension {
    function ArticlesHashIdentifiers()
    public view 
    returns (bytes32[] memory hashIdentifiers) {

        hashIdentifiers = _article.hashIdentifiers;
    }

    function ArticlesHashIdentifiers(uint256 startIndex, uint256 endIndex, bool reverse) 
    public view 
    returns (bytes32[] memory hashIdentifiers) {

        hashIdentifiers = new bytes32[](endIndex - startIndex + 1);

        for (uint256 i = 0; i < hashIdentifiers.length; i++) {
            if (startIndex + i < _article.hashIdentifiers.length)
                hashIdentifiers[i] = _article.hashIdentifiers[(reverse ?  (_article.hashIdentifiers.length - i - 1)   : i)];       
            else 
                break;
        }
    }

    function ArticlesPosters(bytes32[] memory hashIdentifiers) 
    public view 
    returns (address[] memory posters) {

        posters = new address[](hashIdentifiers.length);

        for (uint256 i = 0; i < posters.length; i++)
            posters[i] = _article.poster[hashIdentifiers[i]];
    }

    function ArticlesInstitutions(bytes32[] memory hashIdentifiers) 
    public view 
    returns (address[] memory institutions) {

        institutions = new address[](hashIdentifiers.length);

        for (uint256 i = 0; i < institutions.length; i++)
            institutions[i] = _article.institution[hashIdentifiers[i]];
    }

    function ArticlesContents(bytes32[] memory hashIdentifiers) 
    public view 
    returns (DelimitationLibrary.Article[] memory contents) {

        contents = new DelimitationLibrary.Article[](hashIdentifiers.length);

        for (uint256 i = 0; i < contents.length; i++)
            contents[i] = _article.content[hashIdentifiers[i]];
    }

    function InstitutionsAccounts()
    public view
    returns (address[] memory accounts){
        
        accounts = _institution.accounts;
    }

    function InstitutionsContents(address[] memory accounts) 
    public view 
    returns (DelimitationLibrary.Institution[] memory contents) {

        contents = new DelimitationLibrary.Institution[](accounts.length);

        for (uint256 i = 0; i < contents.length; i++)
            contents[i] = _institution.content[accounts[i]];
    }


    function InstitutionsAuthenticators(address[] memory institutions) 
    public view 
    returns (address[][] memory authenticators) {

        authenticators = new address[][](institutions.length);

        for (uint256 i = 0; i < authenticators.length; i++){
            authenticators[i] = new address[](_institution.authenticators[institutions[i]].length);
            for (uint256 ii = 0; ii < authenticators[i].length; ii++)
                authenticators[i][ii] = _institution.authenticators[institutions[i]][ii];
        }         
    }

}
