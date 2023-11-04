// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils/ModifierUtil.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ModifierExtension is RepositoryExtension, ModifierUtil {

    modifier IsOwner() {
        Require(OWNER == msg.sender, ErrorMessageLibrary.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        Require(_institution.owner[msg.sender] == OWNER, ErrorMessageLibrary.INSTITUTION_ACTION);
        _;
    }

    modifier IsAuthenticator() {
         Require(_authenticator.institution[msg.sender] != address(0), ErrorMessageLibrary.AUTHENTICATOR_ACTION);
        _;
    }

    modifier AreValidAddress(address[] memory validateAddresses) {
        for (uint256 i = 0; i < validateAddresses.length; i++) 
            Require(
                validateAddresses[i] != address(0), 
                ErrorMessageLibrary.ONE_OF_NOT_VALID_ADDRESSES
            );
        _;
    }

    modifier IsInstitutionRegistered(address account, bool registered, string memory messageOnError) {
        Require((_institution.owner[account] == OWNER) == registered, messageOnError);
        _;
    }

    modifier AreInstitutionRegistered(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            Require(
                _institution.owner[accounts[i]] == OWNER, 
                ErrorMessageLibrary.INSTITUTION_WAS_NOT_REGISTERED
            );
        _;
    }

    modifier AreAuthenticatorBindedInInstitution(address[] memory accounts, bool binded, string memory messageOnError) {
        for (uint256 i = 0; i < accounts.length; i++) 
            Require(
                (_authenticator.institution[accounts[i]] == msg.sender) == binded, 
                messageOnError
            );
        _;
    }

    modifier AreSameInstitutionBindedArticle(bytes32[] memory hashIdentifiers){
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
            Require( 
                _authenticator.institution[_article.institution[hashIdentifiers[i]]] == _authenticator.institution[msg.sender],   
                ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_NOT_BELONG_INSTITUTION_BINDED
            );
        _;
    }

    modifier AreArticlePosted(bytes32[] memory hashIdentifiers, bool posted, string memory messageOnError) { 
        for (uint256 i = 0; i < hashIdentifiers.length; i++)     
            Require(
                (_article.poster[hashIdentifiers[i]] != address(0)) == posted, 
                messageOnError
            );
        _;
    }

    modifier AreArticleAuthenticated(bytes32[] memory hashIdentifiers, bool authenticated, string memory messageOnError) {
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
            Require(
                (_article.poster[hashIdentifiers[i]] != address(0)) == authenticated, 
                messageOnError
            );
        _;
    }

    modifier AreArticleMy(bytes32[] memory hashIdentifiers) {
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
            Require(
                _article.poster[hashIdentifiers[i]] == msg.sender, 
                ErrorMessageLibrary.ONE_OF_ARTICLES_NOT_YOURS
            );
        _;
    }
}
