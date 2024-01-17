// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AcademicArticlesMessage {
    string public constant ARTICLE_DATA_INPUTED_IS_EMPTY = "article data inputed is empty";
    string public constant CONTRACT_NAME_INPUTED_IS_EMPTY = "contract name inputed is empty";
    string public constant CONTRACT_ACCOUNT_INPUTED_IS_NOT_A_CONTRACT = "contract account inputed is not a contract";
    string public constant OWNER_ACTION = "owner action";
    string public constant CONNECTED_CONTRACT_ACTION = "connected contract action";
    string public constant CONTRACT_ALREADY_CONNECTED = "contract already connected";
    string public constant CONTRACT_IS_NOT_CONNECTED = "contract is not connected";
    string public constant ARTICLE_ALREADY_PUBLISHED = "article already published";
    string public constant ARTICLE_IS_NOT_PUBLISHED = "article is not published";
    string public constant ARTICLE_IS_NOT_PUBLISHED_BY_YOU = "article is not published by you";
}