// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../../AIO/contracts/interfaces/IAIOInteract.sol";
import "../../AIO/contracts/interfaces/IAIOSearch.sol";
import "../../AIO/contracts/interfaces/IAIOSignature.sol";
import "../../AIO/contracts/libs/AIOMessage.sol";
import "../../String/contracts/libs/StringUtils.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

// Created by Cleber Lucas
contract AcademicArticles is IAIOSignature{
    function SIGNATURE() 
    public pure 
    returns (bytes32 signature) {
        signature = "AcademicArticles";
    }

    struct AIO_StorageModel {     
        address account;
        IAIOSearch search;
        IAIOInteract interact;
    }

    struct Publication_AIOModel {
        Article_Model article;
        address publisher;
        uint datetime;
        uint blockNumber;
    }

    struct Publisher_AIOModel {
        bytes32[] ids;
    }

    struct Article_Model {
        string title;
        string summary;
        string additionalInfo;
        string institution;
        string course;
        string articleType;
        string academicDegree;
        string documentationUrl;
        string[] authors;
        string[] advisors;
        string[] examiningBoard;
        uint16 presentationYear;
    }

    struct PublicationPreview_Model {
        string title;
        bytes32 id;
    }

    event ArticlesPublished(bytes32[] indexed ids);
    event ArticlesUnpublished(bytes32[] indexed ids);
    event ConnectedToAIO(address indexed account);
    event TransferredAIOSignature(address indexed newSender);

    AIO_StorageModel internal _aio;

    address immutable OWNER;

    constructor(){
        OWNER = msg.sender;
    }
  
    function ConnectToAIO(address account) 
    external payable {
        require (OWNER == msg.sender, "Owner action");

        IAIOInteract(account).Initialize();
        _aio.search = IAIOSearch(account);
        _aio.interact = IAIOInteract(account);
        _aio.account = account;

        emit ConnectedToAIO(account);
    }

    function TransferAIOSignature(address newSender) 
    external payable {
        require (OWNER == msg.sender, "Owner action");

        IAIOInteract(address(this)).TransferSignature(newSender);

        emit TransferredAIOSignature(newSender);
    }

    function PublishArticles(Article_Model[] calldata articles) 
    external payable {
        address publisher = msg.sender;
        bytes32[] memory ids = new bytes32[](articles.length);
        bytes memory publisherAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publisher", bytes32(abi.encode(publisher)));
        Publisher_AIOModel memory publisherAIO;

        for (uint i = 0; i < articles.length; i++) {
            bytes32 id = keccak256(abi.encode(articles[i]));
            Publication_AIOModel memory publication;

            publication.article = articles[i];
            publication.publisher = publisher;
            publication.datetime = block.timestamp;
            publication.blockNumber = block.number;

            try _aio.interact.SendMetadata("Publication", id, abi.encode(publication)) {
            } catch Error(string memory errorMessage) {
                if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_ALREADY_SENT))) {
                    revert(string.concat("Article[", Strings.toString(i), "] already published"));          
                } else {
                    revert( errorMessage);
                }
            }
            
            ids[i] = id;
        }

        if (publisherAIOEncoded.length > 0) {
            publisherAIO = abi.decode(publisherAIOEncoded, (Publisher_AIOModel));

            bytes32[] memory newIds = new bytes32[](publisherAIO.ids.length + ids.length);

            for (uint i = 0; i < newIds.length; i++) {
                if (i < publisherAIO.ids.length) {
                    newIds[i] = publisherAIO.ids[i];
                } else {
                    newIds[i] = publisherAIO.ids[i - publisherAIO.ids.length];
                }
            }

            publisherAIO.ids = newIds;
            
            _aio.interact.UpdateMetadata("Publisher", bytes32(abi.encode(publisher)), abi.encode(publisherAIO));
        } else {
            publisherAIO.ids = ids;

            publisherAIOEncoded = abi.encode(publisherAIO);
            _aio.interact.SendMetadata("Publisher", bytes32(abi.encode(publisher)), abi.encode(publisherAIO));
        }

        emit ArticlesPublished(ids);
    }


    function UnpublishArticles(bytes32[] memory ids) 
    external payable {
        Publisher_AIOModel memory publisherAIO ;
        bytes memory publisherAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publisher", bytes32(abi.encode(msg.sender)));

        if(publisherAIOEncoded.length > 0) publisherAIO = abi.decode(publisherAIOEncoded, (Publisher_AIOModel));

        for (uint i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            
            bytes memory publicationEncode = _aio.search.Metadata(SIGNATURE(), "Publication", id);
            require (publicationEncode.length > 0, string.concat("Article[", Strings.toString(i), "] is not published"));

            Publication_AIOModel memory publicationAIO = abi.decode(publicationEncode, (Publication_AIOModel));
            require (publicationAIO.publisher == msg.sender, string.concat("Article[", Strings.toString(i), "] is not published by you"));

            try _aio.interact.CleanMetadata("Publication", id) {
                if (publisherAIO.ids.length == ids.length && i == 0) {
                    _aio.interact.CleanMetadata("Publisher", bytes32(abi.encode(msg.sender)));
                } else if (publisherAIO.ids.length != ids.length) {
             
                    uint indexToRemove;

                    for (uint ii = 0; ii < publisherAIO.ids.length; ii++) {
                        if (publisherAIO.ids[ii] == id) {
                            indexToRemove = ii;
                            break;
                        }
                    }

                    if (indexToRemove < publisherAIO.ids.length) {
                        bytes32[] memory newIds = new bytes32[](publisherAIO.ids.length - 1);

                        for (uint ii = 0; ii < indexToRemove; ii++) {
                            newIds[ii] = publisherAIO.ids[ii];
                        }

                        for (uint ii = indexToRemove + 1; ii < publisherAIO.ids.length; ii++) {
                            newIds[ii - 1] = publisherAIO.ids[ii];
                        }

                        publisherAIO.ids = newIds;
                    }
                } 
            } catch Error(string memory errorMessage) {
                revert(string.concat(errorMessage));
            }

            _aio.interact.UpdateMetadata("Publisher", bytes32(abi.encode(msg.sender)), abi.encode(publisherAIO));
        }

        emit ArticlesUnpublished(ids);
    }

/*
    function Publication(bytes32 id) 
    external view 
    returns (Publication_AIOModel memory publication) {
        publication = abi.decode(_aio.search.Metadata(SIGNATURE(), "Publication", id), (Publication_AIOModel));
    }

    function PreviewPublications(uint startIndex, uint endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint currentSize) {     
        currentSize = _aio.search.Keys(SIGNATURE(), "Publication").length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            publicationsPreview = new PublicationPreview_Model[](0);
        } else {
            uint size = endIndex - startIndex + 1;
            
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
            publicationsPreview = new PublicationPreview_Model[](size); 
            
            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = PublicationPreview_Model(
                    abi.decode(_aio.search.Metadata(SIGNATURE(), "Publication", _aio.search.Keys(SIGNATURE(), "Publication")[startIndex + i]), (Publication_AIOModel)).article.title,
                    _aio.search.Keys(SIGNATURE(), "Publication")[startIndex + i]
                );
            }
        }
    }

    function PreviewPublicationsWithTitle(string memory pattern, uint limit) 
    external view 
    returns (PublicationPreview_Model[] memory publicationsPreview) {
        uint size;
        for (uint i = 0; i < _aio.search.Keys(SIGNATURE(), "Publication").length; i++) {
            if (limit == size) break;

            string memory title = abi.decode(
                _aio.search.Metadata(
                    SIGNATURE(),
                    "Publication", 
                    _aio.search.Keys(SIGNATURE(), "Publication")[i]
                ), (Publication_AIOModel)
            ).article.title;

            if (StringUtils.contains(StringUtils.toLower(title), StringUtils.toLower(pattern))) {
                publicationsPreview[i] = PublicationPreview_Model(title, _aio.search.Keys(SIGNATURE(), "Publication")[i]);
                size ++;
            }
        }       
    }

    function PreviewPublicationsOfPublisher(address publicationPublisher, uint startIndex, uint endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint currentSize) {
        Publisher_AIOModel memory publisherAIO = abi.decode(_aio.search.Metadata("Publisher"),(Publisher_AIOModel));

        currentSize = publisherAIO.ids.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            previewPublicationsOfPublisher = new PublicationPreview_Model[](0);
        } else {
            uint size = endIndex - startIndex + 1;
            
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
            previewPublicationsOfPublisher = new PublicationPreview_Model[](size); 
            
            for (uint i = 0; i < size; i++) {
                previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                    abi.decode(_aio.search.Metadata(publisherAIO.ids[startIndex + i]), (Publication_AIOModel)).article.title,
                    publisherAIO.ids[startIndex + i]
                );
            }
        }
    }

    function PublishArticles(Article_Model[] calldata articles) 
    external payable {
        Publisher_AIOModel memory publisherAIO = abi.decode(_aio.search.Metadata("AcademicArticles.Publisher"),(Publisher_AIOModel));
        address publisher = msg.sender;
        bytes32[] memory ids = new bytes32[](articles.length);

        for (uint i = 0; i < articles.length; i++) {
            Publication_AIOModel memory publication;

            publication.article = articles[i];
            publication.publisher = publisher;
            publication.datetime = block.timestamp;
            publication.blockNumber = block.number;

            try _aio.interact.SendMetadata(keccak256(abi.encode(publication)), abi.encode(publication)) {
                bytes32 id = keccak256(abi.encode(publication));

                publisherAIO.ids[0] = (id);

                if (publisherAIO.ids.length == 1) {
                    publisherAIO.ids[0] = (id);
                }

                ids[i] = id;
            } catch Error(string memory errorMessage) {
                if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_ALREADY_SENT))) {                    
                    revert(string.concat("Article[", Strings.toString(i), "]: already published"));
                }

                revert(errorMessage);
            }
        }

        emit ArticlesPublished(ids);
    }


    function UnpublishArticles(bytes32[] memory ids) 
    external payable {
        Publisher_AIOModel memory publisherAIO = abi.decode(_aio.search.Metadata("AcademicArticles.Publisher"),(Publisher_AIOModel));

        for (uint i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            address publisher = abi.decode(_aio.search.Metadata(SIGNATURE(), "Publication", id), (Publication_AIOModel)).publisher;

            require (publisher != address(0), "Article is not published");
            require (publisher == msg.sender, "Article is not published by you");

            try _aio.interact.CleanMetadata(SIGNATURE(), "Publication", id) {
                if (publisherAIO.ids.length == 1) {
                    publisherAIO.ids = new bytes32[](0);

                    for (uint ii = 0; ii < publisherAIO.accounts.length; ii++) {
                        if (publisherAIO.accounts[ii] == publisher) {
                            publisherAIO.accounts[ii] = publisherAIO.accounts[publisherAIO.accounts.length - 1];
                            publisherAIO.accounts.pop();

                            break;   
                        }
                    }
                } else {
                    for (uint ii = 0; ii < publisherAIO.ids.length; ii++) {
                        if (publisherAIO.ids[ii] == id) {
                            publisherAIO.ids[ii] = publisherAIO.ids[publisherAIO.ids.length - 1];
                            publisherAIO.ids.pop();

                            break;        
                        }
                    }
                }              
            } catch Error(string memory errorMessage) {
                if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_NOT_SENT))) {                    
                    revert(string.concat("Article[", Strings.toString(i), "]: is not published"));
                } else {
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_NOT_SENT_BY_YOU))) {                    
                        revert(string.concat("Article[", Strings.toString(i), "]: is not published here"));
                    }
                }

                revert(errorMessage);
            }
        }

        emit ArticlesUnpublished(ids);
    }

    */
}