// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library MessageLib {
    string public constant OWNER_ACTION = "owner-action";
    string public constant INSTITUTION_ACTION = "institution-action";
    string public constant INSTITUTION_AUTHENTICATOR_ACTION = "institution/authenticator-action";
    string public constant ONE_OF_ACCOUNTS_IS_A_INSTITUTION = "one-of-account-is-a-institution";
    string public constant ONE_OF_ACCOUNTS_IS_A_AUTHENTICATOR = "one-of-account-is-a-authenticator";
    string public constant ONE_OF_ACCOUNTS_IS_EMPTY = "one-of-accounts-is-empty";
    string public constant ONE_OF_ACCOUNTS_IS_DUPLICATED = "one-of-accounts-is-duplicated";
    string public constant ONE_OF_ARTICLES_IS_DUPLICATED = "one-of-articles-is-duplicated";
    string public constant ONE_OF_INSTITUTION_ALREADY_REGISTERED = "one-of-institution-already-registered";
    string public constant ONE_OF_INSTITUTION_WAS_NOT_REGISTERED = "one-of-institution-was-not-registered";
    string public constant ONE_OF_ARTICLES_ALREADY_POSTED = "one-of-articles-already-posted";
    string public constant ONE_OF_ARTICLES_WAS_NOT_POSTED = "one-of-articles-was-not-posted";
    string public constant ONE_OF_ARTICLES_ALREADY_AUTHENTICATED = "one-of-articles-already-authenticated";
    string public constant ONE_OF_ARTICLES_WAS_NOT_AUTHENTICATED = "one-of-articles-was-not-authenticated";
    string public constant ONE_OF_ARTICLES_NOT_YOURS = "one-of-articles-not-yours";
    string public constant ONE_OF_AUTHENTICATORS_ALREADY_BINDED_TO_AN_INSTITUTION = "one-of-authenticators-already-binded-to-an-institution";
    string public constant ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION = "one-of-authenticators-was-not-binded-in-institution";
    string public constant ONE_OF_THE_ARTICLES_WAS_NOT_AUTHENTICATED_BY_INSTITUTION = "one-of-the-articles-was-not-authenticated-by-institution";
}
