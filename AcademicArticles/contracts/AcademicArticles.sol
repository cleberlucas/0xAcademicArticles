// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../../AIO/contracts/interfaces/IAIOInteract.sol";
import "../../AIO/contracts/interfaces/IAIOInterconnection.sol";
import "../../AIO/contracts/interfaces/IAIOSearch.sol";
import "../../AIO/contracts/interfaces/IAIOSignature.sol";
import "../../AIO/contracts/libs/AIOMessage.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

// Created by Cleber Lucas
contract AcademicArticles is IAIOSignature {
    function SIGNATURE() 
    external pure 
    returns (string memory signature) {
        signature = "AcademicArticles";
    }

    struct Publication_Model {
        Article_Model article;
        address publisher;
        uint datetime;
        uint blockNumber;
    }

    struct PublicationPreview_Model {
        string title;
        bytes32 identification;
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

    struct Publication_StorageModel {
        bytes32[] identifications;
        address[] publishers;
        mapping(bytes32 identification => address) publisher;
        mapping(bytes32 identification => uint) datetime;
        mapping(bytes32 identification => uint) blockNumber;
        mapping(address publisher => bytes32[]) identificationsOfPublisher;
    }

    struct AIO_StorageModel {     
        address account;
        IAIOSearch articlesSearch;
        IAIOInteract articlesInteract;
    }

    event ArticlesPublished(bytes32[] indexed publicationIdentifications);
    event ArticlesUnpublished(bytes32[] indexed publicationIdentifications);
    event ConnectedToAIO(address indexed account);
    event TransferredAIOSignature(address indexed newSender);

    Publication_StorageModel internal _publication;
    AIO_StorageModel internal _aio;

    address immutable OWNER;

    constructor(){
        OWNER = msg.sender;
    }
  
    function ConnectToAIO(address account) 
    external payable {
        require (OWNER == msg.sender, "Owner action");

        IAIOInterconnection(account).Initialize();
        _aio.articlesSearch = IAIOSearch(account);
        _aio.articlesInteract = IAIOInteract(account);
        _aio.account = account;

        emit ConnectedToAIO(account);
    }

    function TransferAIOSignature(address newSender) 
    external payable {
        require (OWNER == msg.sender, "Owner action");

        IAIOInterconnection(address(this)).TransferSignature(newSender);

        emit TransferredAIOSignature(newSender);
    }

    function Publication(bytes32 publicationIdentification) 
    external view 
    returns (Publication_Model memory publication) {
        publication = Publication_Model(
            abi.decode(_aio.articlesSearch.MetaData(publicationIdentification), (Article_Model)),
            _publication.publisher[publicationIdentification],
            _publication.datetime[publicationIdentification],
            _publication.blockNumber[publicationIdentification]
        );
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint256 currentSize) {     
        currentSize = _publication.identifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            publicationsPreview = new PublicationPreview_Model[](0);
        }   else {
                uint256 size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                publicationsPreview = new PublicationPreview_Model[](size); 
                
                for (uint256 i = 0; i < size; i++) {
                    publicationsPreview[i] = PublicationPreview_Model(
                        abi.decode(_aio.articlesSearch.MetaData(_publication.identifications[startIndex + i]), (Article_Model)).title,
                        _publication.identifications[startIndex + i]
                    );
                }
        }
    }

    function PreviewPublicationsOfPublisher(address publicationPublisher, uint256 startIndex, uint256 endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint256 currentSize) {     
        currentSize = _publication.identificationsOfPublisher[publicationPublisher].length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            previewPublicationsOfPublisher = new PublicationPreview_Model[](0);
        }   else {
                uint256 size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                previewPublicationsOfPublisher = new PublicationPreview_Model[](size); 
                
                for (uint256 i = 0; i < size; i++) {
                    previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                        abi.decode(_aio.articlesSearch.MetaData(_publication.identificationsOfPublisher[publicationPublisher][startIndex + i]), (Article_Model)).title,
                        _publication.identificationsOfPublisher[publicationPublisher][startIndex + i]
                    );
                }
        }
    }

    function PublishArticles(Article_Model[] calldata articles) 
    external payable {
        address publisher = msg.sender;
        bytes32[] memory publicationIdentifications = new bytes32[](articles.length);

        for (uint256 i = 0; i < articles.length; i++) {
            Article_Model memory article = articles[i];

            try _aio.articlesInteract.SendMetaData(abi.encode(article)) {
                bytes32 publicationIdentification = keccak256(abi.encode(article));

                _publication.identifications.push(publicationIdentification);
                _publication.publisher[publicationIdentification] = publisher;
                _publication.datetime[publicationIdentification] = block.timestamp;
                _publication.blockNumber[publicationIdentification] = block.number;
                _publication.identificationsOfPublisher[publisher].push(publicationIdentification);

                if (_publication.identificationsOfPublisher[publisher].length == 1) {
                    _publication.publishers.push(publisher);
                }

                publicationIdentifications[i] = publicationIdentification;
            }   catch Error(string memory errorMessage) {
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_ALREADY_SENT))) {                    
                        revert(string.concat("article[", Strings.toString(i), "]: ", "Article already published"));
                    }

                    revert(errorMessage);
            }
        }

        emit ArticlesPublished(publicationIdentifications);
    }

    function UnpublishArticles(bytes32[] memory publicationIdentifications) 
    external payable {
        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            bytes32 publicationIdentification = publicationIdentifications[i];
            address publisher = _publication.publisher[publicationIdentification];

            require (publisher != address(0), "Article is not published");
            require (publisher == msg.sender, "Article is not published by you");

            try _aio.articlesInteract.CleanMetaData(publicationIdentification) {
                _publication.publisher[publicationIdentification] = address(0);
                _publication.datetime[publicationIdentification] = 0;
                _publication.blockNumber[publicationIdentification] = 0;

                for (uint256 ii = 0; ii < _publication.identifications.length; ii++) {
                    if (_publication.identifications[ii] == publicationIdentification) {
                        _publication.identifications[ii] = _publication.identifications[_publication.identifications.length - 1];
                        _publication.identifications.pop();             
                    }
                }

                if (_publication.identificationsOfPublisher[publisher].length == 1) {
                    _publication.identificationsOfPublisher[publisher] = new bytes32[](0);

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
                      
            }   catch Error(string memory errorMessage) {
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_NOT_SENT))) {                    
                        revert(string.concat("article[", Strings.toString(i), "]: ", "Article is not published"));
                    }   else {
                            if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_NOT_SENT_BY_YOU))) {                    
                                revert(string.concat("article[", Strings.toString(i), "]: ", "Article is not published here"));
                            }
                    }

                    revert(errorMessage);
            }
        }

        emit ArticlesUnpublished(publicationIdentifications);
    }
}
