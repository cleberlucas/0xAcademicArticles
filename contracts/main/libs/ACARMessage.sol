// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library ACARMessage {
    string public constant CONNECTED_CONTRACT_ACTION = "connected contract action";
    string public constant ARTICLE_DATA_IS_EMPTY = "article data is empty";
    string public constant CONTRACT_IS_NOT_SIGNED = "contracc is not signed";
    string public constant CONTRACT_IS_ALREADY_CONNECTED = "contract is already connected";
	string public constant CONTRACT_SIGNATURE_IS_ALREADY_USED = "contract signature is already used";
    string public constant ARTICLE_IS_ALREADY_PUBLISHED = "article is already published";
    string public constant ARTICLE_IS_NOT_PUBLISHED = "article is not published";
    string public constant ARTICLE_IS_NOT_PUBLISHED_BY_THIS_CONTRACT = "article is not published by this contract";
    string public constant ARTICLE_IS_NOT_PUBLISHED_BY_YOU = "article is not published by you";
}