// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Extensions/ModifierExtension.sol";
import "../Extensions/EventExtension.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract InteractionHandler is RepositoryExtension, ModifierExtension, EventExtension {
    function RegisterInstitution(address account, DelimitationLibrary.Institution memory content) 
    public payable
    IsOwner 
    IsInstitutionRegistered(account, false, ErrorMessageLibrary.INSTITUTION_REGISTERED) {

        _institution.accounts.push(account);
        _institution.owner[account] = msg.sender;
        _institution.content[account] = content;

        emit InstitutionRegistered(account);
    }

    function EditInstitution(address account, DelimitationLibrary.Institution memory content) 
    public payable 
    IsOwner 
    IsInstitutionRegistered(account, true, ErrorMessageLibrary.INSTITUTION_WAS_NOT_REGISTERED) {

        _institution.content[account] = content;

        emit InstitutionRegistered(account);
    }

    function UnregisterInstitutions(address[] memory accounts) 
    public payable 
    IsOwner 
    AreInstitutionRegistered(accounts) {

        for (uint256 i = 0; i < accounts.length; i++) 
            for (uint256 ii = 0; ii < _institution.accounts.length; ii++)
                if (_institution.accounts[ii] == accounts[i]) {

                    _institution.accounts[ii] = _institution.accounts[_institution.accounts.length - 1];
                    _institution.accounts.pop();

                    delete _institution.owner[accounts[i]];
                    delete _institution.content[accounts[i]];

                    emit InstitutionUnregistered(accounts[i]);

                    break;
                }      
    }

    function BindAuthenticators(address[] memory accounts)
    public payable 
    IsInstitution 
    AreValidAddress(accounts) 
    AreAuthenticatorBindedInInstitution(accounts, false, ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_ALREADY_BINDED_IN_INSTITUTION){
        
        for (uint256 i = 0; i < accounts.length; i++) {
            _authenticator.accounts[msg.sender].push(accounts[i]);
            _authenticator.institution[accounts[i]] = msg.sender;

            emit AuthenticatorBinded(accounts[i], msg.sender);
        }
    }

    function UnbindAuthenticators(address[] memory accounts)
    public payable 
    IsInstitution 
    AreAuthenticatorBindedInInstitution(accounts, true, ErrorMessageLibrary.ONE_OF_AUTHENTICATORS_WAS_NOT_BINDED_IN_INSTITUTION){

        for (uint256 i = 0; i < accounts.length; i++) 
            for (uint256 ii = 0; ii < _authenticator.accounts[msg.sender].length; i++)
                if (_authenticator.accounts[msg.sender][ii] == accounts[i]) {

                    _authenticator.accounts[msg.sender][ii] = _authenticator.accounts[msg.sender][_authenticator.accounts[msg.sender].length - 1];
                    _authenticator.accounts[msg.sender].pop();

                    delete _authenticator.institution[accounts[i]];

                    emit AuthenticatorUnbinded(accounts[i], msg.sender);

                    break;
                }    
    }

    function AuthenticateArticles(bytes32[] memory hashIdentifiers)
    public payable 
    IsAuthenticator
    AreArticlePosted(hashIdentifiers, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleAuthenticated(hashIdentifiers, false, ErrorMessageLibrary.ONE_OF_ARTICLES_ALREADY_AUTHENTICATED) {   
        
        for (uint256 i = 0; i < hashIdentifiers.length; i++) {
            _article.institution[hashIdentifiers[i]] = _authenticator.institution[msg.sender];

            emit ArticleAuthenticated(hashIdentifiers[i], msg.sender);
        }

    }

    function DisauthenticateArticles(bytes32[] memory hashIdentifiers)
    public payable
    IsAuthenticator
    AreSameInstitutionBindedArticle(hashIdentifiers)
    AreArticleAuthenticated(hashIdentifiers, true, ErrorMessageLibrary.ONE_OF_ARTICLES_ALREADY_AUTHENTICATED) {   
    
        for (uint256 i = 0; i < hashIdentifiers.length; i++) {
            delete _article.institution[hashIdentifiers[i]];

            emit ArticleDisauthenticate(hashIdentifiers[i], msg.sender);
        }

    }

    function PostArticles(DelimitationLibrary.Article[] memory contents) 
    public payable 
    AreArticlePosted(HashIdentifiers(contents), false, ErrorMessageLibrary.ONE_OF_ARTICLES_ALREADY_POSTED) 
    returns (bytes32[] memory hashIdentifiers) {

        hashIdentifiers = new bytes32[](contents.length);

        for (uint256 i = 0; i < hashIdentifiers.length; i++) {
            hashIdentifiers[i] = keccak256(abi.encode(contents[i]));

            _article.hashIdentifiers.push(hashIdentifiers[i]);
            _article.poster[hashIdentifiers[i]] = msg.sender;
            _article.content[hashIdentifiers[i]] = contents[i];

            if (_authenticator.institution[msg.sender] != address(0))

                _article.institution[hashIdentifiers[i]] = _authenticator.institution[msg.sender];

            emit ArticlePosted(hashIdentifiers[i]);   
        }
    }

    function RemoveArticles(bytes32[] memory hashIdentifiers)
    public payable 
    AreArticlePosted(hashIdentifiers, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleMy(hashIdentifiers) {
        
        for (uint256 i = 0; i < hashIdentifiers.length; i++) 
            for (uint256 ii = 0; ii < _article.hashIdentifiers.length; ii++)
                if (_article.hashIdentifiers[ii] == hashIdentifiers[i]) {

                    _article.hashIdentifiers[ii] = _article.hashIdentifiers[_article.hashIdentifiers.length - 1];
                    _article.hashIdentifiers.pop();
            
                    delete _article.poster[hashIdentifiers[i]];
                    delete _article.content[hashIdentifiers[i]];
                    delete _article.institution[hashIdentifiers[i]];

                    emit ArticleRemoved(hashIdentifiers[i]);

                    break;
                }
    }

}
