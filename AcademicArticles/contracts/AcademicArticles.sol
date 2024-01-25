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
        bytes32 id;
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
        bytes32[] ids;
        address[] publishers;
        mapping(bytes32 id => address) publisher;
        mapping(bytes32 id => uint) datetime;
        mapping(bytes32 id => uint) blockNumber;
        mapping(address publisher => bytes32[]) idsOfPublisher;
    }

    struct AIO_StorageModel {     
        address account;
        IAIOSearch articlesSearch;
        IAIOInteract articlesInteract;
    }

    event ArticlesPublished(bytes32[] indexed ids);
    event ArticlesUnpublished(bytes32[] indexed ids);
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

    function Publication(bytes32 id) 
    external view 
    returns (Publication_Model memory publication) {
        publication = Publication_Model(
            abi.decode(_aio.articlesSearch.MetaData(id), (Article_Model)),
            _publication.publisher[id],
            _publication.datetime[id],
            _publication.blockNumber[id]
        );
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint256 currentSize) {     
        currentSize = _publication.ids.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            publicationsPreview = new PublicationPreview_Model[](0);
        }   else {
                uint256 size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                publicationsPreview = new PublicationPreview_Model[](size); 
                
                for (uint256 i = 0; i < size; i++) {
                    publicationsPreview[i] = PublicationPreview_Model(
                        abi.decode(_aio.articlesSearch.MetaData(_publication.ids[startIndex + i]), (Article_Model)).title,
                        _publication.ids[startIndex + i]
                    );
                }
        }
    }

    function PreviewPublicationsOfPublisher(address publicationPublisher, uint256 startIndex, uint256 endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint256 currentSize) {     
        currentSize = _publication.idsOfPublisher[publicationPublisher].length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            previewPublicationsOfPublisher = new PublicationPreview_Model[](0);
        }   else {
                uint256 size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                previewPublicationsOfPublisher = new PublicationPreview_Model[](size); 
                
                for (uint256 i = 0; i < size; i++) {
                    previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                        abi.decode(_aio.articlesSearch.MetaData(_publication.idsOfPublisher[publicationPublisher][startIndex + i]), (Article_Model)).title,
                        _publication.idsOfPublisher[publicationPublisher][startIndex + i]
                    );
                }
        }
    }

    function PublishArticles(Article_Model[] calldata articles) 
    external payable {
        address publisher = msg.sender;
        bytes32[] memory ids = new bytes32[](articles.length);

        for (uint256 i = 0; i < articles.length; i++) {
            Article_Model memory article = articles[i];

            try _aio.articlesInteract.SendMetaData(abi.encode(article)) {
                bytes32 id = keccak256(abi.encode(article));

                _publication.ids.push(id);
                _publication.publisher[id] = publisher;
                _publication.datetime[id] = block.timestamp;
                _publication.blockNumber[id] = block.number;
                _publication.idsOfPublisher[publisher].push(id);

                if (_publication.idsOfPublisher[publisher].length == 1) {
                    _publication.publishers.push(publisher);
                }

                ids[i] = id;
            }   catch Error(string memory errorMessage) {
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
        for (uint256 i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            address publisher = _publication.publisher[id];

            require (publisher != address(0), "Article is not published");
            require (publisher == msg.sender, "Article is not published by you");

            try _aio.articlesInteract.CleanMetaData(id) {
                _publication.publisher[id] = address(0);
                _publication.datetime[id] = 0;
                _publication.blockNumber[id] = 0;

                for (uint256 ii = 0; ii < _publication.ids.length; ii++) {
                    if (_publication.ids[ii] == id) {
                        _publication.ids[ii] = _publication.ids[_publication.ids.length - 1];
                        _publication.ids.pop();             
                    }
                }

                if (_publication.idsOfPublisher[publisher].length == 1) {
                    _publication.idsOfPublisher[publisher] = new bytes32[](0);

                    for (uint256 ii = 0; ii < _publication.publishers.length; ii++) {
                        if (_publication.publishers[ii] == publisher) {
                            _publication.publishers[ii] = _publication.publishers[_publication.publishers.length - 1];
                            _publication.publishers.pop();             
                        }
                    }
                }   else {
                        for (uint256 ii = 0; ii < _publication.idsOfPublisher[publisher].length; ii++) {
                            if (_publication.idsOfPublisher[publisher][ii] == id) {
                                _publication.idsOfPublisher[publisher][ii] = _publication.idsOfPublisher[publisher][_publication.idsOfPublisher[publisher].length - 1];
                                _publication.idsOfPublisher[publisher].pop();             
                            }
                        }
                }
                      
            }   catch Error(string memory errorMessage) {
                    if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_NOT_SENT))) {                    
                        revert(string.concat("Article[", Strings.toString(i), "]: is not published"));
                    }   else {
                            if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(AIOMessage.METADATA_NOT_SENT_BY_YOU))) {                    
                                revert(string.concat("Article[", Strings.toString(i), "]: is not published here"));
                            }
                    }

                    revert(errorMessage);
            }
        }

        emit ArticlesUnpublished(ids);
    }
}
