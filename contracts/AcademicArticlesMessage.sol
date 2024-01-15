// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library AcademicArticlesMessage {

    string public constant ENTRY_ENCODE_EMPTY = "entry encode empty";
    string public constant ENTRY_ACCOUNT_ZERO = "entry account zero";
    string public constant ENTRY_IS_NOT_A_CONTRACT = "entry is not a contract";
    string public constant OWNER_ACTION = "owner action";
    string public constant EXTERNAL_CONTRACT_ACTION = "external contract action";
    string public constant EXTERNAL_CONTRACT_IS_DISABLED = "external contract is disabled";
    string public constant EXTERNAL_CONTRACT_ALREADY_BINDED = "external contract already binded";
	string public constant EXTERNAL_CONTRACT_IS_NOT_BINDED = "external contract is not binded";
    string public constant EXTERNAL_CONTRACT_ALREADY_ENABLED = "external contract already enabled";
    string public constant EXTERNAL_CONTRACT_ALREADY_DISABLED = "external contract already disabled";
    string public constant ARTICLE_ALREADY_PUBLISHED = "article already published";
    string public constant ARTICLE_IS_NOT_PUBLISHED = "article is not published";
    string public constant ARTICLE_IS_NOT_PUBLISHED_BY_YOU = "article is not published by you";
}