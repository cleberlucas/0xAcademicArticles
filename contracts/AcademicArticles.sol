// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Import necessary interfaces and libraries
import "./uds/interfaces/IUDSWrite.sol";
import "./uds/interfaces/IUDSRead.sol";
import "./uds/libs/UDSMessage.sol";
import "./StringUtils.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Academic Articles
 * @notice This contract serves as a platform for publishing academic articles.
 * @dev It manages academic articles with integration to the UDS (Unified data storage) platform.
 * @author Cleber Lucas
 */
contract AcademicArticles{

    /**
    * @dev Represents the storage model for connecting to the UDS.
    */
    struct UDS_StorageModel {
        IUDSRead read;    // Instance of the UDSRead interface for reading data in the UDS.
        IUDSWrite write;   // Instance of the UDSWrite interface for writing data to the UDS.
    }

    /**
    * @dev Represents metadata for a publication in the UDS.
    */
    struct UDS_PublicationModel {
        Article_Model article;    // Information about the article being published.
        address publisher;        // Address of the publisher.
        uint datetime;            // Timestamp of the publication.
        uint blockNumber;         // Block number when the publication was made.
    }

    /**
    * @dev Represents metadata for a publisher in the UDS.
    */
    struct UDS_PublisherModel {
        bytes32[] publicationIds;    // Array of unique identifiers representing publications by the publisher.
    }

    /**
    * @dev Represents detailed information about an article.
    */
    struct Article_Model {
        string title;              // Title of the article.
        string summary;            // Summary or abstract of the article, also used as the unique identifier (id) by hashing.
        string additionalInfo;     // Additional information about the article.
        string institution;        // Institution associated with the article.
        string course;             // Course related to the article.
        string articleType;        // Type of the article (e.g., research, thesis).
        string academicDegree;     // Academic degree associated with the article.
        string documentationCID;   // CID for additional documentation related to the article.
        string[] authors;          // Array of authors contributing to the article.
        string[] advisors;         // Array of advisors for the article.
        string[] examiningBoard;   // Array of examining board members for the article.
        uint16 presentationYear;   // Year when the article was presented.
    }

    /**
    * @dev Represents a preview of a publication for display purposes.
    */
    struct PublicationPreview_Model {
        string title;      // Title of the publication.
        bytes32 id;        // Unique identifier of the publication.
    }

    /**
     * @dev Instance of a bridge for storage on the UDS.
     */
    UDS_StorageModel private _uds;

    /**
     * @dev Secret key used for signature transfer.
     * @notice This is an example, it must be changed when deploying
     */
    bytes32 private constant SECRETKEY = 0x07855b46a623a8ecabac76ed697aa4e13631e3b6718c8a0d342860c13c30d2fc;

    /**
     * @dev Fixed keys used as classification on the UDS.
     */
    bytes32 private constant UDS_SIGNATURE = "AcademicArticles";
    bytes32 private constant UDS_CLASSIFICATION_PUBLISHER = "Publisher";
    bytes32 private constant UDS_CLASSIFICATION_PUBLICATION = "Publication";

    /**
     * @dev Variable to prevent double execution.
     */
    bool private connectToUDS;
    bool private transferUDSSignature;

    /**
     * @dev Owner of the contract.
     */
    address private immutable OWNER;

    /**
     * @dev Constructor initializes the contract with the deploying address as the owner.
     */
    constructor() {
        OWNER = msg.sender;
    }

    /**
     * @dev Allows sign in UDS.
     * @param account The address of the UDS account to connect to.
     */
    function SignToUDS(address account) 
    public {
        // Ensure that only the contract owner can perform this action.
        require(OWNER == msg.sender, "Owner action");

        // Ensure that the contract is not already connected to UDS.
        require(!connectToUDS, "Already connected to UDS");

        // Set the UDSRead and UDSWrite interfaces to the provided UDS account.
        _uds.read = IUDSRead(account);
        _uds.write = IUDSWrite(account);

         // Call the Sign function to establish the connection
        _uds.write.Sign(UDS_SIGNATURE);

        // Mark the contract as connected to UDS.
        connectToUDS = true;
    }

    /**
     * @dev Transfers the UDS signature to a new address.
     * @param sender The new address to receive the UDS signature.
     * @param secretKey The secret key for the transfer.
     * @notice Can only be used once, as the secret key is revealed during the transaction.
     */
    function TransferUDSSignature(address sender, bytes calldata secretKey) 
    public {
        // Ensure that only the contract owner can perform this action.
        require(OWNER == msg.sender, "Owner action");

        // Ensure that the provided secretKey matches the predefined secretKey.
        require(SECRETKEY == keccak256(secretKey), "Invalid secretKey");

        // Ensure that the UDS signature has not been transferred before.
        require(!transferUDSSignature, "Already transferred UDS signature");

        // Call the TransferSignature function on the UDSWrite interface to transfer the UDS signature.
        _uds.write.TransferSignature(sender);

        // Mark the UDS signature as transferred.
        transferUDSSignature = true;
    }


    /**
     * @dev Publishes articles.
     * @param articles An array of Article_Model containing article information.
     */
    function PublishArticles(Article_Model[] calldata articles) 
    public {
        // Create an array to store the generated ids for the articles.
        bytes32[] memory publicationIds = new bytes32[](articles.length);

        // Get the address of the publisher initiating the publishing.
        address publisher = msg.sender;

        // Encode the publisher address to use as a id for UDS.
        bytes32 UDS_publisherId = bytes32(abi.encode(publisher));

        // Retrieve information about the publisher from the UDS.
        UDS_PublisherModel memory UDS_publisher = Publisher(publisher);

        // Iterate through the provided articles to publish them.
        for (uint i = 0; i < articles.length; i++) {
            // Generate a unique id for each article based on its summary.
            bytes32 UDS_publicationId = keccak256(abi.encode(articles[i].summary));

            // Try to send metadata to the UDS for the new publication.
            try _uds.write.SendMetadata(
                UDS_CLASSIFICATION_PUBLICATION,
                UDS_publicationId,           
                abi.encode( 
                    UDS_PublicationModel ( 
                        articles[i],
                        publisher,
                        block.timestamp,
                        block.number
                    )
                )
            ) {
            } catch Error(string memory errorMessage) {
                // Handling the error for this contract's context
                if (Strings.equal(errorMessage, UDSMessage.METADATA_ALREADY_SENT)) {
                    // Revert if the article has already been published.
                    revert(string.concat("Article[", Strings.toString(i), "] already published"));
                } else {
                    // Revert for other errors.
                    revert(errorMessage);
                }
            }

            // Store the generated id for the published article.
            publicationIds[i] = UDS_publicationId;
        }

        // If the publisher has already posted, update their list of ids; otherwise, add the new ids.
        if (UDS_publisher.publicationIds.length > 0) {
            // Create a new array to store the combined list of ids.
            bytes32[] memory newPublicationIds = new bytes32[](UDS_publisher.publicationIds.length + publicationIds.length);

            // Combine the existing ids with the new ids.
            for (uint i = 0; i < newPublicationIds.length; i++) {
                if (i < UDS_publisher.publicationIds.length) {
                    newPublicationIds[i] = UDS_publisher.publicationIds[i];
                } else {
                    newPublicationIds[i] = publicationIds[i - UDS_publisher.publicationIds.length];
                }
            }

            // Update the publisher's list of ids with the combined list.
            UDS_publisher.publicationIds = newPublicationIds;

            // Update the metadata from the UDS with the updated list of ids for the publisher.
            _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLISHER, UDS_publisherId, abi.encode(UDS_publisher));
        } else {
            // If the publisher has not posted before, directly add the new ids.
            UDS_publisher.publicationIds = publicationIds;

            // Send metadata to the UDS with the list of ids for the publisher.
            _uds.write.SendMetadata(UDS_CLASSIFICATION_PUBLISHER, UDS_publisherId, abi.encode(UDS_publisher));
        }
    }

    /**
     * @dev Unpublishes articles.
     * @param ids An array of article ids to be unpublished.
     */
    function UnpublishArticles(bytes32[] calldata ids) 
    public {
        // Get the address of the publisher initiating the unpublishing.
        address publisher = msg.sender;

        // Encode the publisher address to use as a id for UDS.
        bytes32 UDS_publisherId = bytes32(abi.encode(publisher));

        // Retrieve information about the publisher from the UDS.
        UDS_PublisherModel memory UDS_publisher = Publisher(publisher);

        // If the publisher has not published anything, abort the flow.
        require(UDS_publisher.publicationIds.length > 0, "You have nothing to unpublish");

        // Iterate through the specified ids to unpublish the corresponding articles.
        for (uint i = 0; i < ids.length; i++) {
            // Get the id of the article from the parameter.
            bytes32 id = ids[i];

            // Retrieve information about the publication from the UDS based on the article id.
            UDS_PublicationModel memory publicationUDS = Publication(id);

            // Ensure that the article is published and is published by the same publisher initiating the unpublishing.
            require(publicationUDS.publisher != address(0), string.concat("Article[", Strings.toString(i), "] is not published"));
            require(publicationUDS.publisher == publisher, string.concat("Article[", Strings.toString(i), "] is not published by you"));

            // Remove the article's metadata from the UDS.
            _uds.write.CleanMetadata(UDS_CLASSIFICATION_PUBLICATION, id);
        }

        // If the same quantity of articles is passed to be removed, execute the command to clean everything; otherwise, remove the passed ids from the publisher's ids list.
        if (UDS_publisher.publicationIds.length == ids.length) {
            _uds.write.CleanMetadata(UDS_CLASSIFICATION_PUBLISHER, UDS_publisherId);
        } else {
            // Create a new array to store the remaining ids.
            bytes32[] memory newPublicationIds = new bytes32[](UDS_publisher.publicationIds.length - ids.length);
            uint i_;

            // Iterate through the publisher's existing ids and filter out the ones to be removed.
            for (uint i = 0; i < UDS_publisher.publicationIds.length; i++) {
                bool addId = true;

                // Check if the current id is from the list of ids to be removed.
                for (uint ii = 0; ii < ids.length; ii++) {
                    if (ids[ii] == UDS_publisher.publicationIds[i]) {
                        addId = false;
                        break;
                    }
                }

                // If the id is not from the list of ids to be removed, add it to the new array.
                if (addId) {
                    newPublicationIds[i_] = UDS_publisher.publicationIds[i];
                    i_++;
                }
            }

            // Update the publisher's list of ids with the remaining ids.
            UDS_publisher.publicationIds = newPublicationIds;

            // Update the metadata from the UDS with the updated list of ids for the publisher.
            _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLISHER, UDS_publisherId, abi.encode(UDS_publisher));
        }
    }

    /**
     * @dev Retrieves information about a publisher based on the provided address.
     * @param publisher The address of the publisher.
     * @return UDS_publisher A UDS_PublisherModel containing metadata about the publisher.
     */
    function Publisher(address publisher) 
    public view 
    returns (UDS_PublisherModel memory UDS_publisher) {
        // Retrieve metadata about the publisher from the UDS based on the provided address.
        bytes memory UDS_publisherMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLISHER, bytes32(abi.encode(publisher)));

        // Check if metadata about the publisher exists.
        if (UDS_publisherMetadata.length > 0) {
            // Decode the metadata to obtain information about the publisher.
            UDS_publisher = abi.decode(UDS_publisherMetadata, (UDS_PublisherModel));
        }
    }

    /**
     * @dev Retrieves information about a publication based on the provided id.
     * @param id The id of the publication.
     * @return publication A UDS_PublicationModel containing metadata about the publication.
     */
    function Publication(bytes32 id) 
    public view 
    returns (UDS_PublicationModel memory publication) {
        // Retrieve metadata about the publication from the UDS based on the provided id.
        bytes memory UDS_publicationMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id);

        // Check if metadata about the publication exists.
        if (UDS_publicationMetadata.length > 0) {
            // Decode the metadata to obtain information about the publication.
            publication = abi.decode(UDS_publicationMetadata, (UDS_PublicationModel));
        }
    }

    /**
     * @dev Retrieves a preview of publications with a specific title up to a specified limit.
     * @param title The title to search for in publications.
     * @param limit The maximum number of publications to retrieve in the preview.
     * @return publicationsPreview An array of PublicationPreview_Model containing preview information about publications.
     */
    function PreviewPublicationsWithTitle(string memory title, uint limit) 
    public view 
    returns (PublicationPreview_Model[] memory publicationsPreview) {
        // Retrieve all publication ids from the UDS.
        bytes32[] memory publicationIds = _uds.read.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        // Convert the search title to lowercase for case-insensitive comparison.
        title = StringUtils.ToLower(title);

        // Initialize the array to store the preview information.
        publicationsPreview = new PublicationPreview_Model[](limit);

        // Initialize a counter to keep track of the number of previews added.
        uint previewCount;

        // Iterate through publication ids and add previews based on the search title.
        for (uint i = 0; i < publicationIds.length && previewCount < limit; i++) {
            bytes32 publicationId = publicationIds[i];

            // Decode the publication metadata and retrieve the article title.
            string memory articleTitle = StringUtils.ToLower(
                abi.decode(
                    _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationId),
                    (UDS_PublicationModel)
                ).article.title
            );

            // Check if the search title is a part of the article title.
            if (StringUtils.ContainWord(title, articleTitle)) {
                // Add a new preview with the article title and id to the array.
                publicationsPreview[previewCount] = PublicationPreview_Model(articleTitle, publicationId);
                previewCount++;
            }
        }

        // If the previewCount is less than the specified limit, adjust the array size.
        if (previewCount < limit) {
            // Create a copy of the original array.
            PublicationPreview_Model[] memory publicationsPreviewCopy = publicationsPreview;

            // Resize the array to the actual preview count.
            publicationsPreview = new PublicationPreview_Model[](previewCount);

            // Copy valid previews from the original array to the resized array.
            for (uint i = 0; i < previewCount; i++) {
                if (publicationsPreviewCopy[i].id != bytes32(0)) {
                    publicationsPreview[i] = publicationsPreviewCopy[i];
                } else {
                    // Break the loop if an empty entry is encountered.
                    break;
                }
            }
        }
    }

    /**
     * @dev Retrieves a preview of publications within a specified range.
     * @param startIndex The starting index of publications to retrieve.
     * @param endIndex The ending index of publications to retrieve.
     * @return publicationsPreview An array of PublicationPreview_Model containing preview information about publications.
     * @return currentSize The total number of publications in the UDS.
     */
    function PreviewPublications(uint startIndex, uint endIndex) 
    public view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint currentSize) {
        // Retrieve the total number of publications from the UDS.
        currentSize = _uds.read.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION).length;

        // Check if the specified start and end indexes are within valid bounds.
        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            // Calculate the size of the preview based on the specified range.
            uint size = endIndex - startIndex + 1;

            // Ensure that the size does not exceed the available publications.
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            // Initialize the array to store the preview information.
            publicationsPreview = new PublicationPreview_Model[](size);

            // Retrieve all publication ids from the UDS.
            bytes32[] memory UDS_publicationIds = _uds.read.Ids(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

            // Iterate through the specified range of indexes and add previews to the array.
            for (uint i = 0; i < size; i++) {
                // Retrieve the publication id based on the current index.
                bytes32 publicationid = UDS_publicationIds[startIndex + i];

                // Decode the publication metadata and retrieve the article title.
                publicationsPreview[i] = PublicationPreview_Model(
                    abi.decode(
                        _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationid),
                        (UDS_PublicationModel)
                    ).article.title,
                    publicationid
                );
            }
        }
    }

    /**
     * @dev Retrieves a preview of publications by a specific publisher within a specified range.
     * @param publisher The address of the publisher.
     * @param startIndex The starting index of publications to retrieve.
     * @param endIndex The ending index of publications to retrieve.
     * @return previewPublicationsOfPublisher An array of PublicationPreview_Model containing preview information about publications.
     * @return currentSize The total number of publications by the specified publisher in the UDS.
     */
    function PreviewPublicationsOfPublisher(address publisher, uint startIndex, uint endIndex) 
    public view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint currentSize) {
        // Retrieve metadata about the publisher from the UDS.
        bytes memory UDS_publisherMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLISHER, bytes32(abi.encode(publisher)));

        // Check if metadata about the publisher exists.
        if (UDS_publisherMetadata.length > 0) {
            // Decode the metadata to obtain information about the publisher.
            UDS_PublisherModel memory UDS_publisher = abi.decode(UDS_publisherMetadata, (UDS_PublisherModel));

            // Retrieve the total number of publications by the specified publisher.
            currentSize = UDS_publisher.publicationIds.length;

            // Check if the specified start and end indexes are within valid bounds.
            if (!(startIndex >= currentSize || startIndex > endIndex)) {
                // Calculate the size of the preview based on the specified range.
                uint size = endIndex - startIndex + 1;

                // Ensure that the size does not exceed the available publications.
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

                // Initialize the array to store the preview information.
                previewPublicationsOfPublisher = new PublicationPreview_Model[](size);

                // Iterate through the specified range of indexes and add previews to the array.
                for (uint i = 0; i < size; i++) {
                    // Retrieve the publication id based on the current index.
                    bytes32 publicationid = UDS_publisher.publicationIds[startIndex + i];

                    // Decode the publication metadata and retrieve the article title.
                    previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                        abi.decode(
                            _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publicationid),
                            (UDS_PublicationModel)
                        ).article.title,
                        publicationid
                    );
                }
            }
        }
    }
}