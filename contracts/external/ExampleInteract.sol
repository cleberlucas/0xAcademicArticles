// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleData.sol";
import "./ExampleLog.sol";
import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleInteract is ExampleData, ExampleLog{
    function PublishArticles(ExampleModel.Article[] memory articles) public payable {
        for (uint256 i = 0; i < articles.length; i++) {
            _academicArticles.PublishArticle(string(abi.encode(articles[i])));

            bytes32 articleIdentification = keccak256(abi.encode(articles[i]));

            _publication.articleIdentifications.push(articleIdentification);

            _publication.publication[articleIdentification] = ExampleModel.Publication(
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
            for (uint256 ii = 0; ii < _publication.articleIdentifications.length; ii++) {
                if (_publication.articleIdentifications[ii] == articleIdentifications[i]) {
                    _academicArticles.UnpublishArticle(articleIdentifications[i]);

                    _publication.articleIdentifications[ii] = _publication.articleIdentifications[_publication.articleIdentifications.length - 1];
                    _publication.articleIdentifications.pop();

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
}