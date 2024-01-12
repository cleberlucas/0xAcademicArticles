// SPDX-License-Identifier: MIT

import "./AcademicArticlesUtils.sol";
import "./AcademicArticlesMessage.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRules is AcademicArticlesUtils {

    modifier IsOwner() {
        require(OWNER == msg.sender, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        require(IsInstitution_(msg.sender), AcademicArticlesMessage.INSTITUTION_ACTION);
        _;
    }

    modifier IsInstitutionOrAffiliate() {
        require(IsInstitution_(msg.sender) || InstitutionOfAffiliate(msg.sender) != address(0), AcademicArticlesMessage.AFFILIATE__INSTITUTION_ACTION);
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

    modifier IsNotEmptyAccountEntrie(address account) {       
        require(account != address(0), AcademicArticlesMessage.ACCOUNT_IS_EMPTY);
        _;
    }

    modifier IsInstitutionExist(address institutionAccount) {
        require(IsInstitution_(institutionAccount), AcademicArticlesMessage.INSTITUTION_WAS_NOT_EXIST);
        _;
    }

    modifier IsNotInstitutionExist(address institutionAccount) {
        require(!IsInstitution_(institutionAccount), AcademicArticlesMessage.INSTITUTION_ALREADY_EXIST);
        _;
    }

    modifier IsAffiliateExist(address affiliateAccount) {
        require(InstitutionOfAffiliate(affiliateAccount) != address(0), AcademicArticlesMessage.INSTITUTION_WAS_NOT_EXIST);
        _;
    }

    modifier IsNotAffiliateExist(address affiliateAccount) {
        require(InstitutionOfAffiliate(affiliateAccount) == address(0), AcademicArticlesMessage.AFFILIATE_ALREADY_EXIST);
        _;
    }

    modifier IsAffiliateLinkedInInstitution(address affiliateAccount) {
        require(InstitutionOfAffiliate(affiliateAccount) == msg.sender, AcademicArticlesMessage.AFFILIATE_WAS_NOT_LINKED_IN_INSTITUTION);
        _;
    }

    modifier IsArticleExist(bytes32 articleToken) { 
        require((_article.poster[articleToken] != address(0)), AcademicArticlesMessage.ARTICLE_WAS_NOT_EXIST);
        _;
    }

    modifier IsNotArticleExist(bytes32 articleToken) { 
        require((_article.poster[articleToken] == address(0)),  AcademicArticlesMessage.ARTICLE_ALREADY_EXIST);
        _;
    }

    modifier IsArticleValidated(bytes32 articleToken) {
        require((_article.institutionStamp[articleToken] != address(0)), AcademicArticlesMessage.ARTICLE_WAS_NOT_VALIDATED);
        _;
    }

    modifier IsNotArticleValidated(bytes32 articleToken) {
        require((_article.institutionStamp[articleToken] == address(0)), AcademicArticlesMessage.ARTICLE_ALREADY_VALIDATED);
        _;
    }

    modifier IsArticleMy(bytes32 articleToken) {
        require(_article.poster[articleToken] == msg.sender, AcademicArticlesMessage.ARTICLE_NOT_YOURS);
        _;
    }

    modifier IsArticleValidatedByInstitution(bytes32 articleToken){
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliate(msg.sender);
        }

        require(_article.institutionStamp[articleToken] == institution, AcademicArticlesMessage.ARTICLE_WAS_NOT_VALIDATED_BY_YOUR_INSTITUTION);
        _;
    }
}
