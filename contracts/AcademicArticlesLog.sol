// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AcademicArticlesLog {
    event ArticlePublished(bytes32 indexed articleToken);
    event ArticleUnpublished(bytes32 indexed articleToken);
    event ContractConnected(address indexed interconnectionContract);
    event ContractDisconnected(address indexed interconnectionContract);
}