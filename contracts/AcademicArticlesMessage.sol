// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.23;

library AcademicArticlesMessage {

    string public constant OWNER_ACTION = "owner action";
    string public constant CONTRACT_ACTION = "contract action";
    string public constant ENTRY_ARTICLE_ENCODE_EMPTY = "entry article encode empty";
    string public constant ENTRY_ACCOUNT_EMPTY = "entry account empty";
    string public constant ENTRY_ACCOUNT_IS_NOT_A_CONTRACT = "entry account is not a contract";
    string public constant CONTRACT_ALREADY_BINDED = "contract already binded";
    string public constant CONTRACT_IS_NOT_BINDED = "contract is not binded";
    string public constant ARTICLE_ALREADY_PUBLISHED = "article already published";
    string public constant ARTICLE_IS_NOT_PUBLISHED = "article is not published";
    string public constant ARTICLE_IS_NOT_PUBLISHED_BY_YOU = "article is not published by you";
}