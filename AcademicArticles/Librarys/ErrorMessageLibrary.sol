// SPDX-License-Identifier: AFL-3.0
pragma solidity ^0.8.0;

library ErrorMessageLibrary {
    string public constant OwnerAction =
        "Only the creator performs this action!";
    string public constant InstitutionAction =
        "Only the institution performs this action!";
    string public constant BindedAuthenticatorAction =
        "Only the autenticator binded performs this action!";

    string public constant ArticleNotFound = "The article was not found!";
    string public constant ArticleAuthenticated =
        "The article has already been authenticated!";

    string public constant InstitutionRegistered =
        "Institution has already been registered!";
    string public constant InstitutionWasNotRegistered =
        "Institution was not registered!";

    string public constant AuthenticatorBindedInInstitution =
        "Authenticator has already been binded in institution!";
    string public constant AuthenticatorWasNotBindedInInstitution =
        "Authenticator was not binded in institution!";
}
