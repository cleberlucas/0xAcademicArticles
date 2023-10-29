// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DepositingLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils/ModifierUtil.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity ^0.8.0;

abstract contract ModifierBase is DepositingGlobal, ModifierUtil {
    modifier IsOwner() {
        Require(OWNER == msg.sender, ErrorMessageLibrary.OwnerAction);
        _;
    }

    modifier IsInstitution() {
        bool result;

        for (uint256 i = 0; i < _key.institutions.length; i++) {
            if (_key.institutions[i] == msg.sender) {
                result = true;
                break;
            }
        }

        Require(result, ErrorMessageLibrary.InstitutionAction);
        _;
    }

    modifier IsBindedAuthenticator() {
        bool result;

        for (uint256 i = 0; i < _key.authenticators.length; i++)
            if (_key.authenticators[i] == msg.sender) {
                result = true;
                break;
            }

        Require(result, ErrorMessageLibrary.BindedAuthenticatorAction);
        _;
    }

    modifier IsInstitutionRegistered(
        address institutionKey,
        bool registered,
        string memory messageOnError
    ) {
        bool result;

        for (uint256 i = 0; i < _key.institutions.length; i++) {
            if (_key.institutions[i] == institutionKey) {
                result = true;
                break;
            }
        }

        Require(registered ? result : !result, messageOnError);
        _;
    }

    modifier IsAuthenticatorBindedInIntituition(
        address authenticatorKey,
        bool registered,
        string memory messageOnError
    ) {
        Require(
            (_bindedAuthenticators[authenticatorKey] == msg.sender) ==
                registered,
            messageOnError
        );
        _;
    }

    modifier IsArticlePosted(DepositingLibrary.ArticleKey memory articleKey) {
        bool result;

        for (uint256 i = 0; i < _key.articles.length; i++)
            if (
                _key.articles[i].poster == articleKey.poster &&
                _key.articles[i].articleType == articleKey.articleType &&
                _key.articles[i].sequenceArticleType ==
                articleKey.sequenceArticleType
            ) {
                result = true;
                break;
            }

        Require(result, ErrorMessageLibrary.ArticleNotFound);
        _;
    }

    modifier IsNotArticleAuthenticated(
        DepositingLibrary.ArticleKey memory articleKey
    ) {
        Require(
            _authenticatedArticles[articleKey.poster][articleKey.articleType][
                articleKey.sequenceArticleType
            ] == address(0),
            ErrorMessageLibrary.ArticleAuthenticated
        );
        _;
    }
}
