// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library AcademicArticlesMessage {
    string public constant OWNER_ACTION = "owner action";
    string public constant CONTRACT_ACTION = "contract action";
    string public constant ENTRY_ARTICLE_ABI_EMPTY = "entry article abi empty";
    string public constant ENTRY_ACCOUNT_EMPTY = "entry account empty";
    string public constant ENTRY_ACCOUNT_IS_NOT_A_CONTRACT = "entry account is not a contract";
    string public constant CONTRACT_ALREADY_BINDED = "contract already binded";
    string public constant CONTRACT_WAS_NOT_BINDED = "contract was not binded";
    string public constant ARTICLE_ALREADY_PUBLISHED = "article already published";
    string public constant ARTICLE_WAS_NOT_PUBLISHED = "article was not published";
    string public constant ARTICLE_WAS_NOT_PUBLISHED_BY_YOU = "article was not published by you";
}