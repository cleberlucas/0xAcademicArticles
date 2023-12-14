// SPDX-License-Identifier: MIT 
pragma solidity >=0.8.22;

library ErrorMessageLibrary {
    string public constant OWNER_ACTION = "owner-action";
    string public constant INSTITUTION_ACTION = "institution-action";
    string public constant AUTHENTICATOR_ACTION = "authenticator-action";
    string public constant ONE_OF_INSTITUTION_ALREADY_REGISTERED = "one-of-institution-already-registered";
    string public constant ONE_OF_INSTITUTION_WAS_NOT_REGISTERED = "one-of-institution-was-not-registered";
    string public constant ONE_OF_ACCOUNTS_IS_EMPTY = "one-of-accounts-is-empty";
    string public constant ACCOUNT_IS_EMPTY = "account-is-empty";
    string public constant ONE_OF_ARTICLES_ALREADY_POSTED = "one-of-articles-already-posted";
    string public constant ONE_OF_ARTICLES_WAS_NOT_POSTED = "one-of-articles-was-not-posted";
    string public constant ONE_OF_ARTICLES_ALREADY_AUTHENTICATED = "one-of-articles-already-authenticated";
    string public constant ONE_OF_ARTICLES_WAS_NOT_AUTHENTICATED = "one-of-articles-was-not-authenticated";
    string public constant ONE_OF_ARTICLES_NOT_YOURS = "one-of-articles-not-yours";
    string public constant ONE_OF_AUTHENTICATORS_ALREADY_BINDED_TO_AN_INSTITUTION = "one-of-authenticators-already-binded-in-institution";
    string public constant ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION = "one-of-authenticators-was-not-binded-in-institution";
    string public constant ONE_OF_AUTHENTICATORS_NOT_BELONG_INSTITUTION_BINDED = "one-of-authenticators-not-belong-institution-binded";
}
