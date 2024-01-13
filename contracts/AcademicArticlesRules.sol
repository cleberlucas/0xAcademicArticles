// SPDX-License-Identifier: MIT

import "./AcademicArticlesUtils.sol";
import "./AcademicArticlesMessage.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRules is AcademicArticlesUtils {
    modifier IsOwner() {
        require(OWNER == tx.origin, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        require(IsInstitution_(tx.origin), AcademicArticlesMessage.INSTITUTION_ACTION);
        _;
    }

    modifier IsInstitutionOrAffiliate() {
        require(IsInstitution_(tx.origin) || InstitutionOfAffiliate(tx.origin) != address(0), AcademicArticlesMessage.AFFILIATE__INSTITUTION_ACTION);
        _;
    }

    modifier IsContract() {
        require(IsContract_(msg.sender), AcademicArticlesMessage.CONTRACT_ACTION);
        _;
    }

    modifier IsNotInstitution(address account) {
        require(!IsInstitution_(account), AcademicArticlesMessage.ACCOUNT_IS_INSTITUTION);
        _;
    }

    modifier IsNotAffiliate(address account) {     
        require(InstitutionOfAffiliate(account) == address(0), AcademicArticlesMessage.ACCOUNT_IS_AFFILIATE);
        _;
    }

    modifier IsContractAccountEntrie(address account) {
        uint32 size;
        assembly {
            size := extcodesize(account)
        }
        require (size > 0, AcademicArticlesMessage.ACCOUNT_WAS_NOT_CONTRACT);
        _;
    }

    modifier IsNotEmptyAccountEntrie(address account) {       
        require(account != address(0), AcademicArticlesMessage.ACCOUNT_IS_EMPTY);
        _;
    }

    modifier IsContractAdded(address contractAccount) {
        require(IsInstitution_(contractAccount), AcademicArticlesMessage.CONTRACT_WAS_NOT_ADDED);
        _;
    }

    modifier IsNotContractAdded(address contractAccount) {
        require(IsInstitution_(contractAccount), AcademicArticlesMessage.CONTRACT_ALREADY_ADDED);
        _;
    }

    modifier IsArticlePublished(bytes32 articleToken) { 
        require((_article.poster[articleToken] != address(0)), AcademicArticlesMessage.ARTICLE_WAS_NOT_PUBLISHED);
        _;
    }

    modifier IsNotArticlePublished(bytes32 articleToken) { 
        require((_article.poster[articleToken] == address(0)),  AcademicArticlesMessage.ARTICLE_ALREADY_PUBLISHED);
        _;
    }

    modifier IsArticleStamped(bytes32 articleToken) {
        require((_article.institutionStamp[articleToken] != address(0)), AcademicArticlesMessage.ARTICLE_WAS_NOT_STAMPED);
        _;
    }

    modifier IsNotArticleStamped(bytes32 articleToken) {
        require((_article.institutionStamp[articleToken] == address(0)), AcademicArticlesMessage.ARTICLE_ALREADY_STAMPED);
        _;
    }

    modifier IsArticleMy(bytes32 articleToken) {
        require(_article.poster[articleToken] == tx.origin, AcademicArticlesMessage.ARTICLE_NOT_YOURS);
        _;
    }

    modifier IsInstitutionRegistered(address institutionAccount) {
        require(IsInstitution_(institutionAccount), AcademicArticlesMessage.INSTITUTION_WAS_NOT_REGISTERED);
        _;
    }

    modifier IsNotInstitutionRegistered(address institutionAccount) {
        require(!IsInstitution_(institutionAccount), AcademicArticlesMessage.INSTITUTION_ALREADY_REGISTERED);
        _;
    }

    modifier IsAffiliateLinked(address affiliateAccount) {
        require(InstitutionOfAffiliate(affiliateAccount) != address(0), AcademicArticlesMessage.AFFILIATE_WAS_NOT_LINKED);
        _;
    }

    modifier IsNotAffiliateLinked(address affiliateAccount) {
        require(InstitutionOfAffiliate(affiliateAccount) == address(0), AcademicArticlesMessage.AFFILIATE_ALREADY_LINKED);
        _;
    }

    modifier IsAffiliateLinkedInInstitution(address affiliateAccount) {
        require(InstitutionOfAffiliate(affiliateAccount) == tx.origin, AcademicArticlesMessage.AFFILIATE_WAS_NOT_LINKED_IN_INSTITUTION);
        _;
    }

    modifier IsArticleStampedByInstitution(bytes32 articleToken){
        address institution;
        
        if (IsInstitution_(tx.origin)) {
            institution = tx.origin;
        }
        else {
            institution = InstitutionOfAffiliate(tx.origin);
        }

        require(_article.institutionStamp[articleToken] == institution, AcademicArticlesMessage.ARTICLE_WAS_NOT_STAMPED_BY_YOUR_INSTITUTION);
        _;
    }
}