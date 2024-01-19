// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ACARMessage.sol";
import "./libs/ACARStorageModel.sol";
import "./interfaces/IACARSignature.sol";

abstract contract ACARRules {
    modifier OnlyContractConnected(ACARStorageModel.Contract storage _contract) {
        require(bytes(_contract.signature[msg.sender]).length > 0, ACARMessage.CONNECTED_CONTRACT_ACTION);
        _;
    }

    modifier IsNotArticleDataEmpty(bytes calldata articleData) {      
        require(articleData.length > 0, ACARMessage.ARTICLE_DATA_IS_EMPTY);
        _;
    }

    modifier IsContractSigned() {      
        require(bytes(IACARSignature(msg.sender).SIGNATURE()).length > 0, ACARMessage.CONTRACT_IS_NOT_SIGNED);
        _;
    }

    modifier IsNotContractConnected(ACARStorageModel.Contract storage _contract) {
        require(bytes(_contract.signature[msg.sender]).length == 0, ACARMessage.CONTRACT_IS_ALREADY_CONNECTED);
        _;
    }

    modifier IsNotContractSignatureUsed(ACARStorageModel.Contract storage _contract) { 
        require(_contract.account[IACARSignature(msg.sender).SIGNATURE()] == address(0), ACARMessage.CONTRACT_SIGNATURE_IS_ALREADY_USED);
        _;
    }

    modifier IsNotArticlePublished(ACARStorageModel.Article storage _article, bytes32 articleToken) { 
        require(_article.publisher[articleToken] == address(0), ACARMessage.ARTICLE_IS_ALREADY_PUBLISHED);
        _;
    }

    modifier IsArticlePublished(ACARStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.publisher[articleToken] != address(0), ACARMessage.ARTICLE_IS_NOT_PUBLISHED);
        _;
    }

    modifier IsArticlePublishedByContract(ACARStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.contractAccount[articleToken] == msg.sender, ACARMessage.ARTICLE_IS_NOT_PUBLISHED_BY_THIS_CONTRACT);
        _;
    }

    modifier IsArticlePublishedByMe(ACARStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.publisher[articleToken] == tx.origin, ACARMessage.ARTICLE_IS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}