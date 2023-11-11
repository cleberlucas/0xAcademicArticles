// SPDX-License-Identifier: MIT
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

                    delete _institution.content[accounts[i]];
                    delete _institution.authenticators[accounts[i]];
      
                    for (uint256 iii = 0; iii < _article.hashIdentifiers.length; iii++) 
                        if (_article.institution[_article.hashIdentifiers[iii]] == accounts[i])
                            _article.institution[_article.hashIdentifiers[iii]] = address(0);
                        
                    emit InstitutionUnregistered(accounts[i]);

                    break;
                }      
    }

    function BindAuthenticators(address[] memory accounts)
    public payable 
    IsInstitution 
    AreValidAddress(accounts) 
    AreAuthenticatorBindedNoAnyInstitution(accounts){
        
        for (uint256 i = 0; i < accounts.length; i++) {
            _institution.authenticators[msg.sender].push(accounts[i]);

            emit AuthenticatorBinded(accounts[i], msg.sender);
        }
    }

    function UnbindAuthenticators(address[] memory accounts)
    public payable 
    IsInstitution 
    AreAuthenticatorBindedInInstitution(accounts){

        for (uint256 i = 0; i < accounts.length; i++) 
            for (uint256 ii = 0; ii < _institution.authenticators[msg.sender].length; ii++)
                if (_institution.authenticators[msg.sender][ii] == accounts[i]) {

                    _institution.authenticators[msg.sender][ii] = _institution.authenticators[msg.sender][_institution.authenticators[msg.sender].length - 1];
                    _institution.authenticators[msg.sender].pop();

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
            _article.institution[hashIdentifiers[i]] = SearchInstitutionOfAuthenticator(msg.sender);

            emit ArticleAuthenticated(hashIdentifiers[i], msg.sender);
        }
    }

    function UnauthenticateArticles(bytes32[] memory hashIdentifiers)
    public payable
    IsAuthenticator
    AreArticlePosted(hashIdentifiers, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_POSTED) 
    AreArticleAuthenticated(hashIdentifiers, true, ErrorMessageLibrary.ONE_OF_ARTICLES_WAS_NOT_AUTHENTICATED) 
    AreSameInstitutionAuthenticatedArticle(hashIdentifiers) {
        
        for (uint256 i = 0; i < hashIdentifiers.length; i++) {
            _article.institution[hashIdentifiers[i]] = address(0);

            emit ArticleUnauthenticate(hashIdentifiers[i], msg.sender);
        }

    }

    function PostArticles(DelimitationLibrary.Article[] memory contents) 
    public payable 
    AreArticlePosted(ContentsToHashIdentifiers(contents), false, ErrorMessageLibrary.ONE_OF_ARTICLES_ALREADY_POSTED) 
    returns (bytes32[] memory hashIdentifiers) {

        hashIdentifiers = new bytes32[](contents.length);

        for (uint256 i = 0; i < hashIdentifiers.length; i++) {
            hashIdentifiers[i] = keccak256(abi.encode(contents[i]));

            _article.hashIdentifiers.push(hashIdentifiers[i]);
            _article.poster[hashIdentifiers[i]] = msg.sender;
            _article.content[hashIdentifiers[i]] = contents[i];

            if (SearchInstitutionOfAuthenticator(msg.sender) != address(0))
                _article.institution[hashIdentifiers[i]] = SearchInstitutionOfAuthenticator(msg.sender);

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
            
                    _article.poster[hashIdentifiers[i]] = address(0);
                    _article.institution[hashIdentifiers[i]] = address(0);

                    delete _article.content[hashIdentifiers[i]];

                    emit ArticleRemoved(hashIdentifiers[i]);

                    break;
                }
    }

}
