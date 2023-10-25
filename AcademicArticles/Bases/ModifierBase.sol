// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DepositingLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils/ModifierUtil.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.21;

abstract contract ModifierBase is DepositingGlobal, ModifierUtil {
    
    modifier IsOwner() {
        RequireHelpper(OWNER == msg.sender, ErrorMessageLibrary.OwnerAction);
        _;
    }

    modifier IsArticlesPosted(DepositingLibrary.ArticleKey[] memory articlesKey) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            RequireHelpper(IsArticlePostedHelpper(articlesKey[i]), ErrorMessageLibrary.ArticleInArticlesNotFound(i));
        }
        _;
    }

    modifier IsArticlePosted(
        DepositingLibrary.ArticleKey memory articleKey
    ) {
        RequireHelpper(IsArticlePostedHelpper(articleKey), ErrorMessageLibrary.ArticleNotFound);
        _;
    }

    modifier IsNotArticlesAuthenticated(DepositingLibrary.ArticleKey[] memory articlesKey) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            RequireHelpper(
                _articles[articlesKey[i].poster][articlesKey[i].articleType][articlesKey[i].sequence].authenticator == address(0),
                ErrorMessageLibrary.ArticleInArticlesIsAuthenticated(i)
            );
        }
        _;
    }

    modifier IsInstitutionRegistered(address institutionKey, bool registered) {
        bool result;

        for (uint256 i = 0; i < _key.institutions.length; i++) {
            if (_key.institutions[i] == institutionKey) {
                result = true;
                break;
            }
        }

        RequireHelpper(registered ? result : !result, registered ? ErrorMessageLibrary.InstitutionNotFound : ErrorMessageLibrary.InstitutionFound);
        _;
    }


    modifier IsAuthenticatorRegistered(
        address authenticatorKey
    ) {
        bool result;

        for (uint256 i = 0; i < _key.authenticators.length; i++)
            if (_key.authenticators[i] == authenticatorKey) {
                result = true;
                break ;
            }

        RequireHelpper(result, ErrorMessageLibrary.AuthenticatorNotFound);
        _;
    }

    modifier IsAuthenticatorBinded(address authenticatorKey, address institutionKey, bool registered) {
        RequireHelpper((_authenticators[authenticatorKey] == institutionKey) == registered, registered ? ErrorMessageLibrary.AuthenticatorBindedNotFound : ErrorMessageLibrary.AuthenticatorBindedFound);
        _;
    }

}
