// SPDX-License-Identifier: MIT

import "./IAcademicArticlesWrite.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesWrite is IAcademicArticlesWrite, AcademicArticlesRules, AcademicArticlesLog {
    function RegisterInstitution(address institutionAccount) 
    public payable
    IsOwner
    IsNotEmptyAccountEntrie(institutionAccount)
    IsNotInstitutionExist(institutionAccount) 
    IsNotAffiliate(institutionAccount) {
        _institution.accounts.push(institutionAccount);

        emit InstitutionRegistered(institutionAccount);
    }

    function UnregisterInstitution(address institutionAccount) 
    public payable 
    IsOwner
    IsInstitutionExist(institutionAccount) {
        for (uint256 ii = 0; ii < _institution.accounts.length; ii++) {
            if (_institution.accounts[ii] == institutionAccount) {
                _institution.accounts[ii] = _institution.accounts[_institution.accounts.length - 1];
                _institution.accounts.pop();

                if (_institution.affiliates[institutionAccount].length > 0) {
                    delete _institution.affiliates[institutionAccount];
                }

                for (uint256 iii = 0; iii < _article.tokens.length; iii++) {
                    if (_article.institutionStamp[_article.tokens[iii]] == institutionAccount) {
                        _article.institutionStamp[_article.tokens[iii]] = address(0);
                    }
                }

                emit InstitutionUnregistered(institutionAccount);

                break;
            } 
        }            
    }

    function LinkAffiliate(address affiliateAccount)
    public payable 
    IsInstitution
    IsNotEmptyAccountEntrie(affiliateAccount)
    IsNotAffiliateExist(affiliateAccount)
    IsNotInstitution(affiliateAccount) {     
        _institution.affiliates[msg.sender].push(affiliateAccount);

        emit AffiliateLinked(affiliateAccount);
    }

    function UnlinkAffiliate(address affiliateAccount)
    public payable 
    IsInstitution
    IsAffiliateExist(affiliateAccount)
    IsAffiliateLinkedInInstitution(affiliateAccount) {
        for (uint256 ii = 0; ii < _institution.affiliates[msg.sender].length; ii++) {
            if (_institution.affiliates[msg.sender][ii] == affiliateAccount) {
                _institution.affiliates[msg.sender][ii] = _institution.affiliates[msg.sender][_institution.affiliates[msg.sender].length - 1];
                _institution.affiliates[msg.sender].pop();

                emit AffiliateUnlinked(affiliateAccount);

                break;
            }  
        }         
    }

    function ValidateArticle(bytes32 articleToken)
    public payable 
    IsInstitutionOrAffiliate
    IsArticleExist(articleToken) 
    IsNotArticleValidated(articleToken) {            
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliate(msg.sender);
        }

        _article.institutionStamp[articleToken] = institution;

        emit ArticleValidated(articleToken);
    }

    function InvalidateArticle(bytes32 articleToken)
    public payable
    IsInstitutionOrAffiliate
    IsArticleExist(articleToken) 
    IsArticleValidated(articleToken) 
    IsArticleValidatedByInstitution(articleToken) {  
        _article.institutionStamp[articleToken] = address(0);

        emit ArticleInvalidated(articleToken);
    }

    function PublishArticle(string memory articleAbi) 
    public payable
    IsNotArticleExist(Keccak256Abi(articleAbi)) 
    returns (bytes32 articleToken)
    {          
        address institution;
        
        if (IsInstitution_(msg.sender)) {
            institution = msg.sender;
        }
        else {
            institution = InstitutionOfAffiliate(msg.sender);
        }

        articleToken = keccak256(abi.encode(articleAbi));

        _article.tokens.push(articleToken);

        _article.poster[articleToken] = msg.sender;

        if (institution != address(0)) {
            _article.institutionStamp[articleToken] = institution;
        }

        emit ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsArticleExist(articleToken) 
    IsArticleMy(articleToken) {
        for (uint256 ii = 0; ii < _article.tokens.length; ii++) {
            if (_article.tokens[ii] == articleToken) {                 
                _article.tokens[ii] = _article.tokens[_article.tokens.length - 1];
                _article.tokens.pop();

                _article.poster[articleToken] = address(0);

                if (_article.institutionStamp[articleToken] != address(0)) {
                    _article.institutionStamp[articleToken] = address(0);
                }               

                emit ArticleUnpublished(articleToken);

                break;
            }
        }             
    }
}
