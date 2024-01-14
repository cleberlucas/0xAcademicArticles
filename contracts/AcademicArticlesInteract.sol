// SPDX-License-Identifier: MIT

import "./IAcademicArticlesInteract.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesInteract is IAcademicArticlesInteract, AcademicArticlesRules, AcademicArticlesLog {
    function PublishArticle(bytes calldata articleEncode) 
    public payable
    IsAccountContract(msg.sender)
    IsContract(msg.sender)
    IsNotEntryArticleEncodeEmpty(articleEncode)
    IsNotArticlePublished(keccak256(articleEncode), msg.sender) {          

        bytes32 articleToken = keccak256(articleEncode);

        _article.tokens.push(articleToken);
        _article.publisher[articleToken] = tx.origin;

        if (_article.encode[articleToken][msg.sender].length == 0) {
            _article.encode[articleToken][msg.sender] = articleEncode;
        }

        emit ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsAccountContract(msg.sender)
    IsContract(msg.sender)
    IsArticlePublished(articleToken, msg.sender)
    IsArticlePublishedByMy(articleToken) {

        for (uint256 i = 0; i < _article.tokens.length; i++) {
            if (_article.tokens[i] == articleToken) {                 
                _article.tokens[i] = _article.tokens[_article.tokens.length - 1];
                _article.tokens.pop();

                _article.publisher[articleToken] = address(0);

                emit ArticleUnpublished(articleToken);

                break;
            }
        }             
    }

    function BindContract(address contractAccount)
    public payable
    IsOwner
    IsNotEntryAccountEmpty(contractAccount)
    IsAccountContract(contractAccount)
    IsContractBinded(contractAccount) {

        _external.contracts.push(contractAccount);

        emit ContractBinded(contractAccount);    
    }

    function UnbindContract(address contractAccount)
    public payable
    IsOwner
    IsNotEntryAccountEmpty(contractAccount)
    IsAccountContract(contractAccount)
    IsNotContractBinded(contractAccount) {

          for (uint256 i = 0; i < _external.contracts.length; i++) {
            if (_external.contracts[i] == contractAccount) {                 
                _external.contracts[i] = _external.contracts[_external.contracts.length - 1];
                _external.contracts.pop();             

                emit ContractUnbinded(contractAccount);
                break;
            }
        } 
    }
}