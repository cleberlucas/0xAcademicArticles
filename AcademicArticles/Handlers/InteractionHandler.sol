// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Extensions/ModifierExtension.sol";
import "../Extensions/EventExtension.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract InteractionHandler is
    RepositoryExtension,
    ModifierExtension,
    EventExtension
{
    function RegisterInstitution(address account, DelimitationLibrary.Institution memory content) 
    public payable IsOwner IsInstitutionRegistered(account, false, ErrorMessageLibrary.INSTITUTION_REGISTERED) {
        _institution.accounts.push(account);
        _institution.owner[account] = msg.sender;
        _institution.content[account] = content;
        emit InstitutionRegistered(account);
    }

    function EditInstitution(address account, DelimitationLibrary.Institution memory content) 
    public payable IsOwner IsInstitutionRegistered(account, true, ErrorMessageLibrary.INSTITUTION_WAS_NOT_REGISTERED) {
        _institution.content[account] = content;
        emit InstitutionRegistered(account);
    }

    function UnregisterInstitution(address account) 
    public payable IsOwner IsInstitutionRegistered(account, true, ErrorMessageLibrary.INSTITUTION_WAS_NOT_REGISTERED) {
        for (uint256 i = 0; i < _institution.accounts.length; i++)
            if (_institution.accounts[i] == account) {
                _institution.accounts[i] = _institution.accounts[_institution.accounts.length - 1];
                _institution.accounts.pop();
            }
        
        delete _institution.owner[account];
        delete _institution.content[account];

        emit InstitutionUnregistered(account);
    }

    function BindAuthenticator(address account)
    public payable IsInstitution IsValidAddress(account) IsAuthenticatorBindedInInstitution(account, false, ErrorMessageLibrary.AUTHENTICATOR_ALREADY_BINDED_IN_INSTITUTION){
        
        _authenticator.accounts[msg.sender].push(account);
        _authenticator.institution[account] = msg.sender;

        emit AuthenticatorBinded(account, msg.sender);
    }

    function UnbindAuthenticator(address account)
    public payable IsInstitution IsAuthenticatorBindedInInstitution(account, true, ErrorMessageLibrary.AUTHENTICATOR_WAS_NOT_BINDED_IN_INSTITUTION){

        for (uint256 i = 0; i < _authenticator.accounts[msg.sender].length; i++)
            if (_authenticator.accounts[msg.sender][i] == account) {
                _authenticator.accounts[msg.sender][i] = _authenticator.accounts[msg.sender][
                    _authenticator.accounts[msg.sender].length - 1
                ];
                _authenticator.accounts[msg.sender].pop();
            }

        delete _authenticator.institution[account];

        emit AuthenticatorUnbinded(account, msg.sender);
    }

    function AuthenticateArticle(bytes32 hashIdentifier)
    public payable IsAuthenticator IsArticlePosted(hashIdentifier, true, ErrorMessageLibrary.ARTICLE_WAS_NOT_POSTED) IsArticleAuthenticated(hashIdentifier, false, ErrorMessageLibrary.ARTICLE_ALREADY_AUTHENTICATED){   
        
        _article.authenticator[hashIdentifier] = msg.sender;

        emit ArticleAuthenticated(hashIdentifier, msg.sender);
    }

    function DisauthenticateArticle(bytes32 hashIdentifier)
    public payable IsAuthenticator IsArticlePosted(hashIdentifier, true, ErrorMessageLibrary.ARTICLE_WAS_NOT_POSTED) IsArticleAuthenticated(hashIdentifier, true, ErrorMessageLibrary.ARTICLE_ALREADY_AUTHENTICATED){   
    
        delete _article.authenticator[hashIdentifier];

        emit ArticleDisauthenticate(hashIdentifier, msg.sender);
    }

    function PostArticle(DelimitationLibrary.Article memory content) 
    public payable IsArticlePosted(keccak256(abi.encode(content)), false, ErrorMessageLibrary.ARTICLE_ALREADY_POSTED) 
    returns (bytes32 hashIdentifier) {

        hashIdentifier = keccak256(abi.encode(content));

        _article.hashIdentifiers.push(hashIdentifier);
        _article.poster[hashIdentifier] = msg.sender;
        _article.content[hashIdentifier] = content;

        emit ArticlePosted(hashIdentifier);   
    }

    function RemoveArticle(bytes32 hashIdentifier)
    public payable IsArticlePosted(hashIdentifier, true, ErrorMessageLibrary.ARTICLE_WAS_NOT_POSTED) IsArticleMy(hashIdentifier) {
        
        for (uint256 i = 0; i < _article.hashIdentifiers.length; i++) {
            if (_article.hashIdentifiers[i] == hashIdentifier) {
                _article.hashIdentifiers[i] = _article.hashIdentifiers[_article.hashIdentifiers.length - 1];
                _article.hashIdentifiers.pop();
            }
        }

        delete _article.poster[hashIdentifier];
        delete _article.content[hashIdentifier];

        emit ArticleRemoved(hashIdentifier);
    }
}
