// SPDX-License-Identifier: MIT

import "./IAcademicArticlesInteract.sol";
import "./AcademicArticlesData.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesInteract is IAcademicArticlesInteract, AcademicArticlesData, AcademicArticlesRules {

    function PublishArticle(bytes calldata articleEncode) 
    public payable
    IsAccountContract(msg.sender)
    IsContract(_external.contracts, msg.sender)
    IsNotEntryArticleEncodeEmpty(articleEncode)
    IsNotArticlePublished(_article.encode[keccak256(articleEncode)][msg.sender]) {          

        bytes32 articleToken = keccak256(articleEncode);

        _article.tokens.push(articleToken);

        _article.publisher[articleToken] = tx.origin;

        _article.encode[articleToken][msg.sender] = articleEncode;

        emit AcademicArticlesLog.ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsAccountContract(msg.sender)
    IsContract(_external.contracts, msg.sender)
    IsArticlePublished(_article.encode[articleToken][msg.sender])
    IsArticlePublishedByMy(_article.publisher[articleToken]) {

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

    function BindContract(address contractAccount)
    public payable
    IsOwner(OWNER)
    IsNotEntryAccountEmpty(contractAccount)
    IsAccountContract(contractAccount)
    IsNotContractBinded(_external.contracts, contractAccount) {

        _external.contracts.push(contractAccount);

        emit AcademicArticlesLog.ContractBinded(contractAccount);    
    }

    function UnbindContract(address contractAccount)
    public payable
    IsOwner(OWNER)
    IsNotEntryAccountEmpty(contractAccount)
    IsAccountContract(contractAccount)
    IsContractBinded(_external.contracts, contractAccount) {

          for (uint256 i = 0; i < _external.contracts.length; i++) {

            if (_external.contracts[i] == contractAccount) {

                _external.contracts[i] = _external.contracts[_external.contracts.length - 1];
                _external.contracts.pop();

                emit AcademicArticlesLog.ContractUnbinded(contractAccount);

                break;
            }
        } 
    }
}