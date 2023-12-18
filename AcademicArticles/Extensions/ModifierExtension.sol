// SPDX-License-Identifier: MIT
import "../Librarys/RepositoryLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ModifierExtension is RepositoryExtension, Utils {

    modifier IsOwner() {
        require(OWNER == msg.sender, ErrorMessageLibrary.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        require(ExistInstitution(msg.sender), ErrorMessageLibrary.INSTITUTION_ACTION);
        _;
    }

    modifier IsAuthenticator() {
        require(InstitutionOfAuthenticator(msg.sender) != address(0), ErrorMessageLibrary.AUTHENTICATOR_ACTION);
        _;
    }

    modifier AreNotEmptyAccountEntrie(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            require(accounts[i] != address(0), ErrorMessageLibrary.ONE_OF_ACCOUNTS_ENTRIES_IS_EMPTY);
        _;
    }

    modifier AreNotDuplicatedAccountEntrie(address[] memory accounts) {
        for (uint i = 0; i < accounts.length; i++) {
            for (uint j = i + 1; j < accounts.length; j++) {
                if (accounts[i] == accounts[j]) {
                    require(false, ErrorMessageLibrary.ONE_OF_ACCOUNTS_ENTRIES_IS_DUPLICATED);
                }
            }
        }
        _;
    }

    modifier AreNotDuplicatedArticleEntrie(bytes32[] memory articleids) {
        for (uint i = 0; i < articleids.length; i++) {
            for (uint j = i + 1; j < articleids.length; j++) {
                if (articleids[i] == articleids[j]) {
                    require(false, ErrorMessageLibrary.ONE_OF_ARTICLES_ENTRIES_IS_DUPLICATED);
                }
            }
        }
        _;
    }

    modifier IsInstitutionRegistered(address institutionAccount, bool registered, string memory messageOnError) {
        require(ExistInstitution(institutionAccount) == registered, messageOnError);
        _;
    }

    modifier AreInstitutionRegistered(address[] memory institutionAccounts, bool registered, string memory messageOnError) {
        for (uint256 i = 0; i < institutionAccounts.length; i++) 
            require(ExistInstitution(institutionAccounts[i]) == registered, messageOnError);
        _;
    }

    modifier AreAuthenticatorBindedInInstitution(address[] memory authenticatorAccounts) {
        for (uint256 i = 0; i < authenticatorAccounts.length; i++)
            require((InstitutionOfAuthenticator(authenticatorAccounts[i]) == msg.sender), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION);              
        _;
    }

    modifier AreAuthenticatorBindedNoAnyInstitution(address[] memory authenticatorAccounts) {
        for (uint256 i = 0; i < authenticatorAccounts.length; i++) 
            require(InstitutionOfAuthenticator(authenticatorAccounts[i]) == address(0), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_ALREADY_BINDED_TO_AN_INSTITUTION);              
        _;
    }

    modifier AreSameInstitutionAuthenticatedArticle(bytes32[] memory articleIds){
        for (uint256 i = 0; i < articleIds.length; i++) 
           require(_article.institution[articleIds[i]] == InstitutionOfAuthenticator(msg.sender), ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_NOT_BELONG_INSTITUTION_BINDED);
        _;
    }

    modifier AreArticlePosted(bytes32[] memory articleIds, bool posted, string memory messageOnError) { 
        for (uint256 i = 0; i < articleIds.length; i++)     
            require((_article.poster[articleIds[i]] != address(0)) == posted, messageOnError);
        _;
    }

    modifier AreArticleAuthenticated(bytes32[] memory articleIds, bool authenticated, string memory messageOnError) {
        for (uint256 i = 0; i < articleIds.length; i++) 
            require((_article.institution[articleIds[i]] != address(0)) == authenticated, messageOnError);
        _;
    }

    modifier AreArticleMy(bytes32[] memory ArticleIds) {
        for (uint256 i = 0; i < ArticleIds.length; i++) 
            require(_article.poster[ArticleIds[i]] == msg.sender,ErrorMessageLibrary.ONE_OF_ARTICLES_NOT_YOURS);
        _;
    }
}
