// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranData.sol";
import "./DuofranLog.sol";
import "./DuofranModel.sol";
import "./DuofranCommon.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract DuofranInteract is DuofranData {
    function PublishArticles(DuofranModel.Article[] memory articles) 
    public payable {
        bytes32[] memory publicationIdentifications = new bytes32[](articles.length);
        bytes32 publicationIdentification;
        DuofranModel.Article memory article;

        for (uint256 i = 0; i < articles.length; i++) {
            article = articles[i];

            try _academicArticles.PublishArticle(abi.encode(article)) {
                publicationIdentification = keccak256(abi.encode(article));
                publicationIdentifications[i] = publicationIdentification;

                _publication.identifications.push(publicationIdentification);
                _publication.publisher[publicationIdentification] = msg.sender;
                _publication.dateTime[publicationIdentification] = block.timestamp;
                _publication.blockNumber[publicationIdentification] = block.number;
                _publication.valid[publicationIdentification] = OWNER == msg.sender|| DuofranCommon.IsAffiliateLinked(_affiliate, msg.sender);
                _publication.identificationsOfPublisher[msg.sender].push(publicationIdentification);

                if (_publication.valid[publicationIdentification]) {
                    _publication.identificationsValid.push(publicationIdentification);
                }

                if (_publication.identificationsOfPublisher[msg.sender].length == 1) {
                    _publication.publishers.push(msg.sender);
                }
            }   catch Error(string memory errorMessage) {
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked("article already published"))) {                    
                        revert(string.concat("article[", Strings.toString(i), "]: ", errorMessage));
                    }

                    revert(errorMessage);
            }
        }

        emit DuofranLog.ArticlesPublished(publicationIdentifications);
    }

    function UnpublishArticles(bytes32[] calldata publicationIdentifications) 
    public payable {
        address publisher;
        bytes32 publicationIdentification;

        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            publicationIdentification = publicationIdentifications[i];
            publisher = _publication.publisher[publicationIdentification];
     
            if (publisher != address(0)) {
                _publication.publisher[publicationIdentification] = address(0);
                _publication.dateTime[publicationIdentification] = 0;
                _publication.blockNumber[publicationIdentification] = 0;

                if (_publication.valid[publicationIdentification]) {
                    _publication.valid[publicationIdentification] = false;
                }

                for (uint256 ii = 0; ii < _publication.identifications.length; ii++) {
                    if (_publication.identifications[ii] == publicationIdentification) {
                        _academicArticles.UnpublishArticle(publicationIdentification);

                        _publication.identifications[ii] = _publication.identifications[_publication.identifications.length - 1];
                        _publication.identifications.pop();             
                    }
                }

                for (uint256 ii = 0; ii < _publication.identificationsValid.length; ii++) {
                    if (_publication.identificationsValid[ii] == publicationIdentification) {
                        _publication.identificationsValid[ii] = _publication.identificationsValid[_publication.identificationsValid.length - 1];
                        _publication.identificationsValid.pop();             
                    }
                }

                if (_publication.identificationsOfPublisher[publisher].length == 1) {
                    delete _publication.identificationsOfPublisher[publisher];

                    for (uint256 ii = 0; ii < _publication.publishers.length; ii++) {
                        if (_publication.publishers[ii] == publisher) {
                            _publication.publishers[ii] = _publication.publishers[_publication.publishers.length - 1];
                            _publication.publishers.pop();             
                        }
                    }
                }   else {
                        for (uint256 ii = 0; ii < _publication.identificationsOfPublisher[publisher].length; ii++) {
                            if (_publication.identificationsOfPublisher[publisher][ii] == publicationIdentification) {
                                _publication.identificationsOfPublisher[publisher][ii] = _publication.identificationsOfPublisher[publisher][_publication.identificationsOfPublisher[publisher].length - 1];
                                _publication.identificationsOfPublisher[publisher].pop();             
                            }
                        }
                }
            } 
        }

        emit DuofranLog.ArticlesUnpublished(publicationIdentifications);
    }

    function ValidateArticles(bytes32[] calldata publicationIdentifications) 
    public payable {
        require(OWNER == msg.sender || DuofranCommon.IsAffiliateLinked(_affiliate, msg.sender));

        bytes32 publicationIdentification;
        
        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            publicationIdentification = publicationIdentifications[i];

            if (!_publication.valid[publicationIdentification] && _publication.publisher[publicationIdentification] != address(0)) {
                _publication.valid[publicationIdentification] = true;           
                _publication.identificationsValid.push(publicationIdentification);
            }
        }
        
        emit DuofranLog.ArticlesValidated(publicationIdentifications);
    }

    function InvalidateArticles(bytes32[] calldata publicationIdentifications) 
    public payable {       
        require(OWNER == msg.sender || DuofranCommon.IsAffiliateLinked(_affiliate, msg.sender));

        bytes32 publicationIdentification;

        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            publicationIdentification = publicationIdentifications[i];

            if (_publication.valid[publicationIdentification] && _publication.publisher[publicationIdentification] != address(0)) {             
                _publication.valid[publicationIdentification] = false;

                for (uint256 ii = 0; ii < _publication.identificationsValid.length; ii++) {
                    if (_publication.identificationsValid[ii] == publicationIdentification) {
                        _publication.identificationsValid[ii] = _publication.identificationsValid[_publication.identificationsValid.length - 1];
                        _publication.identificationsValid.pop();
                        break;        
                    }
                }
            }    
        }

        emit DuofranLog.ArticlesInvalidated(publicationIdentifications);
    }

    function LinkAffiliates(address[] calldata affiliateAccounts) 
    public payable {
        require(OWNER == msg.sender);

        address affiliateAccount;

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {
            affiliateAccount = affiliateAccounts[i];

            if (!_affiliate.binded[affiliateAccount]) {
                _affiliate.binded[affiliateAccount] = true;
                _affiliate.accounts.push(affiliateAccount);
            }       
        }

        emit DuofranLog.AffiliatesLinked(affiliateAccounts);
    }

    function UnlinkAffiliates(address[] calldata affiliateAccounts) 
    public payable {
        require(OWNER == msg.sender);

        address affiliateAccount;

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {   
            affiliateAccount = affiliateAccounts[i];

            if (_affiliate.binded[affiliateAccount]) {
                for (uint256 ii = 0; ii < _affiliate.accounts.length; ii++) {       
                    if (_affiliate.accounts[ii] == affiliateAccount) {         
                        _affiliate.accounts[ii] = _affiliate.accounts[_affiliate.accounts.length - 1];
                        _affiliate.accounts.pop();
                    }
                }
            }
        }

        emit DuofranLog.AffiliatesUnlinked(affiliateAccounts);
    }

    function ChangeMe(DuofranDataModel.Me calldata me) 
    public payable {
        require(OWNER == msg.sender);

        _me = me;
       
        emit DuofranLog.MeChanged();
    }
}