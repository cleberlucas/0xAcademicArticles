// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DepositingLibrary.sol";

pragma solidity ^0.8.0;

abstract contract EventBase {
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

    event ArticlePosted(DepositingLibrary.ArticleKey indexed article);

    event ArticleEdited(DepositingLibrary.ArticleKey indexed article);

    event ArticleRemoved(DepositingLibrary.ArticleKey indexed article);

    event ArticleAuthenticated(
        DepositingLibrary.ArticleKey indexed article,
        address authenticator
    );
}
