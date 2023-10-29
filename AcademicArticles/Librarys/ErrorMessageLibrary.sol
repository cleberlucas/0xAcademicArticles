// SPDX-License-Identifier: AFL-3.0
pragma solidity >= 0.8.22;

library ErrorMessageLibrary {
    string public constant OwnerAction =
        "Only the creator performs this action!";
    string public constant InstitutionAction =
        "Only the institution performs this action!";
    string public constant AuthenticatorAction =
        "Only the autenticator performs this action!";

    string public constant NotValidAddress =
        "This address is not valid";

    string public constant ArticleNotPosted = "The article was not posted!";
    string public constant ArticleAuthenticated =
        "The article has already been authenticated!";
    string public constant ArticleNotAuthenticated =
        "The article was not authenticated!";

    string public constant AuthenticatorBindedInInstitution =
        "Authenticator has already been binded in institution!";
    string public constant AuthenticatorWasNotBindedInInstitution =
        "Authenticator was not binded in institution!";
    string public constant AuthenticatorNotBelongInstitutionBinded =
        "Authenticator do not belong to the same binded institution";
}
