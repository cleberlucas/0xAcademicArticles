// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

abstract contract AcademicArticlesLog {
    event InstitutionRegistered(address indexed institutionAccount);

    event InstitutionUnregistered(address indexed institutionAccount);

    event AffiliateLinked(address indexed affiliateAccount);

    event AffiliateUnlinked(address indexed affiliateAccount);

    event ArticleValidated(bytes32 indexed articleToken);

    event ArticleInvalidated(bytes32 indexed articleToken);

    event ArticlePublished(bytes32 indexed articleToken);

    event ArticleUnpublished(bytes32 indexed articleToken);
}
