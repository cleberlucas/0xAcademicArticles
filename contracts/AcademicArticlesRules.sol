// SPDX-License-Identifier: MIT

import "./AcademicArticlesCommon.sol";
import "./AcademicArticlesMessage.sol";
import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRules {

    address internal immutable OWNER;

    modifier IsNotEntryEncodeEmpty(bytes calldata encode) {      

        require(encode.length > 0, AcademicArticlesMessage.ENTRY_ENCODE_EMPTY);
        _;
    }

    modifier IsNotEntryAccountZero(address account) {    

        require(account != address(0), AcademicArticlesMessage.ENTRY_ACCOUNT_ZERO);
        _;
    }

    modifier IsEntryContract(address account) {

        uint32 size;
        assembly {
            size := extcodesize(account)
        }
        require (size > 0, AcademicArticlesMessage.ENTRY_IS_NOT_A_CONTRACT);
        _;
    }

    modifier IsOwner() {

        require(OWNER == tx.origin, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsExternalContract(AcademicArticlesDataModel.ExternalContract storage externalContract) {

        require(AcademicArticlesCommon.IsExternalContractBinded(externalContract, msg.sender), AcademicArticlesMessage.EXTERNAL_CONTRACT_ACTION);
        _;
    }

    modifier IsExternalContractEnabled(AcademicArticlesDataModel.ExternalContract storage externalContract) {

        require(externalContract.enable[msg.sender], AcademicArticlesMessage.EXTERNAL_CONTRACT_IS_DISABLED);
        _;
    }

    modifier IsNotExternalContractBinded(AcademicArticlesDataModel.ExternalContract storage externalContract, address externalContractAccount) {

        require(!AcademicArticlesCommon.IsExternalContractBinded(externalContract, externalContractAccount), AcademicArticlesMessage.EXTERNAL_CONTRACT_ALREADY_BINDED);
        _;
    }

    modifier IsNotExternalContractEnabled(AcademicArticlesDataModel.ExternalContract storage externalContract, address externalContractAccount) {

        require(!externalContract.enable[externalContractAccount], AcademicArticlesMessage.EXTERNAL_CONTRACT_ALREADY_ENABLED);
        _;
    }

    modifier IsNotExternalContractDisabled(AcademicArticlesDataModel.ExternalContract storage externalContract, address externalContractAccount) {

        require(externalContract.enable[externalContractAccount], AcademicArticlesMessage.EXTERNAL_CONTRACT_ALREADY_DISABLED);
        _;
    }

    modifier IsArticlePublished(AcademicArticlesDataModel.Article storage article, bytes32 articleToken) {

        require(article.publisher[articleToken] != address(0), AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED);
        _;
    }

    modifier IsNotArticlePublished(AcademicArticlesDataModel.Article storage article, bytes32 articleToken) { 

        require(article.publisher[articleToken] == address(0), AcademicArticlesMessage.ARTICLE_ALREADY_PUBLISHED);
        _;
    }

    modifier IsArticlePublishedByMy(AcademicArticlesDataModel.Article storage article, bytes32 articleToken) {

        require(article.publisher[articleToken] == tx.origin, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}