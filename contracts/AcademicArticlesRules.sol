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

    modifier IsEntryContract(address interconnectionContract) {
        uint32 size;
        assembly {
            size := extcodesize(interconnectionContract)
        }
        require (size > 0, AcademicArticlesMessage.ENTRY_IS_NOT_A_CONTRACT);
        _;
    }

    modifier IsOwner() {
        require(OWNER == tx.origin, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsConnected(AcademicArticlesDataModel.Interconnection storage interconnection) {
        require(AcademicArticlesCommon.IsContractConnected(interconnection, msg.sender), AcademicArticlesMessage.CONNECTED_CONTRACT_ACTION);
        _;
    }

    modifier IsNotContractConnected(AcademicArticlesDataModel.Interconnection storage interconnection, address interconnectionContract) {
        require(!AcademicArticlesCommon.IsContractConnected(interconnection, interconnectionContract), AcademicArticlesMessage.CONTRACT_ALREADY_CONNECTED);
        _;
    }

    modifier IsContractConnected(AcademicArticlesDataModel.Interconnection storage interconnection, address interconnectionContract) {
        require(AcademicArticlesCommon.IsContractConnected(interconnection, interconnectionContract), AcademicArticlesMessage.CONTRACT_IS_NOT_CONNECTED);
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