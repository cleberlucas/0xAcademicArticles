// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library MessageLib {
    string public constant OWNER_ACTION = "owner-action";
    string public constant INSTITUTION_ACTION = "institution-action";
    string public constant INSTITUTION_AFFILIATION_ACTION = "institution/affiliation-action";
    string public constant ONE_OF_ACCOUNTS_IS_A_INSTITUTION = "one-of-account-is-a-institution";
    string public constant ONE_OF_ACCOUNTS_IS_A_AFFILIATION = "one-of-account-is-a-affiliation";
    string public constant ONE_OF_ACCOUNTS_IS_EMPTY = "one-of-accounts-is-empty";
    string public constant ONE_OF_ACCOUNTS_IS_DUPLICATED = "one-of-accounts-is-duplicated";
    string public constant ONE_OF_ARTICLES_IS_DUPLICATED = "one-of-articles-is-duplicated";
    string public constant ONE_OF_INSTITUTION_ALREADY_REGISTERED = "one-of-institution-already-registered";
    string public constant ONE_OF_INSTITUTION_WAS_NOT_REGISTERED = "one-of-institution-was-not-registered";
    string public constant ONE_OF_ARTICLES_ALREADY_PUBLISHED= "one-of-articles-already-published";
    string public constant ONE_OF_ARTICLES_WAS_NOT_PUBLISHED = "one-of-articles-was-not-published";
    string public constant ONE_OF_ARTICLES_ALREADY_VALIDATED = "one-of-articles-already-validated";
    string public constant ONE_OF_ARTICLES_WAS_NOT_VALIDATED = "one-of-articles-was-not-validated";
    string public constant ONE_OF_ARTICLES_NOT_YOURS = "one-of-articles-not-yours";
    string public constant ONE_OF_AFFILIATIONS_ALREADY_LINKED_TO_AN_INSTITUTION = "one-of-affiliations-already-linked-to-an-institution";
    string public constant ONE_OF_AFFILIATIONS_WAS_NOT_LINKED_IN_INSTITUTION = "one-of-affiliations-was-not-linked-in-institution";
    string public constant ONE_OF_THE_ARTICLES_WAS_NOT_VALIDATED_BY_INSTITUTION = "one-of-the-articles-was-not-validated-by-institution";
}
