// SPDX-License-Identifier: MIT
import "../Librarys/RepositoryLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ModifierExtension is RepositoryExtension, Utils {

    modifier IsOwner() {
        Require(OWNER == msg.sender, ErrorMessageLibrary.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        Require(ExistInstitution(msg.sender), ErrorMessageLibrary.INSTITUTION_ACTION);
        _;
    }

    modifier IsAuthenticator() {
        Require(SearchInstitutionOfAuthenticator(msg.sender) != address(0), ErrorMessageLibrary.AUTHENTICATOR_ACTION);
        _;
    }

    modifier AreNotEmptyAddress(address[] memory addresses) {
        for (uint256 i = 0; i < addresses.length; i++) 
            Require(addresses[i] != address(0), ErrorMessageLibrary.ONE_OF_ADDRESSES_IS_EMPTY);
        _;
    }

    modifier IsInstitutionRegistered(address account, bool registered, string memory messageOnError) {
        Require(ExistInstitution(account) == registered, messageOnError);
        _;
    }

    modifier AreInstitutionRegistered(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            Require(ExistInstitution(accounts[i]), ErrorMessageLibrary.ONE_OF_INSTITUTION_WAS_NOT_REGISTERED);
        _;
    }

    modifier AreAuthenticatorBindedInInstitution(address[] memory accounts) {
        for (uint256 i = 0; i < _institution.accounts.length; i++) 
            Require((SearchInstitutionOfAuthenticator(_institution.accounts[i]) == msg.sender), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION);              
        _;
    }

    modifier AreAuthenticatorBindedNoAnyInstitution(address[] memory accounts) {
        for (uint256 i = 0; i < _institution.accounts.length; i++) 
            Require(SearchInstitutionOfAuthenticator(_institution.accounts[i]) == address(0), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_ALREADY_BINDED_IN_INSTITUTION);              
        _;
    }

    modifier AreSameInstitutionAuthenticatedArticle(bytes32[] memory hashIdentifiers){
        bool result = true;
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
           Require(_article.authenticatingInstitution[hashIdentifiers[i]] == SearchInstitutionOfAuthenticator(msg.sender), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_NOT_BELONG_INSTITUTION_BINDED);
        _;
    }

    modifier AreArticlePosted(bytes32[] memory hashIdentifiers, bool posted, string memory messageOnError) { 
        for (uint256 i = 0; i < hashIdentifiers.length; i++)     
            Require((_article.poster[hashIdentifiers[i]] != address(0)) == posted, messageOnError);
        _;
    }

    modifier AreArticleAuthenticated(bytes32[] memory hashIdentifiers, bool authenticated, string memory messageOnError) {
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
            Require((_article.poster[hashIdentifiers[i]] != address(0)) == authenticated, messageOnError);
        _;
    }

    modifier AreArticleMy(bytes32[] memory hashIdentifiers) {
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
            Require(_article.poster[hashIdentifiers[i]] == msg.sender,ErrorMessageLibrary.ONE_OF_ARTICLES_NOT_YOURS);
        _;
    }
}
