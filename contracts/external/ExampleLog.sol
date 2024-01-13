// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

abstract contract ExampleLog {
    event ArticlePublished(bytes32 indexed articleIdentification);
    event ArticleUnpublished(bytes32 indexed articleIdentification);
    event ArticleValidated(bytes32 indexed articleIdentification);
    event ArticleInvalidated(bytes32 indexed articleIdentification);
    event AffiliateLinked(address indexed affiliateAccount);
    event AffiliateUnlinked(address indexed affiliateAccount);
}