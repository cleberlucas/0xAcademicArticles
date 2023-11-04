// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ViewHandler is RepositoryExtension {
    
    function ArticleHashIdentifiers()
    public view
    returns (bytes32[] memory hashIdentifiers){

        hashIdentifiers = _article.hashIdentifiers;
    }

    function ArticleHashIdentifiers(uint256 startIndex, uint256 endIndex, bool reverse) 
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

    function ArticlePosters(bytes32[] memory hashIdentifiers) 
    public view 
    returns (address[] memory posters) {

        posters = new address[](hashIdentifiers.length);

        for (uint256 i = 0; i < posters.length; i++)
            posters[i] = _article.poster[hashIdentifiers[i]];
    }

    function ArticleInstitutions(bytes32[] memory hashIdentifiers) 
    public view 
    returns (address[] memory institutions) {

        institutions = new address[](hashIdentifiers.length);

        for (uint256 i = 0; i < institutions.length; i++)
            institutions[i] = _article.institution[hashIdentifiers[i]];
    }

    function ArticleContents(bytes32[] memory hashIdentifiers) 
    public view 
    returns (DelimitationLibrary.Article[] memory contents) {

        contents = new DelimitationLibrary.Article[](hashIdentifiers.length);

        for (uint256 i = 0; i < contents.length; i++)
            contents[i] = _article.content[hashIdentifiers[i]];
    }

    function InstitutionAccounts()
    public view
    returns (address[] memory accounts){
        
        accounts = _institution.accounts;
    }

    function InstitutionOwners(address[] memory accounts) 
    public view 
    returns (address[] memory owners) {

        owners = new address[](accounts.length);

        for (uint256 i = 0; i < owners.length; i++)
            owners[i] = _institution.owner[accounts[i]];
    }

    function InstitutionContents(address[] memory accounts) 
    public view 
    returns (DelimitationLibrary.Institution[] memory contents) {

        contents = new DelimitationLibrary.Institution[](accounts.length);

        for (uint256 i = 0; i < contents.length; i++)

            contents[i] = _institution.content[accounts[i]];
    }

    function AuthenticatorAccounts(address institution)
    public view
    returns (address[] memory accounts) {

        accounts = _authenticator.accounts[institution];
    }

    function AuthenticatorInstitutions(address[] memory accounts) 
    public view 
    returns (address[] memory institutions) {

        institutions = new address[](accounts.length);

        for (uint256 i = 0; i < institutions.length; i++)

            accounts[i] = _authenticator.institution[accounts[i]];
    }

}
