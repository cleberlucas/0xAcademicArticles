// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

abstract contract ExampleLog {
    event ArticlesPublished(bytes32[] indexed articlesIdentification);
    event ArticlesUnpublished(bytes32[] indexed articlesIdentification);
    event ArticlesValidated(bytes32[] indexed articlesIdentification);
    event ArticlesInvalidated(bytes32[] indexed articlesIdentification);
    event AffiliatesLinked(address[] indexed affiliateAccount);
    event AffiliatesUnlinked(address[] indexed affiliateAccount);
}