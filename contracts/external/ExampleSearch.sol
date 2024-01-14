// SPDX-License-Identifier: MIT

import "./ExampleData.sol";
import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleSearch is ExampleData {

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
    returns (bytes32[] memory publicationPublishers) {

        publicationPublishers = _publication.publishers;
    }

    function PublicationPublisher(bytes32 publicationIdentification) 
    public view 
    returns (address publicationPublisher) {

        publicationPublisher = _publication.publisher[publicationIdentification];
    }

    function PublicationDateTime(bytes32 publicationIdentification) 
    public view 
    returns (uint256 publicationDateTime) {

        publicationDateTime = _publication.dateTime[publicationIdentification];
    }

    function PublicationBlockNumber(bytes32 publicationIdentification) 
    public view 
    returns (uint256 publicationBlockNumber) {

        publicationBlockNumber = _publication.blockNumber[publicationIdentification];
    }

    function PublicationValid(bytes32 publicationIdentification) 
    public view 
    returns (bool publicationValid) {

        publicationValid = _publication.valid[publicationIdentification];
    }

    function PublicationIdentificationsOfPublisher(address publisherAccount) 
    public view 
    returns (bytes32[] memory publicationIdentificationsOfPublisher) {

        publicationIdentificationsOfPublisher = _publication.identificationsOfPublisher[publisherAccount];
    }

    function Publication(bytes32 publicationIdentification) 
    public view 
    returns (ExampleModel.Publication memory publication) {

        publication = ExampleModel.Publication(
            abi.decode(_academicArticles.ArticleEncode(publicationIdentification, CONTRACT), (ExampleModel.Article)),
            publicationIdentification,
            _publication.publisher[publicationIdentification],
            _publication.dateTime[publicationIdentification],
            _publication.valid[publicationIdentification]
        );
    }

    function Me() 
    public view 
    returns (ExampleModel.Me memory me) {

        me = _me;
    }

    function Affiliate() 
    public view 
    returns (ExampleDataModel.Affiliate memory affiliate) {

        affiliate = _affiliate;
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex) 
    public view 
    returns (ExampleModel.PublicationPreview[] memory publicationsPreview, uint256 currentSize) {
        
        currentSize = _publication.identifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {

            publicationsPreview = new ExampleModel.PublicationPreview[](0);
        } else {

            uint256 size = endIndex - startIndex + 1;
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new ExampleModel.PublicationPreview[](size);

            for (uint256 i = 0; i < size; i++) {

                publicationsPreview[i] = ExampleModel.PublicationPreview(
                    abi.decode(_academicArticles.ArticleEncode(_publication.identifications[startIndex + i], CONTRACT), (ExampleModel.Article)).title,
                    _publication.valid[_publication.identifications[startIndex + i]]
                );
            }
        }
    }
}