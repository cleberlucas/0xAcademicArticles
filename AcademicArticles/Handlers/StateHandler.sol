// SPDX-License-Identifier: MIT

import "../Interfaces/IStateHandler.sol";
import "../Complements/RepositoryComplement.sol";
import "../Complements/UtilsComplement.sol";
import "../Complements/ModifierComplement.sol";
import "../Complements/EventComplement.sol";
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/MessageLibrary.sol";

pragma solidity ^0.8.23;

contract StateHandler is IStateHandler, RepositoryComplement, UtilsComplement, ModifierComplement, EventComplement {
    function RegisterInstitution(address[] memory institutionAccounts) 
    public payable
    IsOwner
    AreNotEmptyAccountEntrie(institutionAccounts)
    AreNotDuplicatedAccountEntrie(institutionAccounts)
    AreNotAuthenticator(institutionAccounts)
    AreInstitutionRegistered(institutionAccounts, false, MessageLibrary.ONE_OF_INSTITUTION_ALREADY_REGISTERED) {

        for (uint256 i = 0; i < institutionAccounts.length; i++) {
            _institution.accounts.push(institutionAccounts[i]);

            emit InstitutionRegistered(institutionAccounts[i]);
        }
       
    }

    function UnregisterInstitution(address[] memory institutionAccounts) 
    public payable 
    IsOwner
    AreInstitutionRegistered(institutionAccounts, true, MessageLibrary.ONE_OF_INSTITUTION_WAS_NOT_REGISTERED) {

        for (uint256 i = 0; i < institutionAccounts.length; i++) {
            for (uint256 ii = 0; ii < _institution.accounts.length; ii++) {
                if (_institution.accounts[ii] == institutionAccounts[i]) {
                    _institution.accounts[ii] = _institution.accounts[_institution.accounts.length - 1];
                    _institution.accounts.pop();

                    delete _institution.authenticators[institutionAccounts[i]];
      
                    for (uint256 iii = 0; iii < _article.ids.length; iii++) {
                        if (_article.institution[_article.ids[iii]] == institutionAccounts[i]) {
                            _article.institution[_article.ids[iii]] = address(0);
                        }
                    }

                    emit InstitutionUnregistered(institutionAccounts[i]);

                    break;
                } 
            }
        }              
    }

    function BindAuthenticator(address[] memory authenticatorAccounts)
    public payable 
    IsInstitution
    AreNotEmptyAccountEntrie(authenticatorAccounts)
    AreNotDuplicatedAccountEntrie(authenticatorAccounts)
    AreNotInstitution(authenticatorAccounts)
    AreNotBindedToAnInstitution(authenticatorAccounts) {
        
        for (uint256 i = 0; i < authenticatorAccounts.length; i++) {
            _institution.authenticators[msg.sender].push(authenticatorAccounts[i]);

            emit AuthenticatorBinded(authenticatorAccounts[i]);
        }
    }

    function UnbindAuthenticator(address[] memory authenticatorAccounts)
    public payable 
    IsInstitution
    AreBindedInInstitution(authenticatorAccounts) {

        for (uint256 i = 0; i < authenticatorAccounts.length; i++) {
            for (uint256 ii = 0; ii < _institution.authenticators[msg.sender].length; ii++) {
                if (_institution.authenticators[msg.sender][ii] == authenticatorAccounts[i]) {
                    _institution.authenticators[msg.sender][ii] = _institution.authenticators[msg.sender][_institution.authenticators[msg.sender].length - 1];
                    _institution.authenticators[msg.sender].pop();

                    emit AuthenticatorUnbinded(authenticatorAccounts[i]);

                    break;
                }  
            }
        }             
    }

    function AuthenticateArticle(bytes32[] memory articleIds)
    public payable 
    IsInstitutionOrAuthenticator
    AreNotDuplicatedArticleEntrie(articleIds)
    AreArticlePosted(articleIds, true, MessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleAuthenticated(articleIds, false, MessageLibrary.ONE_OF_ARTICLES_ALREADY_AUTHENTICATED) {          
        
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAuthenticator(msg.sender);
        }

        for (uint256 i = 0; i < articleIds.length; i++) {
            _article.institution[articleIds[i]] = institution;

            emit ArticleAuthenticated(articleIds[i]);
        }
    }

    function UnauthenticateArticle(bytes32[] memory articleIds)
    public payable
    IsInstitutionOrAuthenticator
    AreArticlePosted(articleIds, true, MessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleAuthenticated(articleIds, true, MessageLibrary.ONE_OF_ARTICLES_WAS_NOT_AUTHENTICATED) 
    AreArticleAuthenticatedByInstitution(articleIds) {
        
        for (uint256 i = 0; i < articleIds.length; i++) {
            _article.institution[articleIds[i]] = address(0);

            emit ArticleUnauthenticate(articleIds[i]);
        }
    }

    function PostArticle(DelimitationLibrary.Article[] memory articleContents) 
    public payable
    AreNotDuplicatedArticleEntrie(ArticleIdFromArticleContents(articleContents))
    AreArticlePosted(ArticleIdFromArticleContents(articleContents), false, MessageLibrary.ONE_OF_ARTICLES_ALREADY_POSTED) {          
        
        bytes32[] memory articleIds = new bytes32[](articleContents.length);
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAuthenticator(msg.sender);
        }

        for (uint256 i = 0; i < articleIds.length; i++) {
            articleIds[i] = keccak256(abi.encode(articleContents[i]));

            _article.ids.push(articleIds[i]);
            _article.poster[articleIds[i]] = msg.sender;
            _article.content[articleIds[i]] = articleContents[i];

            if (institution != address(0)) {
                _article.institution[articleIds[i]] = institution;
            }

            emit ArticlePosted(articleIds[i]);
        }
    }

    function RemoveArticle(bytes32[] memory articleIds)
    public payable 
    AreArticlePosted(articleIds, true, MessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleMy(articleIds) {
        
        for (uint256 i = 0; i < articleIds.length; i++) {
            for (uint256 ii = 0; ii < _article.ids.length; ii++) {
                if (_article.ids[ii] == articleIds[i]) {                 
                    _article.ids[ii] = _article.ids[_article.ids.length - 1];
                    _article.ids.pop();

                    _article.poster[articleIds[i]] = address(0);

                    if (_article.institution[articleIds[i]] != address(0)) {
                        _article.institution[articleIds[i]] = address(0);
                    }
                    
                    delete _article.content[articleIds[i]];

                    emit ArticleRemoved(articleIds[i]);

                    break;
                }
            }          
        }      
    }

}
