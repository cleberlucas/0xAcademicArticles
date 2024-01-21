// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../AIO/interfaces/IAIOInteract.sol";
import "../AIO/interfaces/IAIOInterconnection.sol";
import "../AIO/interfaces/IAIOSearch.sol";
import "../AIO/interfaces/IAIOSignature.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

// Created by Cleber Lucas
contract OpenAcademicArticles is IAIOSignature {
    struct Publication_Model {
        Article_Model article;
        address publisher;
        uint256 datatime;
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
        int presentationYear;
    }

    struct Publication_StorageModel {
        bytes32[] identifications;
        address[] publishers;
		mapping(bytes32 identification => address) publisher;
        mapping(bytes32 identification => uint256) dateTime;
        mapping(bytes32 identification => uint256) blockNumber;
		mapping(address publisher => bytes32[]) identificationsOfPublisher;
    }

    event ArticlesPublished(bytes32[] indexed publicationIdentifications);
    event ArticlesUnpublished(bytes32[] indexed publicationIdentifications);

    address immutable AIO;
    bool connectedInAIO;

    IAIOSearch internal immutable _articlesSearch;
    IAIOInteract internal immutable _articlesInteract;

    Publication_StorageModel internal _publication;

    constructor(address aio) {
        AIO = aio;
        _articlesSearch = IAIOSearch(AIO);
        _articlesInteract = IAIOInteract(AIO);
    }
    
    function ConnectToAIO() 
    external payable {
        require(!connectedInAIO);

        IAIOInterconnection(AIO).Initialize();

        connectedInAIO = true;
    }

    function TransferSignature(address newSender) 
    external payable {
        IAIOInterconnection(AIO).TransferSignature(newSender);
    }

    function SIGNATURE() 
    external pure 
    returns (string memory signature) {
        signature = "OpenAcademicArticles";
    }

    function PublicationIdentifications() 
    external view 
    returns (bytes32[] memory publicationIdentifications) {
        publicationIdentifications = _publication.identifications;
    }

    function PublicationPublishers() 
    external view 
    returns (address[] memory publicationPublishers) {
        publicationPublishers = _publication.publishers;
    }

    function PublicationIdentificationsOfPublisher(address publicationPublisher) 
    external view 
    returns (bytes32[] memory publicationIdentificationsOfPublisher) {
        publicationIdentificationsOfPublisher = _publication.identificationsOfPublisher[publicationPublisher];
    }

    function Publication(bytes32 publicationIdentification) 
    external view 
    returns (Publication_Model memory publication) {
        publication = Publication_Model(
            abi.decode(_articlesSearch.MetaData(publicationIdentification), (Article_Model)),
            _publication.publisher[publicationIdentification],
            _publication.dateTime[publicationIdentification]
        );
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex, bool asc) 
    external view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint256 currentSize) {     
        currentSize = _publication.identifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            publicationsPreview = new PublicationPreview_Model[](0);
        } else {
            uint256 size = endIndex - startIndex + 1;
            
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
            publicationsPreview = new PublicationPreview_Model[](size); 

            if (asc) {
                for (uint256 i = 0; i < size; i++) {
                    publicationsPreview[i] = PublicationPreview_Model(
                        abi.decode(_articlesSearch.MetaData(_publication.identifications[startIndex + i]), (Article_Model)).title,
                        _publication.identifications[startIndex + i]
                    );
                }
            } else {
                for (uint256 i = size; i > 0; i--) {
                    publicationsPreview[size - i] = PublicationPreview_Model(
                        abi.decode(_articlesSearch.MetaData(_publication.identifications[startIndex + size - i]), (Article_Model)).title,
                        _publication.identifications[startIndex + size - i]
                    );
                }
            }
        }
    }


    function PublishArticles(Article_Model[] calldata articles) 
    external payable {
        address publisher = tx.origin;
        bytes32[] memory publicationIdentifications = new bytes32[](articles.length);

        for (uint256 i = 0; i < articles.length; i++) {
            Article_Model memory article = articles[i];

            try _articlesInteract.SendMetaData(abi.encode(article)) {
                bytes32 publicationIdentification = keccak256(abi.encode(article));
                publicationIdentifications[i] = publicationIdentification;

                _publication.identifications.push(publicationIdentification);
                _publication.publisher[publicationIdentification] = publisher;
                _publication.dateTime[publicationIdentification] = block.timestamp;
                _publication.blockNumber[publicationIdentification] = block.number;
                _publication.identificationsOfPublisher[publisher].push(publicationIdentification);

                if (_publication.identificationsOfPublisher[publisher].length == 1) {
                    _publication.publishers.push(publisher);
                }
            }   catch Error(string memory errorMessage) {
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked("article already published"))) {                    
                        revert(string.concat("article[", Strings.toString(i), "]: ", errorMessage));
                    }

                    revert(errorMessage);
            }
        }

        emit ArticlesPublished(publicationIdentifications);
    }

    function UnpublishArticles(bytes32[] memory publicationIdentifications) 
    external payable {
        address publisher;
        bytes32 publicationIdentification;

        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            publicationIdentification = publicationIdentifications[i];
            publisher = _publication.publisher[publicationIdentification];
            require (publisher == tx.origin);

            try _articlesInteract.CleanMetaData(publicationIdentification) {
                if (publisher != address(0)) {
                    _publication.publisher[publicationIdentification] = address(0);
                    _publication.dateTime[publicationIdentification] = 0;
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
                }        
            }   catch Error(string memory errorMessage) {
                    revert(errorMessage);
            }
        }

        emit ArticlesUnpublished(publicationIdentifications);
    }
}