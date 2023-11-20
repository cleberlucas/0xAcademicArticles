// SPDX-License-Identifier: MIT
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >=0.8.22;

abstract contract EventExtension {
    event InstitutionRegistered(address indexed account);

    event InstitutionEdited(address indexed account);

    event InstitutionUnregistered(address indexed account);

    event AuthenticatorBinded(address indexed account);

    event AuthenticatorUnbinded(address indexed account);

    event ArticleAuthenticated(bytes32 indexed hashIdentifier);

    event ArticleUnauthenticate(bytes32 indexed hashIdentifier);

    event ArticlePosted(bytes32 indexed hashIdentifier);

    event ArticleRemoved(bytes32 indexed hashIdentifier);
}
