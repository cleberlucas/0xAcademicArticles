// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./AcademicArticlesCommon.sol";
import "./AcademicArticlesMessage.sol";
import "./AcademicArticlesDataModel.sol";

abstract contract AcademicArticlesRules {

    address internal immutable OWNER;

    modifier IsNotEntryEncodedEmpty(bytes calldata articleEncoded) {      
        require(articleEncoded.length > 0, AcademicArticlesMessage.ENTRY_ENCODED_IS_EMPTY);
        _;
    }

    modifier IsEntryContract(address connectedContract) {
        uint32 size;
        assembly {
            size := extcodesize(connectedContract)
        }
        require (size > 0, AcademicArticlesMessage.ENTRY_IS_NOT_A_CONTRACT);
        _;
    }

    modifier IsOwner() {
        require(OWNER == tx.origin, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsConnected(AcademicArticlesDataModel.Connected storage connected) {
        require(AcademicArticlesCommon.IsContractConnected(connected, msg.sender), AcademicArticlesMessage.EXTERNAL_CONTRACT_ACTION);
        _;
    }

    modifier IsNotContractConnected(AcademicArticlesDataModel.Connected storage connected, address connectedContract) {
        require(!AcademicArticlesCommon.IsContractConnected(connected, connectedContract), AcademicArticlesMessage.EXTERNAL_CONTRACT_ALREADY_CONNECTED);
        _;
    }

    modifier IsContractConnected(AcademicArticlesDataModel.Connected storage connected, address connectedContract) {
        require(AcademicArticlesCommon.IsContractConnected(connected, connectedContract), AcademicArticlesMessage.EXTERNAL_CONTRACT_IS_NOT_CONNECTED);
        _;
    }

    modifier IsNotArticlePublished(AcademicArticlesDataModel.Article storage article, bytes32 articleToken) { 
        require(article.publisher[articleToken] == address(0), AcademicArticlesMessage.ARTICLE_ALREADY_PUBLISHED);
        _;
    }

    modifier IsArticlePublished(AcademicArticlesDataModel.Article storage article, bytes32 articleToken) {
        require(article.publisher[articleToken] != address(0), AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED);
        _;
    }

    modifier IsArticlePublishedByMe(AcademicArticlesDataModel.Article storage article, bytes32 articleToken) {
        require(article.publisher[articleToken] == tx.origin, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}