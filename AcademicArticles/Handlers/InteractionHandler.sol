// SPDX-License-Identifier: MIT
import "../Librarys/DelimitationLibrary.sol";
import "../Extensions/ModifierExtension.sol";
import "../Extensions/EventExtension.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract InteractionHandler is RepositoryExtension, ModifierExtension, EventExtension {
    function RegisterInstitution(address institutionAccount, DelimitationLibrary.Institution memory institutionContent) 
    public payable
    IsOwner
    IsNotEmptyAccount(institutionAccount)
    IsInstitutionRegistered(institutionAccount, false, ErrorMessageLibrary.INSTITUTION_ALREADY_REGISTERED) {

        _institution.accounts.push(institutionAccount);
        _institution.content[institutionAccount] = institutionContent;

        emit InstitutionRegistered(institutionAccount);
    }

    function EditInstitution(address institutionAccount, DelimitationLibrary.Institution memory institutionContent) 
    public payable 
    IsOwner 
    IsInstitutionRegistered(institutionAccount, true, ErrorMessageLibrary.INSTITUTION_WAS_NOT_REGISTERED) {

        _institution.content[institutionAccount] = institutionContent;

        emit InstitutionRegistered(institutionAccount);
    }

    function UnregisterInstitutions(address[] memory institutionAccounts) 
    public payable 
    IsOwner 
    AreNotEmptyAccount(institutionAccounts)
    AreInstitutionRegistered(institutionAccounts) {

        for (uint256 i = 0; i < institutionAccounts.length; i++) 
            for (uint256 ii = 0; ii < _institution.accounts.length; ii++)
                if (_institution.accounts[ii] == institutionAccounts[i]) {

                    _institution.accounts[ii] = _institution.accounts[_institution.accounts.length - 1];
                    _institution.accounts.pop();

                    delete _institution.content[institutionAccounts[i]];
                    delete _institution.authenticators[institutionAccounts[i]];
      
                    for (uint256 iii = 0; iii < _article.ids.length; iii++) 
                        if (_article.authenticatingInstitution[_article.ids[iii]] == institutionAccounts[i])
                            _article.authenticatingInstitution[_article.ids[iii]] = address(0);
                        
                    emit InstitutionUnregistered(institutionAccounts[i]);

                    break;
                }      
    }

    function BindAuthenticators(address[] memory authenticatorAccounts)
    public payable 
    IsInstitution 
    AreNotEmptyAccount(authenticatorAccounts) 
    AreAuthenticatorBindedNoAnyInstitution(authenticatorAccounts){
        
        for (uint256 i = 0; i < authenticatorAccounts.length; i++) {
            _institution.authenticators[msg.sender].push(authenticatorAccounts[i]);

            emit AuthenticatorBinded(authenticatorAccounts[i]);
        }
    }

    function UnbindAuthenticators(address[] memory authenticatorAccounts)
    public payable 
    IsInstitution 
    AreAuthenticatorBindedInInstitution(authenticatorAccounts){

        for (uint256 i = 0; i < authenticatorAccounts.length; i++) 
            for (uint256 ii = 0; ii < _institution.authenticators[msg.sender].length; ii++)
                if (_institution.authenticators[msg.sender][ii] == authenticatorAccounts[i]) {

                    _institution.authenticators[msg.sender][ii] = _institution.authenticators[msg.sender][_institution.authenticators[msg.sender].length - 1];
                    _institution.authenticators[msg.sender].pop();

                    emit AuthenticatorUnbinded(authenticatorAccounts[i]);

                    break;
                }    
    }

    function AuthenticateArticles(bytes32[] memory articleIds)
    public payable 
    IsAuthenticator
    AreArticlePosted(articleIds, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleAuthenticated(articleIds, false, ErrorMessageLibrary.ONE_OF_ARTICLES_ALREADY_AUTHENTICATED) {          
        
        for (uint256 i = 0; i < articleIds.length; i++) {
            _article.authenticatingInstitution[articleIds[i]] = SearchInstitutionOfAuthenticator(msg.sender);

            emit ArticleAuthenticated(articleIds[i]);
        }
    }

    function UnauthenticateArticles(bytes32[] memory articleIds)
    public payable
    IsAuthenticator
    AreArticlePosted(articleIds, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleAuthenticated(articleIds, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_AUTHENTICATED) 
    AreSameInstitutionAuthenticatedArticle(articleIds) {
        
        for (uint256 i = 0; i < articleIds.length; i++) {
            _article.authenticatingInstitution[articleIds[i]] = address(0);

            emit ArticleUnauthenticate(articleIds[i]);
        }
    }

    function PostArticles(DelimitationLibrary.Article[] memory articleContents) 
    public payable 
    AreArticlePosted(ArticleContentsToKeccak256(articleContents), false, ErrorMessageLibrary.ONE_OF_ARTICLES_ALREADY_POSTED) 
    returns (bytes32[] memory articleIds) {
        
        address authenticator;      
        articleIds = new bytes32[](articleContents.length);

        for (uint256 i = 0; i < articleIds.length; i++) {
            articleIds[i] = keccak256(abi.encode(articleContents[i]));

            _article.ids.push(articleIds[i]);
            _article.poster[articleIds[i]] = msg.sender;
            _article.content[articleIds[i]] = articleContents[i];

            authenticator = SearchInstitutionOfAuthenticator(msg.sender);
            _article.authenticatingInstitution[articleIds[i]] = authenticator;

            emit ArticlePosted(articleIds[i]);
            if (authenticator != address(0)) emit ArticleAuthenticated(articleIds[i]);
        }
    }

    function RemoveArticles(bytes32[] memory articleIds)
    public payable 
    AreArticlePosted(articleIds, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleMy(articleIds) {
        
        for (uint256 i = 0; i < articleIds.length; i++) 
            for (uint256 ii = 0; ii < _article.ids.length; ii++)
                if (_article.ids[ii] == articleIds[i]) {

                    _article.ids[ii] = _article.ids[_article.ids.length - 1];
                    _article.ids.pop();
            
                    _article.poster[articleIds[i]] = address(0);
                    _article.authenticatingInstitution[articleIds[i]] = address(0);

                    delete _article.content[articleIds[i]];

                    emit ArticleRemoved(articleIds[i]);

                    break;
                }
    }

}
