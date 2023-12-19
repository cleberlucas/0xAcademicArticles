// SPDX-License-Identifier: MIT
pragma solidity >=0.8.22;

abstract contract EventComplement {
    event InstitutionRegistered(address indexed institutionAccount);

    event InstitutionUnregistered(address indexed institutionAccount);

    event AuthenticatorBinded(address indexed authenticatorAccount);

    event AuthenticatorUnbinded(address indexed authenticatorAccount);

    event ArticleAuthenticated(bytes32 indexed articleId);

    event ArticleUnauthenticate(bytes32 indexed articleId);

    event ArticlePosted(bytes32 indexed articleId);

    event ArticleRemoved(bytes32 indexed articleId);
}
