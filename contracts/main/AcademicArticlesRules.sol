// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IAcademicArticlesSignature.sol";
import "./libs/AcademicArticlesMessage.sol";
import "./libs/AcademicArticlesStorageModel.sol";

abstract contract AcademicArticlesRules {
    address internal immutable OWNER;

    modifier OnlyOwner() {
        require(OWNER == msg.sender, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier OnlyContractConnected(AcademicArticlesStorageModel.Contract storage _contract) {
        require(bytes(_contract.signature[msg.sender]).length > 0, AcademicArticlesMessage.CONNECTED_CONTRACT_ACTION);
        _;
    }

    modifier IsNotArticleEmpty(bytes calldata articleData) {      
        require(articleData.length > 0, AcademicArticlesMessage.ARTICLE_IS_EMPTY);
        _;
    }

    modifier IsContractSigned(address contractAccount) {
        require (bytes(IAcademicArticlesSignature(contractAccount).SIGNATURE()).length > 0, AcademicArticlesMessage.CONTRACT_IS_NOT_SIGNED);
        _;
    }

    modifier IsNotContractConnected(AcademicArticlesStorageModel.Contract storage _contract, address contractAccount) {
        require(bytes(_contract.signature[contractAccount]).length == 0, AcademicArticlesMessage.CONTRACT_ALREADY_CONNECTED);
        _;
    }

    modifier IsContractConnected(AcademicArticlesStorageModel.Contract storage _contract, address contractAccount) {
        require(bytes(_contract.signature[contractAccount]).length > 0, AcademicArticlesMessage.CONTRACT_IS_NOT_CONNECTED);
        _;
    }

    modifier IsNotArticlePublished(AcademicArticlesStorageModel.Article storage _article, bytes32 articleToken) { 
        require(_article.publisher[articleToken] == address(0), AcademicArticlesMessage.ARTICLE_ALREADY_PUBLISHED);
        _;
    }

    modifier IsArticlePublished(AcademicArticlesStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.publisher[articleToken] != address(0), AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED);
        _;
    }

    modifier IsArticlePublishedByContract(AcademicArticlesStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.contractAccount[articleToken] == msg.sender, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED_BY_THIS_CONTRACT);
        _;
    }

    modifier IsArticlePublishedByMe(AcademicArticlesStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.publisher[articleToken] == tx.origin, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}