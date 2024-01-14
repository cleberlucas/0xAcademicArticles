// SPDX-License-Identifier: MIT

import "./AcademicArticlesCommon.sol";
import "./AcademicArticlesMessage.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRules {

    modifier IsOwner(address ownerAccount) {

        require(ownerAccount == tx.origin, AcademicArticlesMessage.OWNER_ACTION);
        _;
    }

    modifier IsContract(address[] storage externalContracts, address contractAccount) {

        require(AcademicArticlesCommon.IsContractBinded(externalContracts, contractAccount), AcademicArticlesMessage.CONTRACT_ACTION);
        _;
    }

    modifier IsNotEntryArticleEncodeEmpty(bytes calldata articleEncode) {      

        require(articleEncode.length > 0, AcademicArticlesMessage.ENTRY_ARTICLE_ENCODE_EMPTY);
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

    modifier IsContractBinded(address[] storage externalContracts, address contractAccount) {

        require(AcademicArticlesCommon.IsContractBinded(externalContracts, contractAccount), AcademicArticlesMessage.CONTRACT_IS_NOT_BINDED);
        _;
    }

    modifier IsNotContractBinded(address[] storage externalContracts, address contractAccount) {

        require(!AcademicArticlesCommon.IsContractBinded(externalContracts, contractAccount), AcademicArticlesMessage.CONTRACT_ALREADY_BINDED);
        _;
    }

    modifier IsArticlePublished(bytes storage articleEncode) {

        require(articleEncode.length > 0, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED);
        _;
    }

    modifier IsNotArticlePublished(bytes storage articleEncode) { 

        require(articleEncode.length == 0, AcademicArticlesMessage.ARTICLE_ALREADY_PUBLISHED);
        _;
    }

    modifier IsArticlePublishedByMy(address articlePublisher) {
        require(articlePublisher == tx.origin, AcademicArticlesMessage.ARTICLE_IS_NOT_PUBLISHED_BY_YOU);
        _;
    }
}