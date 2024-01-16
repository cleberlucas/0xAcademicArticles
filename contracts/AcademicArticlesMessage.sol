// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AcademicArticlesMessage {
    string public constant ENTRY_ENCODED_IS_EMPTY = "entry encoded is empty";
    string public constant ENTRY_IS_NOT_A_CONTRACT = "entry is not a contract";
    string public constant OWNER_ACTION = "owner action";
    string public constant CONNECTED_CONTRACT_ACTION = "connected contract action";
    string public constant CONTRACT_ALREADY_CONNECTED = "contract already connected";
    string public constant CONTRACT_IS_NOT_CONNECTED = "contract is not connected";
    string public constant ARTICLE_ALREADY_PUBLISHED = "article already published";
    string public constant ARTICLE_IS_NOT_PUBLISHED = "article is not published";
    string public constant ARTICLE_IS_NOT_PUBLISHED_BY_YOU = "article is not published by you";
}