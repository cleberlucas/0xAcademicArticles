// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >=0.8.18;

abstract contract EventAbstract {
    event InstitutionRegistered(address indexed institution);

    event InstitutionEdited(address indexed institution);

    event InstitutionUnregistered(address indexed institution);

    event AuthenticatorRegistered(address indexed authenticator, address indexed institution);

    event AuthenticatorUnregistered(address indexed authenticator, address indexed institution);

    event ArticleRegistered(RepositoryLibrary.ArticleKey indexed article);

    event ArticleEdited(RepositoryLibrary.ArticleKey indexed article);

    event ArticleUnregistered(RepositoryLibrary.ArticleKey indexed article);

    event ArticleAuthenticated(
        RepositoryLibrary.ArticleKey indexed article,
        address authenticator
    );
}
