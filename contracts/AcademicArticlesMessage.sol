// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library AcademicArticlesMessage {
    string public constant OWNER_ACTION = "owner action";
    string public constant INSTITUTION_ACTION = "institution action";
    string public constant AFFILIATE__INSTITUTION_ACTION = "affiliate/institution action";
    string public constant ACCOUNT_IS_INSTITUTION = "account is an institution";
    string public constant ACCOUNT_IS_AFFILIATE = "account is an affiliate";
    string public constant ACCOUNT_IS_EMPTY = "account is empty";
    string public constant INSTITUTION_ALREADY_EXIST = "institution already exists";
    string public constant INSTITUTION_WAS_NOT_EXIST = "institution was not exist";
    string public constant AFFILIATE_ALREADY_EXIST = "affiliate already exists";
    string public constant AFFILIATE_WAS_NOT_EXIST = "affiliate was not exist";
    string public constant AFFILIATE_WAS_NOT_LINKED_IN_INSTITUTION = "affiliate was not linked in institution";
    string public constant ARTICLE_ALREADY_EXIST = "article already exists";
    string public constant ARTICLE_WAS_NOT_EXIST = "article was not exist";
    string public constant ARTICLE_ALREADY_VALIDATED = "article already validated";
    string public constant ARTICLE_WAS_NOT_VALIDATED = "article was not validated";
    string public constant ARTICLE_NOT_YOURS = "article not yours";
    string public constant ARTICLE_WAS_NOT_VALIDATED_BY_YOUR_INSTITUTION = "article was not validated by institution";
}

