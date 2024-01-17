// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AcademicArticlesMessage.sol";
import "./libs/AcademicArticlesStorageModel.sol";

abstract contract AcademicArticlesRules {
    address internal immutable OWNER;

    modifier InputArticleDataIsNotEmpty(bytes calldata articleData) {      
        require(articleData.length > 0, AcademicArticlesMessage.ARTICLE_DATA_INPUTED_IS_EMPTY);
        _;
    }

    modifier InputContractNameIsNotEmpty(string calldata contractName) {      
        require(bytes(contractName).length > 0, AcademicArticlesMessage.CONTRACT_NAME_INPUTED_IS_EMPTY);
        _;
    }

    modifier InputAccountIsAContract(address contractAccount) {
        require (contractAccount.code.length > 0, AcademicArticlesMessage.CONTRACT_ACCOUNT_INPUTED_IS_NOT_A_CONTRACT);
        _;
    }

    modifier OnlyOwner() {
        require(OWNER == msg.sender, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier OnlyContractConnected(AcademicArticlesStorageModel.Contract storage _contract) {
        require(bytes(_contract.name[msg.sender]).length > 0, AcademicArticlesMessage.CONNECTED_CONTRACT_ACTION);
        _;
    }

    modifier IsNotContractConnected(AcademicArticlesStorageModel.Contract storage _contract, address contractAccount) {
        require(bytes(_contract.name[contractAccount]).length == 0, AcademicArticlesMessage.CONTRACT_ALREADY_CONNECTED);
        _;
    }

    modifier IsContractConnected(AcademicArticlesStorageModel.Contract storage _contract, address contractAccount) {
        require(bytes(_contract.name[contractAccount]).length > 0, AcademicArticlesMessage.CONTRACT_IS_NOT_CONNECTED);
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

    modifier IsArticlePublishedByMe(AcademicArticlesStorageModel.Article storage _article, bytes32 articleToken) {
        require(_article.publisher[articleToken] == tx.origin, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}