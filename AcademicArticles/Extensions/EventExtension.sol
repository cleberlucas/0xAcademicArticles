// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >=0.8.22;

abstract contract EventExtension {
    event InstitutionRegistered(address indexed account);

    event InstitutionEdited(address indexed account);

    event InstitutionUnregistered(address indexed account);

    event AuthenticatorBinded(address indexed account, address indexed institution);

    event AuthenticatorUnbinded(address indexed account, address indexed institution);

    event ArticlePosted(bytes32 indexed hashIdentifier);

    event ArticleEdited(bytes32 indexed hashIdentifier);

    event ArticleRemoved(bytes32 indexed hashIdentifier);

    event ArticleAuthenticated(bytes32 indexed hashIdentifier, address indexed authenticator);

    event ArticleDisauthenticate(bytes32 indexed hashIdentifier, address indexed authenticator);
}
