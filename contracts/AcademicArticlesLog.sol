// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

abstract contract AcademicArticlesLog {
    event ArticlePublished(bytes32 indexed articleToken);
    event ArticleUnpublished(bytes32 indexed articleToken);
    event ArticleStamped(bytes32 indexed articleToken);
    event ArticleUnstamped(bytes32 indexed articleToken);
    event InstitutionRegistered(address indexed institutionAccount);
    event InstitutionUnregistered(address indexed institutionAccount);
    event AffiliateLinked(address indexed affiliateAccount);
    event AffiliateUnlinked(address indexed affiliateAccount);
    event ContractAdded(address indexed contractAccount);
    event ContractRemoved(address indexed contractAccount);
}