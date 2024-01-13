// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "../IAcademicArticles.sol";

pragma solidity ^0.8.23;

contract Example {
    struct Publication {
        Article content;
        bytes32 identification;
        address publisher;
        uint256 publicationTimestamp;
        uint256 blockNumber;
        bool valid;
    }

    struct PublicationSummary {
        string title;
        bool validated;
    }

    struct Article {
        string title;
        string summary;
        string additionalInfo;
        string institution;
        string course;
        string articleType;
        string academicDegree;
        string documentationUrl;
        string[] authors;
        string[] supervisors;
        string[] examiningBoard;
        int presentationYear;
    }

    struct Identity {
        string name;
        string logoUrl;
        string siteUrl;
        string requestEmail;
        string contactNumber;
    }

    struct DataModel {
        bytes32[] articleIdentifications;
        mapping(bytes32 => Publication) publication;
        address[] institutionAccounts;
        address[] affiliateAccounts;
        bytes32[] validatedArticleIdentifications;
        Identity identity;
    }

    event ArticlePublished(bytes32 indexed articleIdentification);
    event ArticleUnpublished(bytes32 indexed articleIdentification);
    event ArticleValidated(bytes32 indexed articleIdentification);
    event ArticleInvalidated(bytes32 indexed articleIdentification);
    event AffiliateLinked(address indexed affiliateAccount);
    event AffiliateUnlinked(address indexed affiliateAccount);

    address internal immutable CREATOR;

    constructor(address academicArticlesAddress) {
        CREATOR = tx.origin;
        _academicArticles = IAcademicArticles(academicArticlesAddress);
    }

    IAcademicArticles private _academicArticles;

    DataModel private _data;

    function PublishArticles(Article[] memory articles) public payable {
        for (uint256 i = 0; i < articles.length; i++) {
            _academicArticles.PublishArticle(string(abi.encode(articles[i])));

            bytes32 articleIdentification = keccak256(abi.encode(articles[i]));

            _data.articleIdentifications.push(articleIdentification);

            _data.publication[articleIdentification] = Publication(
                articles[i],
                articleIdentification,
                tx.origin,
                block.timestamp,
                block.number,
                false
            );

            emit ArticlePublished(articleIdentification);
        }
    }

    function UnpublishArticles(bytes32[] calldata articleIdentifications) public payable {
        for (uint256 i = 0; i < articleIdentifications.length; i++) {
            for (uint256 ii = 0; ii < _data.articleIdentifications.length; ii++) {
                if (_data.articleIdentifications[ii] == articleIdentifications[i]) {
                    _academicArticles.UnpublishArticle(articleIdentifications[i]);

                    _data.articleIdentifications[ii] = _data.articleIdentifications[_data.articleIdentifications.length - 1];
                    _data.articleIdentifications.pop();

                    emit ArticleUnpublished(articleIdentifications[i]);
                }
            }
        }
    }

    function ValidateArticles(bytes32[] calldata articleIdentification) public payable {
        for (uint256 i = 0; i < articleIdentification.length; i++) {
            emit ArticleValidated(articleIdentification[i]);
        }
    }

    function InvalidateArticles(bytes32[] calldata articleIdentification) public payable {
        for (uint256 i = 0; i < articleIdentification.length; i++) {
            emit ArticleInvalidated(articleIdentification[i]);
        }
    }

    function LinkAffiliates(address[] calldata affiliateAccounts) public payable {
        for (uint256 i = 0; i < affiliateAccounts.length; i++) {
            
            emit AffiliateLinked(affiliateAccounts[i]);
        }
    }

    function UnlinkAffiliates(address[] calldata affiliateAccounts) public payable {
        for (uint256 i = 0; i < affiliateAccounts.length; i++) {
            
            emit AffiliateUnlinked(affiliateAccounts[i]);
        }
    }

    function ViewPublication(bytes32 articleIdentification) public view returns (Publication memory result) {
        result = _data.publication[articleIdentification];
    }

    function ViewPublicationSummaries(uint256 startIndex, uint256 endIndex) public view returns (PublicationSummary[] memory result, uint256 currentSize) {
        currentSize = _data.articleIdentifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new PublicationSummary[](0);
        } else {
            uint256 size = endIndex - startIndex + 1;
            uint256 correctedSize = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            result = new PublicationSummary[](correctedSize);

            for (uint256 i = 0; i < correctedSize; i++) {
                result[i] = PublicationSummary(
                    _data.publication[_data.articleIdentifications[startIndex + i]].content.title,
                    _data.publication[_data.articleIdentifications[startIndex + i]].valid
                );
            }
        }
    }
}
