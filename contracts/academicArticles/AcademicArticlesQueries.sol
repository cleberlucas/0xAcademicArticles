// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../uds/interfaces/IUDSWrite.sol";
import "../uds/interfaces/IUDSRead.sol";
import "../uds/libs/UDSMessage.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import "../StringUtils.sol";
import "./AcademicArticles.sol";

/**
 * @title Academic Articles Queries
 * @dev This contract provides functionality for querying academic articles through metadata stored in Unified Data Storage (UDS).
 * @author Cleber Lucas
 */
abstract contract AcademicArticlesQueries {
    
    // Structure representing a preview of a publication.
    struct PublicationPreviewModel {
        string title;   // Title of the publication.
        bytes32 id;     // ID of the publication.
    }

    // Interface for reading data from UDS.
    IUDSRead private _UDSRead;

    // Signature on UDS.
    bytes32 private immutable UDS_SIGNATURE;

    // Classification for publications on UDS. 
    bytes32 private constant UDS_CLASSIFICATION_PUBLICATION = "Publication";

    /**
     * @dev Constructor to initialize UDS signature and account.
     * @param UDSSignature The signature of the UDS.
     * @param UDSAccount The address of the UDS account.
     */
    constructor(bytes32 UDSSignature, address UDSAccount) {
        UDS_SIGNATURE = UDSSignature;
        _UDSRead = IUDSRead(UDSAccount);
    }

    /**
     * @dev Retrieves a preview of publications within a specified range.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications within the specified range.
     * @return currentSize The total number of publications available.
     */
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

        /**
     * @dev Retrieves a preview of publications containing a given title within a specified range.
     * @param title The title to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications containing the given title.
     * @return currentSize The total number of publications containing the given title.
     */
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

    /**
     * @dev Retrieves publications containing a given title.
     * @param title The title to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications containing the given title.
     */
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


    /**
     * @dev Retrieves a preview of publications containing a given summary within a specified range.
     * @param summary The summary to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications containing the given summary.
     * @return currentSize The total number of publications containing the given summary.
     */
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

    /**
     * @dev Retrieves publications containing a given summary.
     * @param summary The summary to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications containing the given summary.
     */
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


        /**
     * @dev Retrieves a preview of publications containing a given additional information within a specified range.
     * @param additionalInfo The additional information to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications containing the given additional information.
     * @return currentSize The total number of publications containing the given additional information.
     */
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

    /**
     * @dev Retrieves publications containing a given additional information.
     * @param additionalInfo The additional information to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications containing the given additional information.
     */
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


        /**
     * @dev Retrieves a preview of publications associated with a given institution within a specified range.
     * @param institution The institution to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications associated with the given institution.
     * @return currentSize The total number of publications associated with the given institution.
     */
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

    /**
     * @dev Retrieves publications associated with a given institution.
     * @param institution The institution to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications associated with the given institution.
     */
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


        /**
     * @dev Retrieves a preview of publications associated with a given course within a specified range.
     * @param course The course to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications associated with the given course.
     * @return currentSize The total number of publications associated with the given course.
     */
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

    /**
     * @dev Retrieves publications associated with a given course.
     * @param course The course to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications associated with the given course.
     */
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


    /**
     * @dev Retrieves a preview of publications having a given article type within a specified range.
     * @param articleType The article type to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications having the given article type.
     * @return currentSize The total number of publications having the given article type.
     */
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

    /**
     * @dev Retrieves publications having a given article type.
     * @param articleType The article type to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications having the given article type.
     */
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

    /**
     * @dev Retrieves a preview of publications having a given academic degree within a specified range.
     * @param academicDegree The academic degree to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications having the given academic degree.
     * @return currentSize The total number of publications having the given academic degree.
     */
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

    /**
     * @dev Retrieves publications having a given academic degree.
     * @param academicDegree The academic degree to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications having the given academic degree.
     */
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


    /**
     * @dev Retrieves a preview of publications having a given documentation content identifier (CID) within a specified range.
     * @param documentationCID The documentation content identifier (CID) to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications having the given documentation CID.
     * @return currentSize The total number of publications having the given documentation CID.
     */
    function PreviewPublicationsHavingDocumentationCID(string memory documentationCID, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) 
    {
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

    /**
     * @dev Retrieves publications having a given documentation content identifier (CID).
     * @param documentationCID The documentation content identifier (CID) to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications having the given documentation CID.
     */
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

    /**
     * @dev Retrieves a preview of publications having a given author within a specified range.
     * @param author The author to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications having the given author.
     * @return currentSize The total number of publications having the given author.
     */
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

    /**
     * @dev Retrieves publications having a given author.
     * @param author The author to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications having the given author.
     */
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


    /**
     * @dev Retrieves a preview of publications having a given advisor within a specified range.
     * @param advisor The advisor to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications having the given advisor.
     * @return currentSize The total number of publications having the given advisor.
     */
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

    /**
     * @dev Retrieves publications having a given advisor.
     * @param advisor The advisor to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications having the given advisor.
     */
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

    /**
     * @dev Retrieves a preview of publications having a given board examiner within a specified range.
     * @param boardExaminer The board examiner to search for in the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications having the given board examiner.
     * @return currentSize The total number of publications having the given board examiner.
     */
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

    /**
     * @dev Retrieves publications having a given board examiner.
     * @param boardExaminer The board examiner to search for in the publications.
     * @return publicationsPreview An array containing preview models of publications having the given board examiner.
     */
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

    /**
     * @dev Retrieves a preview of publications presented in a specific year within a specified range.
     * @param presentationYear The year of presentation to filter the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications presented in the specified year.
     * @return currentSize The total number of publications presented in the specified year.
     */
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

    /**
     * @dev Retrieves publications presented in a specific year.
     * @param presentationYear The year of presentation to filter the publications.
     * @return publicationsPreview An array containing preview models of publications presented in the specified year.
     */
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

    /**
     * @dev Retrieves a preview of publications published by a specific publisher within a specified range.
     * @param publisher The address of the publisher to filter the publications.
     * @param startIndex The starting index of the publications to preview.
     * @param endIndex The ending index of the publications to preview.
     * @return publicationsPreview An array containing preview models of publications published by the specified publisher.
     * @return currentSize The total number of publications published by the specified publisher.
     */
    function PreviewPublicationsOfPublisher(address publisher, uint startIndex, uint endIndex) 
    public view
    returns (PublicationPreviewModel[] memory publicationsPreview, uint currentSize) {
        PublicationPreviewModel[] memory previewPublicationsOfPublisher = PreviewPublicationsOfPublisher(publisher);
        
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

    /**
     * @dev Retrieves publications published by a specific publisher.
     * @param publisher The address of the publisher to filter the publications.
     * @return publicationsPreview An array containing preview models of publications published by the specified publisher.
     */
    function PreviewPublicationsOfPublisher(address publisher) 
    private view
    returns (PublicationPreviewModel[] memory publicationsPreview) {
        bytes32[] memory UDSPublicationIds = _UDSRead.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        for (uint i = 0; i < UDSPublicationIds.length; i++) {
            bytes32 publicationId = UDSPublicationIds[i];

            AcademicArticles.UDSPublicationModel memory publication = abi.decode(
                _UDSRead.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
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