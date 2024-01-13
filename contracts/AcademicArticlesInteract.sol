// SPDX-License-Identifier: MIT

import "./IAcademicArticlesInteract.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesInteract is IAcademicArticlesInteract, AcademicArticlesRules, AcademicArticlesLog {
    function PublishArticle(string memory articleAbi) 
    public payable
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsNotArticlePublished(keccak256(abi.encode(articleAbi)))
    returns (bytes32 articleToken)
    {          
        address institution;
        
        if (IsInstitution_(tx.origin)) {
            institution = tx.origin;
        }
        else {
            institution = InstitutionOfAffiliate(tx.origin);
        }

        articleToken = keccak256(abi.encode(articleAbi));

        _article.tokens.push(articleToken);

        _article.poster[articleToken] = tx.origin;

        if (institution != address(0)) {
            _article.institutionStamp[articleToken] = institution;
        }

        emit ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsArticlePublished(articleToken) 
    IsArticleMy(articleToken) {
        for (uint256 i = 0; i < _article.tokens.length; i++) {
            if (_article.tokens[i] == articleToken) {                 
                _article.tokens[i] = _article.tokens[_article.tokens.length - 1];
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

    function StampArticle(bytes32 articleToken)
    public payable
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsInstitutionOrAffiliate
    IsArticlePublished(articleToken) 
    IsNotArticleStamped(articleToken) {            
        address institution;
        
        if (IsInstitution_(tx.origin)) {
            institution = tx.origin;
        }
        else {
            institution = InstitutionOfAffiliate(tx.origin);
        }

        _article.institutionStamp[articleToken] = institution;

        emit ArticleStamped(articleToken);
    }

    function UnstampArticle(bytes32 articleToken)
    public payable
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsInstitutionOrAffiliate
    IsArticlePublished(articleToken) 
    IsArticleStamped(articleToken) 
    IsArticleStampedByInstitution(articleToken) {  
        _article.institutionStamp[articleToken] = address(0);

        emit ArticleUnstamped(articleToken);
    }

    function RegisterInstitution(address institutionAccount) 
    public payable
    IsNotEmptyAccountEntrie(institutionAccount)
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsOwner
    IsNotInstitutionRegistered(institutionAccount) 
    IsNotAffiliate(institutionAccount) {
        _institution.accounts.push(institutionAccount);

        emit InstitutionRegistered(institutionAccount);
    }

    function UnregisterInstitution(address institutionAccount) 
    public payable
    IsNotEmptyAccountEntrie(institutionAccount)
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsOwner
    IsInstitutionRegistered(institutionAccount) {
        for (uint256 i = 0; i < _institution.accounts.length; i++) {
            if (_institution.accounts[i] == institutionAccount) {
                _institution.accounts[i] = _institution.accounts[_institution.accounts.length - 1];
                _institution.accounts.pop();

                if (_institution.affiliates[institutionAccount].length > 0) {
                    delete _institution.affiliates[institutionAccount];
                }

                for (uint256 ii = 0; ii < _article.tokens.length; ii++) {
                    if (_article.institutionStamp[_article.tokens[ii]] == institutionAccount) {
                        _article.institutionStamp[_article.tokens[ii]] = address(0);
                    }
                }

                emit InstitutionUnregistered(institutionAccount);

                break;
            } 
        }            
    }

    function LinkAffiliate(address affiliateAccount)
    public payable
    IsNotEmptyAccountEntrie(affiliateAccount)
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsInstitution
    IsNotAffiliateLinked(affiliateAccount)
    IsNotInstitution(affiliateAccount) {     
        _institution.affiliates[tx.origin].push(affiliateAccount);

        emit AffiliateLinked(affiliateAccount);
    }

    function UnlinkAffiliate(address affiliateAccount)
    public payable
    IsNotEmptyAccountEntrie(affiliateAccount)
    IsContractAccountEntrie(msg.sender)
    IsContract
    IsInstitution
    IsAffiliateLinked(affiliateAccount)
    IsAffiliateLinkedInInstitution(affiliateAccount) {
        for (uint256 i = 0; i < _institution.affiliates[tx.origin].length; i++) {
            if (_institution.affiliates[tx.origin][i] == affiliateAccount) {
                _institution.affiliates[tx.origin][i] = _institution.affiliates[tx.origin][_institution.affiliates[tx.origin].length - 1];
                _institution.affiliates[tx.origin].pop();

                emit AffiliateUnlinked(affiliateAccount);

                break;
            }  
        }         
    }

    function AddContract(address contractAccount)
    public payable
    IsNotEmptyAccountEntrie(contractAccount)
    IsContractAccountEntrie(contractAccount)
    IsOwner
    IsNotContractAdded(contractAccount)
    {
        _external.contracts.push(contractAccount);

        emit ContractAdded(contractAccount);    
    }

    function RemoveContract(address contractAccount)
    public payable
    IsNotEmptyAccountEntrie(contractAccount)
    IsContractAccountEntrie(contractAccount)
    IsOwner
    IsContractAdded(contractAccount)
    {
          for (uint256 i = 0; i < _external.contracts.length; i++) {
            if (_external.contracts[i] == contractAccount) {                 
                _external.contracts[i] = _external.contracts[_external.contracts.length - 1];
                _external.contracts.pop();             

                emit ContractRemoved(contractAccount);

                break;
            }
        } 
    }
}