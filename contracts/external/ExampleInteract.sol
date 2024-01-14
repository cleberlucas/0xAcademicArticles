// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleData.sol";
import "./ExampleLog.sol";
import "./ExampleModel.sol";
import "./ExampleCommon.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity ^0.8.23;

abstract contract ExampleInteract is ExampleData {

    function PublishArticles(ExampleModel.Article[] memory articles) 
    public payable {
        
        bytes32[] memory articlesIdentification = new bytes32[](articles.length);

        for (uint256 i = 0; i < articles.length; i++) {
            
            try _academicArticles.PublishArticle(abi.encode(articles[i])) {

                articlesIdentification[i] = keccak256(abi.encode(articles[i]));

                _publication.identifications.push(articlesIdentification[i]);

                _publication.publisher[articlesIdentification[i]] = msg.sender;

                _publication.dateTime[articlesIdentification[i]] = block.timestamp;

                _publication.blockNumber[articlesIdentification[i]] = block.number;

                _publication.valid[articlesIdentification[i]] = OWNER == msg.sender|| ExampleCommon.IsAffiliateLinked(_affiliate, msg.sender);

                _publication.identificationsOfPublisher[msg.sender].push(articlesIdentification[i]);
            }   catch Error(string memory errorMessage) {
                
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked("article already published"))) {
                        revert(string.concat("article[", Strings.toString(i), "]: ", errorMessage));
                    }

                    revert(errorMessage);
            }
        }

        emit ExampleLog.ArticlesPublished(articlesIdentification);
    }


    function UnpublishArticles(bytes32[] calldata articleIdentifications) 
    public payable {

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

    function ValidateArticles(bytes32[] calldata articleIdentifications) 
    public payable {
        
        require(OWNER == msg.sender || ExampleCommon.IsAffiliateLinked(_affiliate, msg.sender));

        for (uint256 i = 0; i < articleIdentifications.length; i++) {
            _publication.valid[articleIdentifications[i]] = true;
        }
        
        emit ExampleLog.ArticlesValidated(articleIdentifications);
    }

    function InvalidateArticles(bytes32[] calldata articleIdentifications) 
    public payable {
        
        require(OWNER == msg.sender || ExampleCommon.IsAffiliateLinked(_affiliate, msg.sender));

        for (uint256 i = 0; i < articleIdentifications.length; i++) {
            _publication.valid[articleIdentifications[i]] = false;
        }

        emit ExampleLog.ArticlesInvalidated(articleIdentifications);
    }

    function LinkAffiliates(address[] calldata affiliateAccounts) 
    public payable {

        require(OWNER == msg.sender);

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {
            _affiliate.accounts.push(affiliateAccounts[i]);
        }

        emit ExampleLog.AffiliatesLinked(affiliateAccounts);
    }

    function UnlinkAffiliates(address[] calldata affiliateAccounts) 
    public payable {

        require(OWNER == msg.sender);

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {

            for (uint256 ii = 0; ii < _affiliate.accounts.length; ii++) {
           
                if (_affiliate.accounts[ii] == affiliateAccounts[i]) {         

                    _affiliate.accounts[ii] = _affiliate.accounts[_affiliate.accounts.length - 1];
                    _affiliate.accounts.pop();
                }
            }
        }

        emit ExampleLog.AffiliatesUnlinked(affiliateAccounts);
    }

    function ChangeMe(ExampleDataModel.Me calldata me) 
    public payable {

        require(OWNER == msg.sender);

        _me = me;
       
        emit ExampleLog.MeChanged();
    }
}