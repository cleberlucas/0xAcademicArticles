// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library DuofranLog {
    event ArticlesPublished(bytes32[] indexed publicationIdentifications);
    event ArticlesUnpublished(bytes32[] indexed publicationIdentifications);
    event ArticlesValidated(bytes32[] indexed publicationIdentifications);
    event ArticlesInvalidated(bytes32[] indexed publicationIdentifications);
    event AffiliateLinked(address indexed affiliateAccount);
    event AffiliatesUnlinked(address[] indexed affiliateAccounts);
    event MeChanged();
}