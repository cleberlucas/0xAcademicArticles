// SPDX-License-Identifier: MIT

import "./AcademicArticlesCommon.sol";
import "./AcademicArticlesMessage.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRules is AcademicArticlesCommon {
    modifier IsOwner() {
        require(OWNER == tx.origin, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsContract(address contractAccount) {
        require(IsContractBinded_(contractAccount), AcademicArticlesMessage.CONTRACT_ACTION);
        _;
    }

    modifier IsNotEntryArticleEncodeEmpty(bytes calldata articleEncode) {       
        require(articleEncode.length > 0, AcademicArticlesMessage.ENTRY_ARTICLE_ABI_EMPTY);
        _;
    }

    modifier IsNotEntryAccountEmpty(address account) {       
        require(account != address(0), AcademicArticlesMessage.ENTRY_ACCOUNT_EMPTY);
        _;
    }

    modifier IsAccountContract(address account) {
        uint32 size;
        assembly {
            size := extcodesize(account)
        }
        require (size > 0, AcademicArticlesMessage.ENTRY_ACCOUNT_IS_NOT_A_CONTRACT);
        _;
    }

    modifier IsContractBinded(address contractAccount) {
        require(IsContractBinded_(contractAccount), AcademicArticlesMessage.CONTRACT_WAS_NOT_BINDED);
        _;
    }

    modifier IsNotContractBinded(address contractAccount) {
        require(!IsContractBinded_(contractAccount), AcademicArticlesMessage.CONTRACT_ALREADY_BINDED);
        _;
    }

    modifier IsArticlePublished(bytes32 articleToken, address contractAccount) {
        require(_article.encode[articleToken][contractAccount].length > 0, AcademicArticlesMessage.ARTICLE_WAS_NOT_PUBLISHED);
        _;
    }

    modifier IsNotArticlePublished(bytes32 articleToken, address contractAccount) { 
        require(_article.encode[articleToken][contractAccount].length == 0, AcademicArticlesMessage.ARTICLE_WAS_NOT_PUBLISHED);
        _;
    }

    modifier IsArticlePublishedByMy(bytes32 articleToken) {
        require(_article.publisher[articleToken] == tx.origin, AcademicArticlesMessage.ARTICLE_WAS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}