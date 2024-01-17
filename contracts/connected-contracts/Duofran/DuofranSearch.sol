// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranStorage.sol";
import "./DuofranModel.sol";

abstract contract DuofranSearch is DuofranStorage {
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
    returns (DuofranStorageModel.Me memory me) {
        me = _me;
    }

    function AffiliateAccounts() 
    public view 
    returns (address[] memory affiliateAccounts) {
        affiliateAccounts = _affiliate.accounts;
    }

    function Publication(bytes32 publicationIdentification) 
    public view 
    returns (DuofranModel.Publication memory publication) {
        publication = DuofranModel.Publication(
            abi.decode(_academicArticles.ArticleData(publicationIdentification), (DuofranModel.Article)),
            _publication.publisher[publicationIdentification],
            _publication.dateTime[publicationIdentification],
            _publication.valid[publicationIdentification]
        );
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex) 
    public view 
    returns (DuofranModel.PublicationPreview[] memory publicationsPreview, uint256 currentSize) {     
        currentSize = _publication.identifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            publicationsPreview = new DuofranModel.PublicationPreview[](0);
        }   else {
                uint256 size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                publicationsPreview = new DuofranModel.PublicationPreview[](size);

                for (uint256 i = 0; i < size; i++) {
                    publicationsPreview[i] = DuofranModel.PublicationPreview(
                        abi.decode(_academicArticles.ArticleData(_publication.identifications[startIndex + i]), (DuofranModel.Article)).title,
                        _publication.valid[_publication.identifications[startIndex + i]],
                        _publication.identifications[startIndex + i]
                    );
                }
        }
    }
}