// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils/ModifierUtil.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ModifierExtension is RepositoryExtension, ModifierUtil {
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

    modifier IsInstitutionRegistered(address institutionKey, bool registered, string memory messageOnError) {
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
        bool binded,
        string memory messageOnError
    ) {
        Require(
            (_data.bindingAuthenticators[authenticatorKey] == msg.sender) == binded,
            messageOnError
        );
        _;
    }

    modifier IsSameInstitutionBinded(
        RepositoryLibrary.ArticleKey memory articleKey
    ) {
        Require(
            _data.institutionAuthenticatedArticles[articleKey.poster][articleKey.articleType][
                articleKey.sequenceArticleType
            ] == _data.bindingAuthenticators[msg.sender],
            ErrorMessageLibrary.AuthenticatorNotBelongInstitutionBinded
        );
        _;
    }

    modifier IsArticlePosted(RepositoryLibrary.ArticleKey memory articleKey) {
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
        RepositoryLibrary.ArticleKey memory articleKey,
        bool authenticated,
        string memory messageOnError
    ) {
        bool result = _data.institutionAuthenticatedArticles[articleKey.poster][
            articleKey.articleType
        ][articleKey.sequenceArticleType] != address(0);

        Require(authenticated ? result : !result, messageOnError);
        _;
    }
}
