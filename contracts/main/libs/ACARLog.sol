// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library ACARLog {
    event ArticlePublished(bytes32 indexed articleToken);
    event ArticleUnpublished(bytes32 indexed articleToken);
    event ContractConnected(address indexed contractAccount);
    event ContractDisconnected(address indexed contractAccount);
}