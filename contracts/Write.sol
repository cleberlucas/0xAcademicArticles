// SPDX-License-Identifier: MIT

import "./IWrite.sol";
import "./RulesExt.sol";
import "./LogExt.sol";

pragma solidity ^0.8.23;

contract Write is IWrite, DataExt, UtilsExt, RulesExt, LogExt {
    function RegisterInstitutions(address[] memory institutionsAccount) 
    public payable
    IsOwner
    AreNotEmptyAccountEntrie(institutionsAccount)
    AreNotDuplicatedAccountEntrie(institutionsAccount)
    AreNotAffiliation(institutionsAccount)
    AreInstitutionNotRegistered(institutionsAccount) {

        for (uint256 i = 0; i < institutionsAccount.length; i++) {
            _institution.accounts.push(institutionsAccount[i]);

            emit InstitutionRegistered(institutionsAccount[i]);
        }
       
    }

    function UnregisterInstitutions(address[] memory institutionsAccount) 
    public payable 
    IsOwner
    AreInstitutionRegistered(institutionsAccount) {

        bool haveAffiliations;

        for (uint256 i = 0; i < institutionsAccount.length; i++) {
            for (uint256 ii = 0; ii < _institution.accounts.length; ii++) {
                if (_institution.accounts[ii] == institutionsAccount[i]) {
                    _institution.accounts[ii] = _institution.accounts[_institution.accounts.length - 1];
                    _institution.accounts.pop();

                    emit InstitutionUnregistered(institutionsAccount[ii]);

                    haveAffiliations = false;

                    for (uint256 iii = 0; iii < _institution.affiliations[_institution.accounts[ii]].length; iii++) {
                        emit AffiliationLinked(_institution.affiliations[_institution.accounts[ii]][iii]);
                       
                        if(!haveAffiliations) {
                            haveAffiliations = true;
                        }
                    }

                    if (haveAffiliations) {
                        delete _institution.affiliations[institutionsAccount[ii]];
                    }
 
                    for (uint256 iii = 0; iii < _article.ids.length; iii++) {
                        if (_article.validatingInstitution[_article.ids[iii]] == institutionsAccount[ii]) {
                            _article.validatingInstitution[_article.ids[iii]] = address(0);

                            emit ArticleInvalidated(_article.ids[iii]);
                        }
                    }

                    break;
                } 
            }
        }              
    }

    function LinkAffiliations(address[] memory affiliationsAccount)
    public payable 
    IsInstitution
    AreNotEmptyAccountEntrie(affiliationsAccount)
    AreNotDuplicatedAccountEntrie(affiliationsAccount)
    AreNotInstitution(affiliationsAccount)
    AreNotLinkedToAnInstitution(affiliationsAccount) 
    {
        
        for (uint256 i = 0; i < affiliationsAccount.length; i++) {
            _institution.affiliations[msg.sender].push(affiliationsAccount[i]);

            emit AffiliationLinked(affiliationsAccount[i]);
        }
    }

    function UnlinkAffiliations(address[] memory affiliationsAccount)
    public payable 
    IsInstitution
    AreLinkedInInstitution(affiliationsAccount) 
    {

        for (uint256 i = 0; i < affiliationsAccount.length; i++) {
            for (uint256 ii = 0; ii < _institution.affiliations[msg.sender].length; ii++) {
                if (_institution.affiliations[msg.sender][ii] == affiliationsAccount[i]) {
                    _institution.affiliations[msg.sender][ii] = _institution.affiliations[msg.sender][_institution.affiliations[msg.sender].length - 1];
                    _institution.affiliations[msg.sender].pop();

                    emit AffiliationUnlinked(affiliationsAccount[i]);

                    break;
                }  
            }
        }             
    }

    function ValidateArticles(bytes32[] memory articlesId)
    public payable 
    IsInstitutionOrAffiliation
    AreArticlePosted(articlesId) 
    AreArticleNotValidated(articlesId) {          
        
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliation(msg.sender);
        }

        for (uint256 i = 0; i < articlesId.length; i++) {
            _article.validatingInstitution[articlesId[i]] = institution;

            emit ArticleValidated(articlesId[i]);
        }
    }

    function InvalidateArticles(bytes32[] memory articlesId)
    public payable
    IsInstitutionOrAffiliation
    AreArticlePosted(articlesId) 
    AreArticleValidated(articlesId) 
    AreArticleValidatedByInstitution(articlesId) {
        
        for (uint256 i = 0; i < articlesId.length; i++) {
            _article.validatingInstitution[articlesId[i]] = address(0);

            emit ArticleInvalidated(articlesId[i]);
        }
    }

    function PublishArticles(ModelLib.Article[] memory articleContents) 
    public payable
    AreNotDuplicatedArticleEntrie(Keccak256ArticlesContent(articleContents))
    AreArticleNotPosted(Keccak256ArticlesContent(articleContents)) 
    {          
        
        bytes32[] memory articlesId = new bytes32[](articleContents.length);
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliation(msg.sender);
        }

        for (uint256 i = 0; i < articlesId.length; i++) {
            articlesId[i] = keccak256(abi.encode(articleContents[i]));

            _article.ids.push(articlesId[i]);

            _article.poster[articlesId[i]] = msg.sender;
            
            _article.content[articlesId[i]] = articleContents[i];

            emit ArticlePublished(articlesId[i]);

            if (institution != address(0)) {
                _article.validatingInstitution[articlesId[i]] = institution;
                emit ArticleValidated(articlesId[i]);
            }
        }
    }

    function UnpublishArticles(bytes32[] memory articlesId)
    public payable
    AreArticlePosted(articlesId) 
    AreArticleMy(articlesId) {
        
        for (uint256 i = 0; i < articlesId.length; i++) {
            for (uint256 ii = 0; ii < _article.ids.length; ii++) {
                if (_article.ids[ii] == articlesId[i]) {                 
                    _article.ids[ii] = _article.ids[_article.ids.length - 1];
                    _article.ids.pop();

                    _article.poster[articlesId[i]] = address(0);

                    if (_article.validatingInstitution[articlesId[i]] != address(0)) {
                        _article.validatingInstitution[articlesId[i]] = address(0);
                    }
                    
                    delete _article.content[articlesId[i]];

                    emit ArticleUnpublished(articlesId[i]);

                    break;
                }
            }          
        }      
    }

}
