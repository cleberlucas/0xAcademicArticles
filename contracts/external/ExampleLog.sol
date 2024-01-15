// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library ExampleLog {

    event ArticlesPublished(bytes32[] indexed publicationIdentifications);
    event ArticlesUnpublished(bytes32[] indexed publicationIdentifications);
    event ArticlesValidated(bytes32[] indexed publicationIdentifications);
    event ArticlesInvalidated(bytes32[] indexed publicationIdentifications);
    event AffiliatesLinked(address[] indexed affiliateAccount);
    event AffiliatesUnlinked(address[] indexed affiliateAccount);
    event MeChanged();
}