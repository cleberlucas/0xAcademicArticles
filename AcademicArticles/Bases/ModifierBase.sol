// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DepositingLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Helppers/ModifierHelpper.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.21;

abstract contract ModifierBase is DepositingGlobal, ModifierHelpper {
    
    modifier IsOwner() {
        RequireHelpper(OWNER == msg.sender, ErrorMessageLibrary.OwnerAction);
        _;
    }

    modifier IsArticlesRegistered(DepositingLibrary.ArticleKey[] memory articlesKey) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            RequireHelpper(IsArticleRegisteredHelpper(articlesKey[i]), ErrorMessageLibrary.ArticleInArticlesNotFound(i));
        }
        _;
    }

    modifier IsArticleRegistered(
        DepositingLibrary.ArticleKey memory articleKey
    ) {
        RequireHelpper(IsArticleRegisteredHelpper(articleKey), ErrorMessageLibrary.ArticleNotFound);
        _;
    }

    modifier IsNotArticlesAuthenticated(DepositingLibrary.ArticleKey[] memory articlesKey) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            RequireHelpper(
                articleShared[articlesKey[i].poster][articlesKey[i].articleType][articlesKey[i].sequence].authenticator == address(0),
                ErrorMessageLibrary.ArticleInArticlesIsAuthenticated(i)
            );
        }
        _;
    }

    modifier IsInstitutionRegistered(address institutionKey, bool registered) {
        bool result;

        for (uint256 i = 0; i < keyShared.institutions.length; i++) {
            if (keyShared.institutions[i] == institutionKey) {
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

        for (uint256 i = 0; i < keyShared.authenticators.length; i++)
            if (keyShared.authenticators[i] == authenticatorKey) {
                result = true;
                break ;
            }

        RequireHelpper(result, ErrorMessageLibrary.AuthenticatorNotFound);
        _;
    }

    modifier IsAuthenticatorInstitutionRegistered(address authenticatorKey, address institutionKey, bool registered) {
        RequireHelpper((authenticatorInstitutionShared[authenticatorKey] == institutionKey) == registered, registered ? ErrorMessageLibrary.AuthenticatorInstitutionNotFound : ErrorMessageLibrary.AuthenticatorInstitutionFound);
        _;
    }

}
