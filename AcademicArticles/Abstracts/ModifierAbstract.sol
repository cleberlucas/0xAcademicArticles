// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";
import "../Shareds/DepositingShared.sol";
import "../Helppers/ModifierHelpper.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity >=0.8.21;

abstract contract ModifierAbstract is DepositingShared, ModifierHelpper {
    modifier IsOwner() {
        RequireHelpper(OWNER == msg.sender, "");
        _;
    }

    modifier IsArticlesRegistered(
        RepositoryLibrary.ArticleKey[] memory articlesKey
    ) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            if (!IsArticleRegisteredHelpper(articlesKey[i])){
                RequireHelpper(false, string.concat("", Strings.toString(i))); 
                break ;
            }           
        }
        _;
    }
    
    modifier IsArticleRegistered(
        RepositoryLibrary.ArticleKey memory articleKey
    ) {
        RequireHelpper(IsArticleRegisteredHelpper(articleKey), "");
        _;
    }

    modifier IsNotArticleRegistered(
        RepositoryLibrary.ArticleKey memory articleKey
    ) {
      
        RequireHelpper(!IsArticleRegisteredHelpper(articleKey), "");
        _;
    }

    modifier IsNotArticleAutenticated(
        RepositoryLibrary.ArticleKey[] memory articlesKey
    ) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            if (
                articleShared[articlesKey[i].poster][articlesKey[i].articleType][
                    articlesKey[i].sequence
                ].authenticator != address(0)
            ) 
             {
                RequireHelpper(false, string.concat("", Strings.toString(i))); 
                break ;
             }              
        }      
        _;
    }

    modifier IsInstitutionRegistered(address institutionKey, bool registered) {
        bool result;

        for (uint256 i = 0; i < keyShared.institutions.length; i++)
            if (keyShared.institutions[i] == institutionKey) result = true;

        RequireHelpper(result == registered, "");
        _;
    }

    modifier IsAuthenticatorRegistered(address authenticatorKey, bool registered) {
        bool result;

        for (uint256 i = 0; i < keyShared.authenticators.length; i++)
            if (keyShared.authenticators[i] == authenticatorKey) result = true;

        RequireHelpper(result == registered, "");
        _;
    }

    modifier IsAuthenticatorInstitutionRegistered(
        address authenticatorKey,
        address institutionKey,
        bool registered
    ) {
        RequireHelpper((registered == (authenticatorInstitutionShared[authenticatorKey] == institutionKey) ), "");
        _;
    }
}
