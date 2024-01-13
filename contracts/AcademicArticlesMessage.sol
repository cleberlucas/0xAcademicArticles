// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library AcademicArticlesMessage {
    string public constant OWNER_ACTION = "owner action";
    string public constant INSTITUTION_ACTION = "institution action";
    string public constant AFFILIATE__INSTITUTION_ACTION = "affiliate/institution action";
    string public constant CONTRACT_ACTION = "contract action";
    string public constant CONTRACT_ALREADY_ADDED = "contract already added";
    string public constant CONTRACT_WAS_NOT_ADDED = "contract was not added";
    string public constant ACCOUNT_IS_INSTITUTION = "account is an institution";
    string public constant ACCOUNT_IS_AFFILIATE = "account is an affiliate";
    string public constant ACCOUNT_WAS_NOT_CONTRACT = "account was not contract";
    string public constant ACCOUNT_IS_EMPTY = "account is empty";
    string public constant INSTITUTION_ALREADY_REGISTERED = "institution already registered";
    string public constant INSTITUTION_WAS_NOT_REGISTERED = "institution was not registered";
    string public constant AFFILIATE_ALREADY_LINKED = "affiliate already linked";
    string public constant AFFILIATE_WAS_NOT_LINKED = "affiliate was not linked";
    string public constant AFFILIATE_WAS_NOT_LINKED_IN_INSTITUTION = "affiliate was not linked in institution";
    string public constant ARTICLE_ALREADY_PUBLISHED = "article already published";
    string public constant ARTICLE_WAS_NOT_PUBLISHED = "article was not published";
    string public constant ARTICLE_ALREADY_STAMPED = "article already stamped";
    string public constant ARTICLE_WAS_NOT_STAMPED = "article was not stamped";
    string public constant ARTICLE_NOT_YOURS = "article not yours";
    string public constant ARTICLE_WAS_NOT_STAMPED_BY_YOUR_INSTITUTION = "article was not stamped by institution";
}