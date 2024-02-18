// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Import necessary interfaces and libraries
import "../uds/interfaces/IUDSWrite.sol";
import "../uds/interfaces/IUDSRead.sol";
import "../uds/libs/UDSMessage.sol";
import "../StringUtils.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import "./AcademicArticles.sol";

abstract contract AcademicArticlesQueries { 

    struct PublicationPreviewModel {
        string title;
        bytes32 id;
    }

    IUDSRead private _UDSRead;

    bytes32 private constant UDS_CLASSIFICATION_PUBLICATION = "Publication";
    bytes32 private immutable UDS_SIGNATURE;

    constructor(bytes32 UDSSignature, address UDSAccount) {
        UDS_SIGNATURE = UDSSignature;
        _UDSRead = IUDSRead(UDSAccount);
    }

    function PreviewPublications(uint startIndex, uint endIndex) 
    public view 
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        currentSize = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION).length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

            for (uint i = 0; i < size; i++) {
                bytes32 publicationid = UDSPublicationIds[startIndex + i];

                publicationsPreview[i] = PublicationPreviewModel(
                    abi.decode(
                        _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationid),
                        (AcademicArticles.UDSPublicationModel)
                    ).article.title,
                    publicationid
                );
            }
        }
    }

    function PreviewPublicationsContainsTitle(string memory title, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsContainsTitle = PreviewPublicationsContainsTitle(title);
        
        currentSize = previewPublicationsContainsTitle.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsContainsTitle[startIndex + i];
            }
        }
    }

    function PreviewPublicationsContainsTitle(string memory title) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        title = StringUtils.ToLower(title);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (StringUtils.ContainWord(title, StringUtils.ToLower(publication.article.title))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsContainsSummary(string memory summary, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsContainsSummary = PreviewPublicationsContainsSummary(summary);
        
        currentSize = previewPublicationsContainsSummary.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsContainsSummary[startIndex + i];
            }
        }
    }

    function PreviewPublicationsContainsSummary(string memory summary) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        summary = StringUtils.ToLower(summary);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (StringUtils.ContainWord(summary, StringUtils.ToLower(publication.article.summary))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsContainsAdditionalInfo(string memory additionalInfo, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsContainsAdditionalInfo = PreviewPublicationsContainsAdditionalInfo(additionalInfo);
        
        currentSize = previewPublicationsContainsAdditionalInfo.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsContainsAdditionalInfo[startIndex + i];
            }
        }
    }

    function PreviewPublicationsContainsAdditionalInfo(string memory additionalInfo) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        additionalInfo = StringUtils.ToLower(additionalInfo);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (StringUtils.ContainWord(additionalInfo, StringUtils.ToLower(publication.article.additionalInfo))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsHavingInstitution(string memory institution, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingInstitution = PreviewPublicationsHavingInstitution(institution);
        
        currentSize = previewPublicationsHavingInstitution.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingInstitution[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingInstitution(string memory institution) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        institution = StringUtils.ToLower(institution);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (Strings.equal(institution, StringUtils.ToLower(publication.article.institution))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsHavingCourse(string memory course, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingCourse = PreviewPublicationsHavingCourse(course);
        
        currentSize = previewPublicationsHavingCourse.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingCourse[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingCourse(string memory course) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        course = StringUtils.ToLower(course);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (Strings.equal(course, StringUtils.ToLower(publication.article.course))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsHavingArticleType(string memory articleType, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingArticleType = PreviewPublicationsHavingArticleType(articleType);
        
        currentSize = previewPublicationsHavingArticleType.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingArticleType[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingArticleType(string memory articleType) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        articleType = StringUtils.ToLower(articleType);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (Strings.equal(articleType, StringUtils.ToLower(publication.article.articleType))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsHavingAcademicDegree(string memory academicDegree, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingAcademicDegree = PreviewPublicationsHavingAcademicDegree(academicDegree);
        
        currentSize = previewPublicationsHavingAcademicDegree.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingAcademicDegree[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingAcademicDegree(string memory academicDegree) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        academicDegree = StringUtils.ToLower(academicDegree);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (Strings.equal(academicDegree, StringUtils.ToLower(publication.article.academicDegree))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsHavingDocumentationCID(string memory documentationCID, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingDocumentationCID = PreviewPublicationsHavingDocumentationCID(documentationCID);
        
        currentSize = previewPublicationsHavingDocumentationCID.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingDocumentationCID[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingDocumentationCID(string memory documentationCID) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        documentationCID = StringUtils.ToLower(documentationCID);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (Strings.equal(documentationCID, StringUtils.ToLower(publication.article.documentationCID))) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }

    function PreviewPublicationsHavingAuthor(string memory author, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingAuthor = PreviewPublicationsHavingAuthor(author);
        
        currentSize = previewPublicationsHavingAuthor.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingAuthor[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingAuthor(string memory author) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        author = StringUtils.ToLower(author);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            for (uint ii = 0; ii < publication.article.authors.length; ii++) { 
                if (Strings.equal(author, StringUtils.ToLower(publication.article.authors[ii]))) {
                    PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                    publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                    for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                        publicationsPreview[j] = tempPublicationsPreview[j];
                    }

                    publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
                    break;
                }
            }
        }
    }

    function PreviewPublicationsHavingAdvisor(string memory advisor, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingAdvisor = PreviewPublicationsHavingAdvisor(advisor);
        
        currentSize = previewPublicationsHavingAdvisor.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingAdvisor[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingAdvisor(string memory advisor) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        advisor = StringUtils.ToLower(advisor);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            for (uint ii = 0; ii < publication.article.advisors.length; ii++) { 
                if (Strings.equal(advisor, StringUtils.ToLower(publication.article.advisors[ii]))) {
                    PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                    publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                    for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                        publicationsPreview[j] = tempPublicationsPreview[j];
                    }

                    publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
                    break;
                }
            }
        }
    }

    function PreviewPublicationsHavingBoardExaminer(string memory boardExaminer, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingBoardExaminer = PreviewPublicationsHavingBoardExaminer(boardExaminer);
        
        currentSize = previewPublicationsHavingBoardExaminer.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsHavingBoardExaminer[startIndex + i];
            }
        }
    }

    function PreviewPublicationsHavingBoardExaminer(string memory boardExaminer) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        boardExaminer = StringUtils.ToLower(boardExaminer);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            for (uint ii = 0; ii < publication.article.examiningBoard.length; ii++) { 
                if (Strings.equal(boardExaminer, StringUtils.ToLower(publication.article.examiningBoard[ii]))) {
                    PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                    publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                    for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                        publicationsPreview[j] = tempPublicationsPreview[j];
                    }

                    publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
                    break;
                }
            }
        }
    }

    function PreviewPublicationsInPresentationYear(uint16 presentationYear, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsInPresentationYear = PreviewPublicationsInPresentationYear(presentationYear);
        
        currentSize = previewPublicationsInPresentationYear.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsInPresentationYear[startIndex + i];
            }
        }
    }

    function PreviewPublicationsInPresentationYear(uint16 presentationYear) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (presentationYear == publication.article.presentationYear) {
                PublicationPreviewModel[] memory tempPublicationsPreview = publicationsPreview;

                publicationsPreview = new PublicationPreviewModel[](tempPublicationsPreview.length + 1);

                for (uint j = 0; j < tempPublicationsPreview.length; j++) {
                    publicationsPreview[j] = tempPublicationsPreview[j];
                }

                publicationsPreview[tempPublicationsPreview.length] = PublicationPreviewModel(publication.article.title, publicationId);
            }
        }
    }
}