// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library AcademicArticlesLog {

    event ArticlePublished(bytes32 indexed articleToken);
    event ArticleUnpublished(bytes32 indexed articleToken);
    event ExternalContractBinded(address indexed externalContractAccount);
    event ExternalContractUnbinded(address indexed externalContractAccount);
    event ExternalContractEnabled(address indexed externalContractAccount);
    event ExternalContractDisabled(address indexed externalContractAccount);
}