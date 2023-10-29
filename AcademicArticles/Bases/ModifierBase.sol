// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DepositingLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils/ModifierUtil.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.22;

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

    modifier IsAuthenticator() {
        bool result;

        for (uint256 i = 0; i < _key.authenticators.length; i++)
            if (_key.authenticators[i] == msg.sender) {
                result = true;
                break;
            }

        Require(result, ErrorMessageLibrary.AuthenticatorAction);
        _;
    }

    modifier IsValidAddress(address validateAddress) {
        Require(
            validateAddress != address(0),
            ErrorMessageLibrary.NotValidAddress
        );
        _;
    }

    modifier IsAuthenticatorBindedInIntituition(
        address authenticatorKey,
        bool binded,
        string memory messageOnError
    ) {
        Require(
            (_bindingIntitutionAuthenticators[authenticatorKey] == msg.sender) == binded,
            messageOnError
        );
        _;
    }

    modifier IsSameInstitutionBinded(
        DepositingLibrary.ArticleKey memory articleKey
    ) {
        Require(
            _institutionAuthenticatedArticles[articleKey.poster][articleKey.articleType][
                articleKey.sequenceArticleType
            ] == _bindingIntitutionAuthenticators[msg.sender],
            ErrorMessageLibrary.AuthenticatorNotBelongInstitutionBinded
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

        Require(result, ErrorMessageLibrary.ArticleNotPosted);
        _;
    }

    modifier IsArticleAuthenticated(
        DepositingLibrary.ArticleKey memory articleKey,
        bool authenticated,
        string memory messageOnError
    ) {
        bool result = _institutionAuthenticatedArticles[articleKey.poster][
            articleKey.articleType
        ][articleKey.sequenceArticleType] != address(0);

        Require(authenticated ? result : !result, messageOnError);
        _;
    }
}
