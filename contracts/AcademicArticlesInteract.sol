// SPDX-License-Identifier: MIT

import "./IAcademicArticlesInteract.sol";
import "./AcademicArticlesData.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesInteract is IAcademicArticlesInteract, AcademicArticlesData, AcademicArticlesRules {

    function PublishArticle(bytes calldata articleEncode) 
    public payable
    IsExternalContract(_externalContract)
    IsContractEnabled(_externalContract)
    IsNotEntryEncodeEmpty(articleEncode)
    IsNotArticlePublished(_article, keccak256(articleEncode)) {          

        bytes32 articleToken = keccak256(articleEncode);

        _article.tokens.push(articleToken);

        _article.publisher[articleToken] = tx.origin;

        _article.encode[articleToken][msg.sender] = articleEncode;

        emit AcademicArticlesLog.ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsExternalContract(_externalContract)
    IsContractEnabled(_externalContract)
    IsArticlePublished(_article, articleToken)
    IsArticlePublishedByMy(_article, articleToken) {

        for (uint256 i = 0; i < _article.tokens.length; i++) {

            if (_article.tokens[i] == articleToken) {         

                _article.tokens[i] = _article.tokens[_article.tokens.length - 1];
                _article.tokens.pop();

                _article.publisher[articleToken] = address(0);
      
                delete _article.encode[articleToken][msg.sender];

                emit AcademicArticlesLog.ArticleUnpublished(articleToken);

                break;
            }
        }             
    }

    function BindExternalContract(address externalContractAccount)
    public payable
    IsOwner
    IsNotEntryAccountZero(externalContractAccount)
    IsEntryContract(externalContractAccount)
    IsNotExternalContractBinded(_externalContract, externalContractAccount) {

        _externalContract.accounts.push(externalContractAccount);

        _externalContract.enable[externalContractAccount] = true;

        emit AcademicArticlesLog.ExternalContractBinded(externalContractAccount);    
    }

    function EnableExternalContract(address externalContractAccount)
    public payable
    IsOwner
    IsNotEntryAccountZero(externalContractAccount)
    IsEntryContract(externalContractAccount)
    IsNotExternalContractEnabled(_externalContract, externalContractAccount) {

        _externalContract.enable[externalContractAccount] = true;

        emit AcademicArticlesLog.ExternalContractEnabled(externalContractAccount);
    }

    function DisableExternalContract(address externalContractAccount)
    public payable
    IsOwner
    IsNotEntryAccountZero(externalContractAccount)
    IsEntryContract(externalContractAccount)
    IsNotExternalContractDisabled(_externalContract, externalContractAccount) {

        _externalContract.enable[externalContractAccount] = false;

        emit AcademicArticlesLog.ExternalContractDisabled(externalContractAccount);
    }
}