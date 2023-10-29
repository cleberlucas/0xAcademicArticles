// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >= 0.8.22;

abstract contract EventExtension {
    event InstitutionRegistered(address indexed institution);

    event InstitutionEdited(address indexed institution);

    event InstitutionUnregistered(address indexed institution);

    event AuthenticatorBinded(
        address indexed authenticator,
        address indexed institution
    );

    event AuthenticatorUnbinded(
        address indexed authenticator,
        address indexed institution
    );

    event ArticlePosted(RepositoryLibrary.ArticleKey indexed article);

    event ArticleEdited(RepositoryLibrary.ArticleKey indexed article);

    event ArticleRemoved(RepositoryLibrary.ArticleKey indexed article);

    event ArticleAuthenticated(
        RepositoryLibrary.ArticleKey indexed article,
        address authenticator
    );

    event ArticleDisauthenticate(
        RepositoryLibrary.ArticleKey indexed article,
        address authenticator
    );
}
