// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

abstract contract AcademicArticlesLog {
    event ArticlePublished(bytes32 indexed articleToken);
    event ArticleUnpublished(bytes32 indexed articleToken);
    event ContractBinded(address indexed contractAccount);
    event ContractUnbinded(address indexed contractAccount);
}