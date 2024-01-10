// SPDX-License-Identifier: MIT

import "./AcademicArticlesUtils.sol";
import "./AcademicArticlesMessageLib.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRules is AcademicArticlesUtils {

    modifier IsOwner() {
        require(OWNER == msg.sender, AcademicArticlesMessageLib.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        require(IsInstitution_(msg.sender), AcademicArticlesMessageLib.INSTITUTION_ACTION);
        _;
    }

    modifier IsInstitutionOrAffiliate() {
        require(IsInstitution_(msg.sender) || InstitutionOfAffiliate(msg.sender) != address(0), AcademicArticlesMessageLib.AFFILIATE__INSTITUTION_ACTION);
        _;
    }

    modifier AreNotEmptyAccountEntrie(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) {
            require(accounts[i] != address(0), AcademicArticlesMessageLib.ONE_OF_ACCOUNTS_IS_EMPTY);
        }
        _;
    }

    modifier AreNotDuplicatedAccountEntrie(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) {
            for (uint256 p = i + 1; p < accounts.length; p++) {
                require(accounts[i] != accounts[p], AcademicArticlesMessageLib.ONE_OF_ACCOUNTS_IS_DUPLICATED);
            }
        }
        _;
    }

    modifier AreNotDuplicatedArticleEntrie(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            for (uint256 p = i + 1; p < articlesId.length; p++) {
                require(articlesId[i] != articlesId[p], AcademicArticlesMessageLib.ONE_OF_ARTICLES_IS_DUPLICATED);
            }
        }
        _;
    }

    modifier AreNotInstitution(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) {
            require(!IsInstitution_(accounts[i]), AcademicArticlesMessageLib.ONE_OF_ACCOUNTS_IS_A_INSTITUTION);
        }
        _;
    }

    modifier AreNotAffiliate(address[] memory accounts) {
        for (uint256 i = 0; i < accounts.length; i++) {
            require(InstitutionOfAffiliate(accounts[i]) == address(0), AcademicArticlesMessageLib.ONE_OF_ACCOUNTS_IS_A_AFFILIATE);
        }
        _;
    }

    modifier AreAffiliateLinkedInInstitution(address[] memory affiliatesAccount) {
        for (uint256 i = 0; i < affiliatesAccount.length; i++) {
            require(InstitutionOfAffiliate(affiliatesAccount[i]) == msg.sender, AcademicArticlesMessageLib.ONE_OF_AFFILIATES_WAS_NOT_LINKED_IN_INSTITUTION);
        }
        _;
    }

    modifier AreInstitutionExist(address[] memory institutionsAccount) {
        for (uint256 i = 0; i < institutionsAccount.length; i++) {
            require(IsInstitution_(institutionsAccount[i]), AcademicArticlesMessageLib.ONE_OF_INSTITUTIONS_WAS_NOT_EXIST);
        }
        _;
    }

    modifier AreNotInstitutionExist(address[] memory institutionsAccount) {
        for (uint256 i = 0; i < institutionsAccount.length; i++) {
            require(!IsInstitution_(institutionsAccount[i]), AcademicArticlesMessageLib.ONE_OF_INSTITUTIONS_ALREADY_EXIST);
        }
        _;
    }

    modifier AreAffiliateExist(address[] memory affiliatesAccount) {
        for (uint256 i = 0; i < affiliatesAccount.length; i++) {
            require(InstitutionOfAffiliate(affiliatesAccount[i]) != address(0), AcademicArticlesMessageLib.ONE_OF_AFFILIATES_WAS_NOT_EXIST);
        }
        _;
    }

    modifier AreNotAffiliateExist(address[] memory affiliatesAccount) {
          for (uint256 i = 0; i < affiliatesAccount.length; i++) {
            require(InstitutionOfAffiliate(affiliatesAccount[i]) == address(0), AcademicArticlesMessageLib.ONE_OF_AFFILIATES_ALREADY_EXIST);
        }
        _;
    }

    modifier AreArticleExist(bytes32[] memory articlesId) { 
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.poster[articlesId[i]] != address(0)), AcademicArticlesMessageLib.ONE_OF_ARTICLES_WAS_NOT_EXIST);
        }
        _;
    }

    modifier AreNotArticleExist(bytes32[] memory articlesId) { 
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.poster[articlesId[i]] == address(0)),  AcademicArticlesMessageLib.ONE_OF_ARTICLES_ALREADY_EXIST);
        }
        _;
    }

    modifier AreArticleValidated(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.institutionStamp[articlesId[i]] != address(0)), AcademicArticlesMessageLib.ONE_OF_ARTICLES_WAS_NOT_VALIDATED);
        }
        _;
    }

    modifier AreNotArticleValidated(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            require((_article.institutionStamp[articlesId[i]] == address(0)), AcademicArticlesMessageLib.ONE_OF_ARTICLES_ALREADY_VALIDATED);
        }
        _;
    }

    modifier AreArticleMy(bytes32[] memory articlesId) {
        for (uint256 i = 0; i < articlesId.length; i++) {
            require(_article.poster[articlesId[i]] == msg.sender, AcademicArticlesMessageLib.ONE_OF_ARTICLES_NOT_YOURS);
        }
        _;
    }

    modifier AreArticleValidatedByInstitution(bytes32[] memory articlesId){
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliate(msg.sender);
        }

        for (uint256 i = 0; i < articlesId.length; i++) {
            require(_article.institutionStamp[articlesId[i]] == institution, AcademicArticlesMessageLib.ONE_OF_THE_ARTICLES_WAS_NOT_VALIDATED_BY_INSTITUTION);
        } 
        _;
    }
}
