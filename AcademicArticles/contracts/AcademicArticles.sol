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
        signature = "AcademicArticles111111111";
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
    external {
        require (OWNER == msg.sender, "Owner action");

        IAIOInteract(account).Initialize();
        _aio.search = IAIOSearch(account);
        _aio.interact = IAIOInteract(account);
        _aio.account = account;

        emit ConnectedToAIO(account);
    }

    function TransferAIOSignature(address newSender) 
    external {
        require (OWNER == msg.sender, "Owner action");

        IAIOInteract(address(this)).TransferSignature(newSender);

        emit TransferredAIOSignature(newSender);
    }

    function PublishArticles(Article_Model[] calldata articles) 
    external {
        Publisher_AIOModel memory publisherAIO;
        address publisher = msg.sender;
        bytes32[] memory ids = new bytes32[](articles.length);
        bytes memory publisherAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publisher", bytes32(abi.encode(publisher)));

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
            bytes32[] memory newIds = new bytes32[](publisherAIO.ids.length + ids.length);

            publisherAIO = abi.decode(publisherAIOEncoded, (Publisher_AIOModel));

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
    external {
        Publisher_AIOModel memory publisherAIO ;
        bytes memory publisherAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publisher", bytes32(abi.encode(msg.sender)));

        if(publisherAIOEncoded.length > 0) {
            publisherAIO = abi.decode(publisherAIOEncoded, (Publisher_AIOModel));
        } else {
            revert ("You have nothing to unpublish");
        }

        for (uint i = 0; i < ids.length; i++) {
            bytes32 id = ids[i]; 
            bytes memory publicationEncode = _aio.search.Metadata(SIGNATURE(), "Publication", id);
            Publication_AIOModel memory publicationAIO = abi.decode(publicationEncode, (Publication_AIOModel));

            require (publicationEncode.length > 0, string.concat("Article[", Strings.toString(i), "] is not published"));
            require (publicationAIO.publisher == msg.sender, string.concat("Article[", Strings.toString(i), "] is not published by you"));

            _aio.interact.CleanMetadata("Publication", id);     
        }

        if (publisherAIO.ids.length == ids.length) {
            _aio.interact.CleanMetadata("Publisher", bytes32(abi.encode(msg.sender)));
        } else {  
            bytes32[] memory newIds = new bytes32[](publisherAIO.ids.length - ids.length);
            bool useId;
            uint i_;

            for (uint i = 0; i < publisherAIO.ids.length; i++) {
                useId = true;

                for (uint ii = 0; ii < ids.length; ii++) {
                    if (ids[ii] == publisherAIO.ids[i]) {
                        useId = false;

                        break;
                    }
                }

                if (useId) {
                    newIds[i_] = publisherAIO.ids[i];
                    i_ ++;
                }

                if (i_ == newIds.length) {
                    break;
                }
            }

            publisherAIO.ids = newIds;
            _aio.interact.UpdateMetadata("Publisher", bytes32(abi.encode(msg.sender)), abi.encode(publisherAIO));
        }

        emit ArticlesUnpublished(ids);
    }

    function PublisherAIO(address publisher) 
    external view 
    returns (Publisher_AIOModel memory publisherAIO) {
        bytes memory publisherAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publisher", bytes32(abi.encode(publisher)));

        if(publisherAIOEncoded.length > 0) {
            publisherAIO = abi.decode(publisherAIOEncoded, (Publisher_AIOModel));
        }
    }

    function Publication(bytes32 id) 
    external view 
    returns (Publication_AIOModel memory publication) {
        bytes memory publicationAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publication", id);

        if(publicationAIOEncoded.length > 0) {
            publication = abi.decode(publicationAIOEncoded, (Publication_AIOModel));
        }
    }

    function PreviewPublicationsWithTitle(string memory title, uint limit) 
    external view  
    returns (PublicationPreview_Model[] memory publicationsPreview) {
        bytes32[] memory publicationKeys = _aio.search.Keys(SIGNATURE(), "Publication");

        publicationsPreview = new PublicationPreview_Model[](limit);

        uint previewCount;
        for (uint i = 0; i < publicationKeys.length && previewCount < limit; i++) {
            bytes32 id = publicationKeys[i];
            Publication_AIOModel memory publication = abi.decode(_aio.search.Metadata(SIGNATURE(), "Publication", id), (Publication_AIOModel));
            string memory articleTitle = StringUtils.toLower(publication.article.title);

            if (StringUtils.contains(articleTitle, StringUtils.toLower(title))) {
                publicationsPreview[previewCount] = PublicationPreview_Model(articleTitle, id);
                previewCount++;
            }
        }

        if (previewCount < limit) {
            PublicationPreview_Model[] memory publicationsPreviewCopy = publicationsPreview;

            publicationsPreview = new PublicationPreview_Model[](previewCount);
            
            for (uint i = 0; i < previewCount; i++) {
                if (publicationsPreviewCopy[i].id != bytes32(0)) {
                    publicationsPreview[i] = publicationsPreviewCopy[i];
                } else {
                    break;
                }
            }
        }
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

    function PreviewPublicationsOfPublisher(address publisher, uint startIndex, uint endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint currentSize) {
        bytes memory publisherAIOEncoded = _aio.search.Metadata(SIGNATURE(), "Publisher", bytes32(abi.encode(publisher)));

        if(publisherAIOEncoded.length > 0) {
            Publisher_AIOModel memory publisherAIO = abi.decode(publisherAIOEncoded, (Publisher_AIOModel));
            
            currentSize = publisherAIO.ids.length;

            if (startIndex >= currentSize || startIndex > endIndex) {
                previewPublicationsOfPublisher = new PublicationPreview_Model[](0);
            } else {
                uint size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                previewPublicationsOfPublisher = new PublicationPreview_Model[](size); 
                
                for (uint i = 0; i < size; i++) {
                    previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                        abi.decode(_aio.search.Metadata(SIGNATURE(), "Publication", publisherAIO.ids[startIndex + i]), (Publication_AIOModel)).article.title,
                        publisherAIO.ids[startIndex + i]
                    );
                }
            }
        } 
    }
}