// SPDX-License-Identifier: AFL-3.0
pragma solidity >=0.8.22;

library ErrorMessageLibrary {
    string public constant OWNER_ACTION = "Only the creator performs this action";
    string public constant INSTITUTION_ACTION = "Only the institution performs this action";
    string public constant AUTHENTICATOR_ACTION = "Only the authenticator performs this action";
    string public constant INSTITUTION_REGISTERED = "Institution has already been registered";
    string public constant INSTITUTION_WAS_NOT_REGISTERED = "Institution was not registered";
    string public constant ONE_OF_INSTITUTION_WAS_NOT_REGISTERED = "One of the institutions was not registered";
    string public constant ONE_OF_NOT_VALID_ADDRESSES = "One of the addresses is not valid";
    string public constant ONE_OF_ARTICLES_ALREADY_POSTED = "One of the articles has already been posted";
    string public constant ONE_OF_ARTICLES_WAS_NOT_POSTED = "One of the articles was not posted";
    string public constant ONE_OF_ARTICLES_ALREADY_AUTHENTICATED = "One of the articles has already been authenticated";
    string public constant ONE_OF_ARTICLES_NOT_YOURS = "One of the articles is not yours ";
    string public constant ONE_OF_AUTHENTICATORS_ALREADY_BINDED_IN_INSTITUTION = "One of the authenticators has already been binded in institution";
    string public constant ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION = "One of the authenticators was not binded in institution ";
    string public constant ONE_OF_AUTHENTICATORS_NOT_BELONG_INSTITUTION_BINDED = "One of the authenticators do not belong to the same binded institution";
}
