// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library AcademicArticlesMessageLib {
    string public constant OWNER_ACTION = "owner-action";
    string public constant INSTITUTION_ACTION = "institution-action";
    string public constant AFFILIATE__INSTITUTION_ACTION = "affiliate/institution-action";
    string public constant ONE_OF_ACCOUNTS_IS_A_INSTITUTION = "one-of-account-is-a-institution";
    string public constant ONE_OF_ACCOUNTS_IS_A_AFFILIATE= "one-of-account-is-a-affiliate";
    string public constant ONE_OF_ACCOUNTS_IS_EMPTY = "one-of-accounts-is-empty";
    string public constant ONE_OF_ACCOUNTS_IS_DUPLICATED = "one-of-accounts-is-duplicated";
    string public constant ONE_OF_ARTICLES_IS_DUPLICATED = "one-of-articles-is-duplicated";
    string public constant ONE_OF_ARTICLES_ALREADY_EXIST = "one-of-articles-already-exist";
    string public constant ONE_OF_ARTICLES_WAS_NOT_EXIST = "one-of-articles-was-not-exist";
    string public constant ONE_OF_ARTICLES_ALREADY_VALIDATED = "one-of-articles-already-validated";
    string public constant ONE_OF_ARTICLES_WAS_NOT_VALIDATED = "one-of-articles-was-not-validated";
    string public constant ONE_OF_ARTICLES_NOT_YOURS = "one-of-articles-not-yours";
    string public constant ONE_OF_AFFILIATES_ALREADY_EXIST= "one-of-affiliates-already-exist";
    string public constant ONE_OF_AFFILIATES_WAS_NOT_EXIST = "one-of-affiliates-was-not-exist";
    string public constant ONE_OF_AFFILIATES_WAS_NOT_LINKED_IN_INSTITUTION = "one-of-affiliates-was-not-linked-in-institution";
    string public constant ONE_OF_INSTITUTIONS_ALREADY_EXIST= "one-of-institutions-already-exist";
    string public constant ONE_OF_INSTITUTIONS_WAS_NOT_EXIST = "one-of-institutions-was-not-exist";
    string public constant ONE_OF_THE_ARTICLES_WAS_NOT_VALIDATED_BY_INSTITUTION = "one-of-the-articles-was-not-validated-by-institution";
}
