// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleData.sol";
import "./ExampleLog.sol";
import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleInteract is ExampleData {

    function PublishArticles(ExampleModel.Article[] memory articles) public payable {

        bytes32[] memory articlesIdentification = new bytes32[](articles.length);

        for (uint256 i = 0; i < articles.length; i++) {
            
            try _academicArticles.PublishArticle(abi.encode(articles[i])) {

                articlesIdentification[i] = keccak256(abi.encode(articles[i]));

                _publication.identifications.push(articlesIdentification[i]);

                _publication.identificationsOfPublisher[msg.sender].push(articlesIdentification[i]);

                _publication.publisher[articlesIdentification[i]] = msg.sender;

                _publication.datatime[articlesIdentification[i]] = block.timestamp;

                _publication.blockNumber[articlesIdentification[i]] = block.number;
            } 
            catch Error(string memory errorMessage) {

                revert(string(abi.encodePacked(articlesIdentification[i], " : ", errorMessage)));
            }
        }

        emit ExampleLog.ArticlesPublished(articlesIdentification);
    }


    function UnpublishArticles(bytes32[] calldata articleIdentifications) public payable {

        for (uint256 i = 0; i < articleIdentifications.length; i++) {

            for (uint256 ii = 0; ii < _publication.identifications.length; ii++) {

                if (_publication.identifications[ii] == articleIdentifications[i]) {

                    _academicArticles.UnpublishArticle(articleIdentifications[i]);

                    _publication.identifications[ii] = _publication.identifications[_publication.identifications.length - 1];
                    _publication.identifications.pop();             
                }
            }
        }

        emit ExampleLog.ArticlesUnpublished(articleIdentifications);
    }

/*
    function ValidateArticles(bytes32[] calldata articleIdentification) public payable {

        for (uint256 i = 0; i < articleIdentification.length; i++) {
        }
        
        emit ExampleLog.ArticlesValidated(articleIdentification);
    }

    function InvalidateArticles(bytes32[] calldata articleIdentification) public payable {

        for (uint256 i = 0; i < articleIdentification.length; i++) {
        }

        emit ExampleLog.ArticlesInvalidated(articleIdentification);
    }

    function LinkAffiliates(address[] calldata affiliateAccounts) public payable {

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {
            
        }

        emit ExampleLog.AffiliatesLinked(affiliateAccounts);
    }

    function UnlinkAffiliates(address[] calldata affiliateAccounts) public payable {

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {
            
        }

        emit ExampleLog.AffiliatesUnlinked(affiliateAccounts);
    }

*/
}