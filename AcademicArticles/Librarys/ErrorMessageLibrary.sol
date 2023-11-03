// SPDX-License-Identifier: AFL-3.0
pragma solidity >=0.8.22;

library ErrorMessageLibrary {
    string public constant OWNER_ACTION = "Only the creator performs this action ";
    string public constant INSTITUTION_ACTION = "Only the institution performs this action ";
    string public constant AUTHENTICATOR_ACTION = "Only the authenticator performs this action ";
    string public constant NOT_VALID_ADDRESS = "This address is not valid ";
    string public constant ARTICLE_ALREADY_POSTED = "The article has already been posted ";
    string public constant ARTICLE_WAS_NOT_POSTED = "The article was not posted ";
    string public constant ARTICLE_ALREADY_AUTHENTICATED = "The article has already been authenticated ";
    string public constant ARTICLE_NOT_YOURS = "This article is not yours ";
    string public constant INSTITUTION_REGISTERED = "Institution has already been registered ";
    string public constant INSTITUTION_WAS_NOT_REGISTERED = "Institution was not registered ";
    string public constant AUTHENTICATOR_ALREADY_BINDED_IN_INSTITUTION = "Authenticator has already been binded in institution ";
    string public constant AUTHENTICATOR_WAS_NOT_BINDED_IN_INSTITUTION = "Authenticator was not binded in institution ";
    string public constant AUTHENTICATOR_NOT_BELONG_INSTITUTION_BINDED = "Authenticator do not belong to the same binded institution ";
    string public constant ERROR_ON_INDEX = "An error occurred in the index ";
}
