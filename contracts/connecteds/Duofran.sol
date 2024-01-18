// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../interfaces/IAcademicArticles.sol";
import "../interfaces/IAcademicArticlesSignature.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Duofran is IAcademicArticlesSignature {
    constructor(address academicArticles) {
        OWNER = msg.sender;
        _academicArticles = IAcademicArticles(academicArticles);
    }

    address internal immutable OWNER;

    IAcademicArticles internal _academicArticles;

    Publication_StorageModel internal _publication;
    Affiliate_StorageModel internal _affiliate;
    Me_StorageModel internal _me;

    struct Publication_Model {
        Article_Model article;
        address publisher;
        uint256 datatime;
        bool valid;
    }

    struct PublicationPreview_Model {
        string title;
        bool validated;
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
        string[] supervisors;
        string[] examiningBoard;
        int presentationYear;
    }

    struct Publication_StorageModel {
        bytes32[] identifications;
        bytes32[] identificationsValid;
        address[] publishers;
		mapping(bytes32 identification => address) publisher;
        mapping(bytes32 identification => uint256) dateTime;
        mapping(bytes32 identification => uint256) blockNumber;
		mapping(bytes32 identification => bool) valid;
		mapping(address publisher => bytes32[]) identificationsOfPublisher;
    }

    struct Affiliate_StorageModel {
        address[] accounts;
        mapping(address account => string) name;
    }

    struct Me_StorageModel {
        string name;
        string logoUrl;
        string siteUrl;
        string requestEmail;
        string contactNumber;
    }

    event ArticlesPublished(bytes32[] indexed publicationIdentifications);
    event ArticlesUnpublished(bytes32[] indexed publicationIdentifications);
    event ArticlesValidated(bytes32[] indexed publicationIdentifications);
    event ArticlesInvalidated(bytes32[] indexed publicationIdentifications);
    event AffiliateLinked(address indexed affiliateAccount);
    event AffiliatesUnlinked(address[] indexed affiliateAccounts);
    event MeChanged();

    function SIGNATURE() external pure 
    returns (string memory signature) {
        signature = "Duofran";
    }

    function PublicationIdentifications() 
    public view 
    returns (bytes32[] memory publicationIdentifications) {
        publicationIdentifications = _publication.identifications;
    }

    function PublicationIdentificationsValid() 
    public view 
    returns (bytes32[] memory publicationIdentificationsValid) {       
        publicationIdentificationsValid = _publication.identificationsValid;
    }

    function PublicationPublishers() 
    public view 
    returns (address[] memory publicationPublishers) {
        publicationPublishers = _publication.publishers;
    }

    function PublicationIdentificationsOfPublisher(address publicationPublisher) 
    public view 
    returns (bytes32[] memory publicationIdentificationsOfPublisher) {
        publicationIdentificationsOfPublisher = _publication.identificationsOfPublisher[publicationPublisher];
    }

    function Me() 
    public view 
    returns (Me_StorageModel memory me) {
        me = _me;
    }

    function AffiliateAccounts() 
    public view 
    returns (address[] memory affiliateAccounts) {
        affiliateAccounts = _affiliate.accounts;
    }

    function Publication(bytes32 publicationIdentification) 
    public view 
    returns (Publication_Model memory publication) {
        publication = Publication_Model(
            abi.decode(_academicArticles.ArticleData(publicationIdentification), (Article_Model)),
            _publication.publisher[publicationIdentification],
            _publication.dateTime[publicationIdentification],
            _publication.valid[publicationIdentification]
        );
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex) 
    public view 
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
                        abi.decode(_academicArticles.ArticleData(_publication.identifications[startIndex + i]), (Article_Model)).title,
                        _publication.valid[_publication.identifications[startIndex + i]],
                        _publication.identifications[startIndex + i]
                    );
                }
        }
    }

    function PublishArticles(Article_Model[] memory articles) 
    public payable {
        bytes32[] memory publicationIdentifications = new bytes32[](articles.length);
        bytes32 publicationIdentification;
        Article_Model memory article;

        for (uint256 i = 0; i < articles.length; i++) {
            article = articles[i];

            try _academicArticles.PublishArticle(abi.encode(article)) {
                publicationIdentification = keccak256(abi.encode(article));
                publicationIdentifications[i] = publicationIdentification;

                _publication.identifications.push(publicationIdentification);
                _publication.publisher[publicationIdentification] = msg.sender;
                _publication.dateTime[publicationIdentification] = block.timestamp;
                _publication.blockNumber[publicationIdentification] = block.number;
                _publication.valid[publicationIdentification] = OWNER == msg.sender|| bytes(_affiliate.name[msg.sender]).length > 0;
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

        emit ArticlesPublished(publicationIdentifications);
    }

    function UnpublishArticles(bytes32[] calldata publicationIdentifications) 
    public payable {
        address publisher;
        bytes32 publicationIdentification;

        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            publicationIdentification = publicationIdentifications[i];
            publisher = _publication.publisher[publicationIdentification];
     
            try _academicArticles.UnpublishArticle(publicationIdentification) {
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
            }   catch Error(string memory errorMessage) {
                    revert(errorMessage);
            }
        }

        emit ArticlesUnpublished(publicationIdentifications);
    }

    function ValidateArticles(bytes32[] calldata publicationIdentifications) 
    public payable {
        require(OWNER == msg.sender || bytes(_affiliate.name[msg.sender]).length > 0);

        bytes32 publicationIdentification;
        
        for (uint256 i = 0; i < publicationIdentifications.length; i++) {
            publicationIdentification = publicationIdentifications[i];

            if (!_publication.valid[publicationIdentification] && _publication.publisher[publicationIdentification] != address(0)) {
                _publication.valid[publicationIdentification] = true;           
                _publication.identificationsValid.push(publicationIdentification);
            }
        }
        
        emit ArticlesValidated(publicationIdentifications);
    }

    function InvalidateArticles(bytes32[] calldata publicationIdentifications) 
    public payable {       
        require(OWNER == msg.sender || bytes(_affiliate.name[msg.sender]).length > 0);

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

        emit ArticlesInvalidated(publicationIdentifications);
    }

    function LinkAffiliates(address affiliateAccount, string calldata affiliateName) 
    public payable {
        require(OWNER == msg.sender);
        require(bytes(_affiliate.name[affiliateAccount]).length > 0);

        _affiliate.accounts.push(affiliateAccount);
        _affiliate.name[affiliateAccount] = affiliateName;  
   
        emit AffiliateLinked(affiliateAccount);
    }

    function UnlinkAffiliates(address[] calldata affiliateAccounts) 
    public payable {
        require(OWNER == msg.sender);

        address affiliateAccount;

        for (uint256 i = 0; i < affiliateAccounts.length; i++) {   
            affiliateAccount = affiliateAccounts[i];

            if (bytes(_affiliate.name[affiliateAccount]).length > 0) {
                for (uint256 ii = 0; ii < _affiliate.accounts.length; ii++) {       
                    if (_affiliate.accounts[ii] == affiliateAccount) {         
                        _affiliate.accounts[ii] = _affiliate.accounts[_affiliate.accounts.length - 1];
                        _affiliate.accounts.pop();
                    }
                }
            }
        }

        emit AffiliatesUnlinked(affiliateAccounts);
    }

    function ChangeMe(Me_StorageModel calldata me) 
    public payable {
        require(OWNER == msg.sender);

        _me = me;
       
        emit MeChanged();
    }
}