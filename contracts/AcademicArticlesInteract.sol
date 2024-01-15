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
    IsNotEntryEncodeEmpty(articleEncode)
    IsNotArticlePublished(_article, keccak256(articleEncode)) {          

        bytes32 articleToken = keccak256(articleEncode);

        _article.tokens[msg.sender].push(articleToken);

        _article.publisher[articleToken] = tx.origin;

        _article.encode[articleToken] = articleEncode;

        emit AcademicArticlesLog.ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsExternalContract(_externalContract)
    IsArticlePublished(_article, articleToken)
    IsArticlePublishedByMe(_article, articleToken) {

        for (uint256 i = 0; i < _article.tokens[msg.sender].length; i++) {

            if (_article.tokens[msg.sender][i] == articleToken) {         

                _article.tokens[msg.sender][i] = _article.tokens[msg.sender][_article.tokens[msg.sender].length - 1];
                _article.tokens[msg.sender].pop();

                _article.publisher[articleToken] = address(0);
      
                delete _article.encode[articleToken];

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

        emit AcademicArticlesLog.ExternalContractBinded(externalContractAccount);    
    }

    function UnbindExternalContract(address externalContractAccount)
    public payable
    IsOwner
    IsNotEntryAccountZero(externalContractAccount)
    IsEntryContract(externalContractAccount)
    IsExternalContractBinded(_externalContract, externalContractAccount) {

          for (uint256 i = 0; i < _externalContract.accounts.length; i++) {

            if (_externalContract.accounts[i] == externalContractAccount) {

                _externalContract.accounts[i] = _externalContract.accounts[_externalContract.accounts.length - 1];
                _externalContract.accounts.pop();

                for (uint256 ii = 0; ii < _article.tokens[msg.sender].length; ii++) {

                    _article.publisher[_article.tokens[msg.sender][ii]] = address(0);

                    delete _article.encode[_article.tokens[msg.sender][ii]];         
                }

                delete _article.tokens[msg.sender];

                emit AcademicArticlesLog.ExternalContractUnbinded(externalContractAccount);

                break;
            }
        } 
    }
}