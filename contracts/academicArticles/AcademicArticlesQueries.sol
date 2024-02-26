// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../uds/IUDSWrite.sol";
import "../uds/IUDSRead.sol";
import "../uds/UDSMessage.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import "../StringUtils.sol";
import "./AcademicArticles.sol";

pragma solidity ^0.8.23;

/**
 * @title Academic Articles Queries
 * @dev Library for querying academic articles.
 * @notice Contains several publication query functions, performing a search for almost all publication attributes stored on the Unified Data Storage (UDS).
 * @author Cleber Lucas
 */
library AcademicArticlesQueries {

    // Structure representing a preview of a publication.
    struct PublicationPreviewModel {
        string title;   // Title of published article
        bytes32 id;     // ID of the publication.
    }

    function PreviewPublications(uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view 
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        currentSize = UDSRead.Ids(UDSSignature, UDSClassificationPublication).length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

            for (uint i = 0; i < size; i++) {
                bytes32 publicationid = UDSPublicationIds[startIndex + i];

                publicationsPreview[i] = PublicationPreviewModel(
                    abi.decode(
                        UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationid),
                        (AcademicArticles.UDSPublicationModel)
                    ).article.title,
                    publicationid
                );
            }
        }
    }

    function PreviewPublicationsContainsTitle(string calldata title, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsContainsTitle = PreviewPublicationsContainsTitle(title, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsContainsTitle(string memory title, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        title = StringUtils.ToLower(title);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsContainsSummary(string calldata summary, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsContainsSummary = PreviewPublicationsContainsSummary(summary, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsContainsSummary(string memory summary, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        summary = StringUtils.ToLower(summary);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsContainsAdditionalInfo(string calldata additionalInfo, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsContainsAdditionalInfo = PreviewPublicationsContainsAdditionalInfo(additionalInfo, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsContainsAdditionalInfo(string memory additionalInfo, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        additionalInfo = StringUtils.ToLower(additionalInfo);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingInstitution(string calldata institution, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingInstitution = PreviewPublicationsHavingInstitution(institution, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingInstitution(string memory institution, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        institution = StringUtils.ToLower(institution);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingCourse(string calldata course, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {

        PublicationPreviewModel[] memory previewPublicationsHavingCourse = PreviewPublicationsHavingCourse(course, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingCourse(string memory course, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        course = StringUtils.ToLower(course);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingArticleType(string calldata articleType, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingArticleType = PreviewPublicationsHavingArticleType(articleType, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingArticleType(string memory articleType, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        articleType = StringUtils.ToLower(articleType);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingAcademicDegree(string calldata academicDegree, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingAcademicDegree = PreviewPublicationsHavingAcademicDegree(academicDegree, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingAcademicDegree(string memory academicDegree, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        academicDegree = StringUtils.ToLower(academicDegree);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingDocumentationCID(string calldata documentationCID, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) 
    {
        PublicationPreviewModel[] memory previewPublicationsHavingDocumentationCID = PreviewPublicationsHavingDocumentationCID(documentationCID, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingDocumentationCID(string memory documentationCID, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        documentationCID = StringUtils.ToLower(documentationCID);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingAuthor(string calldata author, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingAuthor = PreviewPublicationsHavingAuthor(author, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingAuthor(string memory author, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        author = StringUtils.ToLower(author);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingAdvisor(string calldata advisor, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingAdvisor = PreviewPublicationsHavingAdvisor(advisor, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingAdvisor(string memory advisor, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        advisor = StringUtils.ToLower(advisor);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsHavingBoardExaminer(string calldata boardExaminer, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsHavingBoardExaminer = PreviewPublicationsHavingBoardExaminer(boardExaminer, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsHavingBoardExaminer(string memory boardExaminer, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        boardExaminer = StringUtils.ToLower(boardExaminer);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsInPresentationYear(uint16 presentationYear, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsInPresentationYear = PreviewPublicationsInPresentationYear(presentationYear, UDSRead, UDSSignature, UDSClassificationPublication);
        
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

    function PreviewPublicationsInPresentationYear(uint16 presentationYear, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
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

    function PreviewPublicationsOfPublisher(address publisher, uint startIndex, uint endIndex, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsOfPublisher = PreviewPublicationsOfPublisher(publisher, UDSRead, UDSSignature, UDSClassificationPublication);
        
        currentSize = previewPublicationsOfPublisher.length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;

            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new PublicationPreviewModel[](size);

            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = previewPublicationsOfPublisher[startIndex + i];
            }
        }
    }

    function PreviewPublicationsOfPublisher(address publisher, IUDSRead UDSRead, bytes32 UDSSignature, bytes32 UDSClassificationPublication) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {

        bytes32[] memory UDSPublicationIds = UDSRead.Ids(UDSSignature, UDSClassificationPublication);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                UDSRead.Metadata(UDSSignature, UDSClassificationPublication, publicationId),
                (AcademicArticles.UDSPublicationModel)
            );

            if (publisher == publication.publisher) {
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