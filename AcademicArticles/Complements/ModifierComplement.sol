// SPDX-License-Identifier: MIT

import "./RepositoryComplement.sol";
import "./UtilsComplement.sol";
import "../Librarys/MessageLibrary.sol";

pragma solidity ^0.8.23;

abstract contract ModifierComplement is RepositoryComplement, UtilsComplement {

    modifier IsOwner() {
        require(OWNER == msg.sender, MessageLibrary.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        require(IsInstitution_(msg.sender), MessageLibrary.INSTITUTION_ACTION);
        _;
    }

    modifier IsInstitutionOrAuthenticator() {
        require(IsInstitution_(msg.sender) || InstitutionOfAuthenticator(msg.sender) != address(0), MessageLibrary.INSTITUTION_AUTHENTICATOR_ACTION);
        _;
    }

    modifier AreNotInstitution(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            require(!IsInstitution_(accounts[i]), MessageLibrary.ONE_OF_ACCOUNTS_IS_A_INSTITUTION);
        _;
    }

    modifier AreNotAuthenticator(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            require(InstitutionOfAuthenticator(accounts[i]) == address(0), MessageLibrary.ONE_OF_ACCOUNTS_IS_A_AUTHENTICATOR);
        _;
    }

    modifier AreNotEmptyAccountEntrie(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            require(accounts[i] != address(0), MessageLibrary.ONE_OF_ACCOUNTS_IS_EMPTY);
        _;
    }

    modifier AreNotDuplicatedAccountEntrie(address[] memory accounts) {
        for (uint i = 0; i < accounts.length; i++) {
            for (uint j = i + 1; j < accounts.length; j++) {
                if (accounts[i] == accounts[j]) {
                    require(false, MessageLibrary.ONE_OF_ACCOUNTS_IS_DUPLICATED);
                }
            }
        }
        _;
    }

    modifier AreNotDuplicatedArticleEntrie(bytes32[] memory articleids) {
        for (uint i = 0; i < articleids.length; i++) {
            for (uint j = i + 1; j < articleids.length; j++) {
                if (articleids[i] == articleids[j]) {
                    require(false, MessageLibrary.ONE_OF_ARTICLES_IS_DUPLICATED);
                }
            }
        }
        _;
    }

    modifier IsInstitutionRegistered(address institutionAccount, bool registered, string memory messageOnError) {
        require(IsInstitution_(institutionAccount) == registered, messageOnError);
        _;
    }

    modifier AreInstitutionRegistered(address[] memory institutionAccounts, bool registered, string memory messageOnError) {
        for (uint256 i = 0; i < institutionAccounts.length; i++) 
            require(IsInstitution_(institutionAccounts[i]) == registered, messageOnError);
        _;
    }

    modifier AreBindedInInstitution(address[] memory authenticatorAccounts) {
        for (uint256 i = 0; i < authenticatorAccounts.length; i++)
            require((InstitutionOfAuthenticator(authenticatorAccounts[i]) == msg.sender), MessageLibrary.ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION);              
        _;
    }

    modifier AreNotBindedToAnInstitution(address[] memory authenticatorAccounts) {
        for (uint256 i = 0; i < authenticatorAccounts.length; i++) 
            require(InstitutionOfAuthenticator(authenticatorAccounts[i]) == address(0), MessageLibrary.ONE_OF_AUTHENTICATORS_ALREADY_BINDED_TO_AN_INSTITUTION);              
        _;
    }

    modifier AreArticleAuthenticatedByInstitution(bytes32[] memory articleIds){
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAuthenticator(msg.sender);
        }

        for (uint256 i = 0; i < articleIds.length; i++) 
           require(_article.institution[articleIds[i]] == institution, MessageLibrary.ONE_OF_THE_ARTICLES_WAS_NOT_AUTHENTICATED_BY_INSTITUTION);
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
            require(_article.poster[ArticleIds[i]] == msg.sender,MessageLibrary.ONE_OF_ARTICLES_NOT_YOURS);
        _;
    }
}
