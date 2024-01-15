// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library ExampleLog {

    event PublicationsPublished(bytes32[] indexed publicationIdentifications);
    event PublicationsUnpublished(bytes32[] indexed publicationIdentifications);
    event PublicationsValidated(bytes32[] indexed publicationIdentifications);
    event PublicationsInvalidated(bytes32[] indexed publicationIdentifications);
    event AffiliatesLinked(address[] indexed affiliateAccount);
    event AffiliatesUnlinked(address[] indexed affiliateAccount);
    event MeChanged();
}