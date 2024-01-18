// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IACARConnection.sol";
import "./libs/ACARMessage.sol";
import "./libs/ACARStorageModel.sol";

abstract contract ACARRules {
    address internal immutable OWNER;

    modifier OnlyOwner() {
        require(OWNER == msg.sender, ACARMessage.OWNER_ACTION);
        _;
    }

    modifier OnlyContractConnected(ACARStorageModel.Contract storage _contract) {
        require(bytes(_contract.signature[msg.sender]).length > 0, ACARMessage.CONNECTED_CONTRACT_ACTION);
        _;
    }

    modifier IsNotArticleEmpty(bytes calldata articleData) {      
        require(articleData.length > 0, ACARMessage.ARTICLE_IS_EMPTY);
        _;
    }

    modifier IsContractSigned(address contractAccount) {
        require (bytes(IACARConnection(contractAccount).SIGNATURE()).length > 0, ACARMessage.CONTRACT_IS_NOT_SIGNED);
        _;
    }

    modifier IsNotContractConnected(ACARStorageModel.Contract storage _contract, address contractAccount) {
        require(bytes(_contract.signature[contractAccount]).length == 0, ACARMessage.CONTRACT_ALREADY_CONNECTED);
        _;
    }

    modifier IsContractConnected(ACARStorageModel.Contract storage _contract, address contractAccount) {
        require(bytes(_contract.signature[contractAccount]).length > 0, ACARMessage.CONTRACT_IS_NOT_CONNECTED);
        _;
    }

    modifier IsNotArticlePublished(ACARStorageModel.Article storage _article, bytes32 articleToken) { 
        require(_article.publisher[articleToken] == address(0), ACARMessage.ARTICLE_ALREADY_PUBLISHED);
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