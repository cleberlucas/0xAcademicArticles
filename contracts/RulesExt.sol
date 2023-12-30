// SPDX-License-Identifier: MIT

import "./UtilsExt.sol";
import "./MessageLib.sol";

pragma solidity ^0.8.23;

abstract contract RulesExt is DataExt, UtilsExt {

    modifier IsOwner() {
        require(OWNER == msg.sender, MessageLib.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        require(IsInstitution_(msg.sender), MessageLib.INSTITUTION_ACTION);
        _;
    }

    modifier IsInstitutionOrAffiliation() {
        require(IsInstitution_(msg.sender) || InstitutionOfAffiliation(msg.sender) != address(0), MessageLib.INSTITUTION_AFFILIATION_ACTION);
        _;
    }

    modifier AreNotInstitution(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) 
            require(!IsInstitution_(accounts[i]), MessageLib.ONE_OF_ACCOUNTS_IS_A_INSTITUTION);
        _;
    }

    modifier AreNotAffiliation(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) {
            require(InstitutionOfAffiliation(accounts[i]) == address(0), MessageLib.ONE_OF_ACCOUNTS_IS_A_AFFILIATION);
        }
        _;
    }

    modifier AreNotEmptyAccountEntrie(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) {
            require(accounts[i] != address(0), MessageLib.ONE_OF_ACCOUNTS_IS_EMPTY);
        }
        _;
    }

    modifier AreNotDuplicatedAccountEntrie(address[] memory accounts) {
        for (uint i = 0; i < accounts.length; i++) {
            for (uint j = i + 1; j < accounts.length; j++) {
                if (accounts[i] == accounts[j]) {
                    require(false, MessageLib.ONE_OF_ACCOUNTS_IS_DUPLICATED);
                }
            }
        }
        _;
    }

    modifier AreNotDuplicatedArticleEntrie(bytes32[] memory articlesId) {
        for (uint i = 0; i < articlesId.length; i++) {
            for (uint j = i + 1; j < articlesId.length; j++) {
                if (articlesId[i] == articlesId[j]) {
                    require(false, MessageLib.ONE_OF_ARTICLES_IS_DUPLICATED);
                }
            }
        }
        _;
    }

    modifier AreInstitutionRegistered(address[] memory institutionsAccount) {
        for (uint256 i = 0; i < institutionsAccount.length; i++) {
            require(IsInstitution_(institutionsAccount[i]), MessageLib.ONE_OF_INSTITUTION_ALREADY_REGISTERED);
        }
        _;
    }

    modifier AreInstitutionNotRegistered(address[] memory institutionsAccount) {
        for (uint256 i = 0; i < institutionsAccount.length; i++) {
            require(!IsInstitution_(institutionsAccount[i]), MessageLib.ONE_OF_INSTITUTION_WAS_NOT_REGISTERED);
        }
        _;
    }

    modifier AreLinkedInInstitution(address[] memory affiliationsAccount) {
        for (uint256 i = 0; i < affiliationsAccount.length; i++) {
            require((InstitutionOfAffiliation(affiliationsAccount[i]) == msg.sender), MessageLib.ONE_OF_AFFILIATIONS_WAS_NOT_LINKED_IN_INSTITUTION);              
        }
        _;
    }

    modifier AreNotLinkedToAnInstitution(address[] memory affiliationsAccount) {
        for (uint256 i = 0; i < affiliationsAccount.length; i++) 
            require(InstitutionOfAffiliation(affiliationsAccount[i]) == address(0), MessageLib.ONE_OF_AFFILIATIONS_ALREADY_LINKED_TO_AN_INSTITUTION);              
        _;
    }

    modifier AreArticleValidatedByInstitution(bytes32[] memory articlesId){
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliation(msg.sender);
        }

        for (uint256 i = 0; i < articlesId.length; i++) {
            require(_article.validatingInstitution[articlesId[i]] == institution, MessageLib.ONE_OF_THE_ARTICLES_WAS_NOT_VALIDATED_BY_INSTITUTION);
        } 
        _;
    }

    modifier AreArticlePosted(bytes32[] memory articlesId) { 
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.poster[articlesId[i]] != address(0)), MessageLib.ONE_OF_ARTICLES_WAS_NOT_PUBLISHED);
        }
        _;
    }

    modifier AreArticleNotPosted(bytes32[] memory articlesId) { 
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.poster[articlesId[i]] == address(0)),  MessageLib.ONE_OF_ARTICLES_ALREADY_PUBLISHED);
        }
        _;
    }

    modifier AreArticleValidated(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.validatingInstitution[articlesId[i]] != address(0)), MessageLib.ONE_OF_ARTICLES_WAS_NOT_VALIDATED);
        }
        _;
    }

    modifier AreArticleNotValidated(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.validatingInstitution[articlesId[i]] == address(0)), MessageLib.ONE_OF_ARTICLES_ALREADY_VALIDATED);
        }
        _;
    }

    modifier AreArticleMy(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            require(_article.poster[articlesId[i]] == msg.sender,MessageLib.ONE_OF_ARTICLES_NOT_YOURS);
        }
        _;
    }
}
