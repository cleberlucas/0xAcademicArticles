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

    modifier IsNotEmptyAccount(address account) {
            Require(account != address(0), ErrorMessageLibrary.ACCOUNT_IS_EMPTY);
        _;
    }

    modifier AreNotEmptyAccount(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            Require(accounts[i] != address(0), ErrorMessageLibrary.ONE_OF_ACCOUNTS_IS_EMPTY);
        _;
    }

    modifier IsInstitutionRegistered(address institutionAccount, bool registered, string memory messageOnError) {
        Require(ExistInstitution(institutionAccount) == registered, messageOnError);
        _;
    }

    modifier AreInstitutionRegistered(address[] memory institutionAccounts) {
        for (uint256 i = 0; i < institutionAccounts.length; i++) 
            Require(ExistInstitution(institutionAccounts[i]), ErrorMessageLibrary.ONE_OF_INSTITUTION_WAS_NOT_REGISTERED);
        _;
    }

    modifier AreAuthenticatorBindedInInstitution(address[] memory authenticatorAccounts) {
        for (uint256 i = 0; i < authenticatorAccounts.length; i++)
            Require((SearchInstitutionOfAuthenticator(authenticatorAccounts[i]) == msg.sender), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION);              
        _;
    }

    modifier AreAuthenticatorBindedNoAnyInstitution(address[] memory authenticatorAccounts) {
        for (uint256 i = 0; i < authenticatorAccounts.length; i++) 
            Require(SearchInstitutionOfAuthenticator(authenticatorAccounts[i]) == address(0), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_ALREADY_BINDED_TO_AN_INSTITUTION);              
        _;
    }

    modifier AreSameInstitutionAuthenticatedArticle(bytes32[] memory articleIds){
        bool result = true;
        for (uint256 i = 0; i < articleIds.length; i++) 
           Require(_article.authenticatingInstitution[articleIds[i]] == SearchInstitutionOfAuthenticator(msg.sender), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_NOT_BELONG_INSTITUTION_BINDED);
        _;
    }

    modifier AreArticlePosted(bytes32[] memory articleIds, bool posted, string memory messageOnError) { 
        for (uint256 i = 0; i < articleIds.length; i++)     
            Require((_article.poster[articleIds[i]] != address(0)) == posted, messageOnError);
        _;
    }

    modifier AreArticleAuthenticated(bytes32[] memory articleIds, bool authenticated, string memory messageOnError) {
        for (uint256 i = 0; i < articleIds.length; i++) 
            Require((_article.authenticatingInstitution[articleIds[i]] != address(0)) == authenticated, messageOnError);
        _;
    }

    modifier AreArticleMy(bytes32[] memory ArticleIds) {
        for (uint256 i = 0; i < ArticleIds.length; i++) 
            Require(_article.poster[ArticleIds[i]] == msg.sender,ErrorMessageLibrary.ONE_OF_ARTICLES_NOT_YOURS);
        _;
    }
}
