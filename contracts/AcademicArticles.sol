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
 * @dev It manages academic articles with integration to the UDS (Unified Data Storage) platform.
 * @author Cleber Lucas
 */
contract AcademicArticles{
    /**
    * @notice Represents the storage model for connecting to the UDS.
    */
    struct UDS_StorageModel {
        IUDSRead read;    // Instance of the UDSRead interface for reading data in the UDS.
        IUDSWrite write;   // Instance of the UDSWrite interface for writing data to the UDS.
    }

    /**
    * @notice Represents metadata for a publication in the UDS.
    */
    struct Publication_UDSModel {
        Article_Model article;    // Information about the article being published.
        address publisher;        // Address of the publisher.
        uint datetime;            // Timestamp of the publication.
        uint blockNumber;         // Block number when the publication was made.
    }

    /**
    * @notice Represents metadata for a publisher in the UDS.
    */
    struct Publisher_UDSModel {
        bytes32[] ids;    // Array of unique identifiers representing publications by the publisher.
    }

    /**
    * @notice Represents detailed information about an article.
    */
    struct Article_Model {
        string title;              // Title of the article.
        string summary;            // Summary or abstract of the article, also used as the unique identifier (id) by hashing.
        string additionalInfo;     // Additional information about the article.
        string institution;        // Institution associated with the article.
        string course;             // Course related to the article.
        string articleType;        // Type of the article (e.g., research, thesis).
        string academicDegree;     // Academic degree associated with the article.
        string documentationURI;   // URI for additional documentation related to the article.
        string[] authors;          // Array of authors contributing to the article.
        string[] advisors;         // Array of advisors for the article.
        string[] examiningBoard;   // Array of examining board members for the article.
        uint16 presentationYear;   // Year when the article was presented.
    }

    /**
    * @notice Represents a preview of a publication for display purposes.
    */
    struct PublicationPreview_Model {
        string title;      // Title of the publication.
        bytes32 id;        // Unique identifier of the publication.
    }

    /**
    * @notice Represents parameters for changing the documentation URI of an article.
    */
    struct ChangeDocumentationURI_Parameter {
        bytes32 id;                // Unique identifier of the article.
        string documentationURI;   // New documentation URI for the article.
    }

    /**
     * @notice Instance of a bridge for storage on the UDS.
     */
    UDS_StorageModel private _uds;

    /**
     * @custom:initial-scope Internal control variables.
     * @notice Secret key used for signature transfer.
     */
    bytes32 private constant SECRETKEY = 0x07855b46a623a8ecabac76ed697aa4e13631e3b6718c8a0d342860c13c30d2fc;

    /**
     * @notice Fixed keys used as classification on the UDS.
     */
    bytes32 private constant UDS_SIGNATURE = "AcademicArticles";
    bytes32 private constant UDS_CLASSIFICATION_PUBLISHER = "Publisher";
    bytes32 private constant UDS_CLASSIFICATION_PUBLICATION = "Publication";

    /**
     * @notice Variable to prevent double execution.
     */
    bool private connectToUDS;
    bool private transferUDSSignature;

    /**
     * @notice Owner of the contract.
     * @custom:final-scope Internal control variables.
     */
    address private immutable OWNER;

    /**
     * @notice Constructor initializes the contract with the deploying address as the owner.
     */
    constructor() {
        OWNER = msg.sender;
    }

    /**
    * @notice Allows connection to the UDS.
    * @param account The address of the UDS account to connect to.
    */
    function ConnectToUDS(address account) 
     external {
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
    * @notice Transfers the UDS signature to a new address.
    * @param sender The new address to receive the UDS signature.
    * @param secretKey The secret key for the transfer.
    * @dev Can only be used once, as the secret key is revealed during the transaction.
    */
    function TransferUDSSignature(address sender, bytes calldata secretKey) 
    external {
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
    * @notice Publishes articles.
    * @param articles An array of Article_Model containing article information.
    */
    function PublishArticles(Article_Model[] calldata articles) 
    external {
        // Create an array to store the generated IDs for the articles.
        bytes32[] memory ids = new bytes32[](articles.length);

        // Get the address of the publisher initiating the publishing.
        address publisher = msg.sender;

        // Encode the publisher address to use as a key for UDS.
        bytes32 publisherUDSKey = bytes32(abi.encode(publisher));

        // Retrieve information about the publisher from the UDS.
        Publisher_UDSModel memory publisherUDS = Publisher(publisher);

        // Iterate through the provided articles to publish them.
        for (uint i = 0; i < articles.length; i++) {
            // Generate a unique ID for each article based on its summary.
            bytes32 id = keccak256(abi.encode(articles[i].summary));

            // Try to send metadata to the UDS for the new publication.
            try _uds.write.SendMetadata(
                UDS_CLASSIFICATION_PUBLICATION,
                id,           
                abi.encode( 
                    Publication_UDSModel ( 
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

            // Store the generated ID for the published article.
            ids[i] = id;
        }

        // If the publisher has already posted, update their list of IDs; otherwise, add the new IDs.
        if (publisherUDS.ids.length > 0) {
            // Create a new array to store the combined list of IDs.
            bytes32[] memory newIds = new bytes32[](publisherUDS.ids.length + ids.length);

            // Combine the existing IDs with the new IDs.
            for (uint i = 0; i < newIds.length; i++) {
                if (i < publisherUDS.ids.length) {
                    newIds[i] = publisherUDS.ids[i];
                } else {
                    newIds[i] = ids[i - publisherUDS.ids.length];
                }
            }

            // Update the publisher's list of IDs with the combined list.
            publisherUDS.ids = newIds;

            // Update the metadata from the UDS with the updated list of IDs for the publisher.
            _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey, abi.encode(publisherUDS));
        } else {
            // If the publisher has not posted before, directly add the new IDs.
            publisherUDS.ids = ids;

            // Send metadata to the UDS with the list of IDs for the publisher.
            _uds.write.SendMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey, abi.encode(publisherUDS));
        }
    }

    /**
    * @notice Unpublishes articles.
    * @param ids An array of article IDs to be unpublished.
    */
    function UnpublishArticles(bytes32[] calldata ids) 
    external {
        // Get the address of the publisher initiating the unpublishing.
        address publisher = msg.sender;

        // Encode the publisher address to use as a key for UDS.
        bytes32 publisherUDSKey = bytes32(abi.encode(publisher));

        // Retrieve information about the publisher from the UDS.
        Publisher_UDSModel memory publisherUDS = Publisher(publisher);

        // If the publisher has not published anything, abort the flow.
        require(publisherUDS.ids.length > 0, "You have nothing to unpublish");

        // Iterate through the specified IDs to unpublish the corresponding articles.
        for (uint i = 0; i < ids.length; i++) {
            // Get the ID of the article from the parameter.
            bytes32 id = ids[i];

            // Retrieve information about the publication from the UDS based on the article ID.
            Publication_UDSModel memory publicationUDS = Publication(id);

            // Ensure that the article is published and is published by the same publisher initiating the unpublishing.
            require(publicationUDS.publisher != address(0), string.concat("Article[", Strings.toString(i), "] is not published"));
            require(publicationUDS.publisher == publisher, string.concat("Article[", Strings.toString(i), "] is not published by you"));

            // Remove the article's metadata from the UDS.
            _uds.write.CleanMetadata(UDS_CLASSIFICATION_PUBLICATION, id);
        }

        // If the same quantity of articles is passed to be removed, execute the command to clean everything; otherwise, remove the passed IDs from the publisher's IDs list.
        if (publisherUDS.ids.length == ids.length) {
            _uds.write.CleanMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey);
        } else {
            // Create a new array to store the remaining IDs.
            bytes32[] memory newIds = new bytes32[](publisherUDS.ids.length - ids.length);
            uint i_;

            // Iterate through the publisher's existing IDs and filter out the ones to be removed.
            for (uint i = 0; i < publisherUDS.ids.length; i++) {
                bool addId = true;

                // Check if the current ID is from the list of IDs to be removed.
                for (uint ii = 0; ii < ids.length; ii++) {
                    if (ids[ii] == publisherUDS.ids[i]) {
                        addId = false;
                        break;
                    }
                }

                // If the ID is not from the list of IDs to be removed, add it to the new array.
                if (addId) {
                    newIds[i_] = publisherUDS.ids[i];
                    i_++;
                }
            }

            // Update the publisher's list of IDs with the remaining IDs.
            publisherUDS.ids = newIds;

            // Update the metadata from the UDS with the updated list of IDs for the publisher.
            _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey, abi.encode(publisherUDS));
        }
    }

    /**
    * @notice Changes the documentation URI for specified articles.
    * @param parameter An array of ChangeDocumentationURI_Parameter containing article ID and new documentation URI.
    */
    function ChangeDocumentationURI(ChangeDocumentationURI_Parameter[] memory parameter) 
    external {
        // Get the address of the publisher initiating the change.
        address publisher = msg.sender;

        // Retrieve information about the publisher from the UDS.
        Publisher_UDSModel memory publisherUDS = Publisher(publisher);

        // If the publisher has not published anything, abort the flow.
        require(publisherUDS.ids.length > 0, "You have nothing to change");

        // Iterate through the specified parameters to update documentation URIs for the corresponding articles.
        for (uint i = 0; i < parameter.length; i++) {
            // Get the ID of the article from the parameter.
            bytes32 id = parameter[i].id;

            // Retrieve information about the publication from the UDS based on the article ID.
            Publication_UDSModel memory publicationUDS = Publication(id);

            // Ensure that the article is published and is published by the same publisher initiating the change.
            require(publicationUDS.publisher != address(0), string.concat("Article[", Strings.toString(i), "] is not published"));
            require(publicationUDS.publisher == publisher, string.concat("Article[", Strings.toString(i), "] is not published by you"));

            // Update the documentation URI for the article.
            publicationUDS.article.documentationURI = parameter[i].documentationURI;

            // Try to update the metadata from the UDS with the new documentation URI.
            try _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLICATION, id, abi.encode(publicationUDS)) {
            } catch Error(string memory errorMessage) {
                // Handling the error for this contract's context
                if (Strings.equal(errorMessage, UDSMessage.SAME_METADATA_ALREADY_SENT)) {
                    // Revert if the new documentation URI already exists for the article.
                    revert(string.concat("Article[", Strings.toString(i), "] the same documentation URI already exists"));
                } else {
                    // Revert for other errors.
                    revert(errorMessage);
                }
            }
        }
    }

    /// @notice Retrieves information about a publisher based on the provided address.
    /// @param publisher The address of the publisher.
    /// @return publisherUDS A Publisher_UDSModel containing metadata about the publisher.
    function Publisher(address publisher) 
    public view 
    returns (Publisher_UDSModel memory publisherUDS) {
        // Retrieve metadata about the publisher from the UDS based on the provided address.
        bytes memory publisherUDSMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLISHER, bytes32(abi.encode(publisher)));

        // Check if metadata about the publisher exists.
        if (publisherUDSMetadata.length > 0) {
            // Decode the metadata to obtain information about the publisher.
            publisherUDS = abi.decode(publisherUDSMetadata, (Publisher_UDSModel));
        }
    }

    /// @notice Retrieves information about a publication based on the provided ID.
    /// @param id The ID of the publication.
    /// @return publication A Publication_UDSModel containing metadata about the publication.
    function Publication(bytes32 id) 
    public view 
    returns (Publication_UDSModel memory publication) {
        // Retrieve metadata about the publication from the UDS based on the provided ID.
        bytes memory publicationUDSMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id);

        // Check if metadata about the publication exists.
        if (publicationUDSMetadata.length > 0) {
            // Decode the metadata to obtain information about the publication.
            publication = abi.decode(publicationUDSMetadata, (Publication_UDSModel));
        }
    }

    /// @notice Retrieves a preview of publications with a specific title up to a specified limit.
    /// @param title The title to search for in publications.
    /// @param limit The maximum number of publications to retrieve in the preview.
    /// @return publicationsPreview An array of PublicationPreview_Model containing preview information about publications.
    function PreviewPublicationsWithTitle(string memory title, uint limit) 
    public view 
    returns (PublicationPreview_Model[] memory publicationsPreview) {
        // Retrieve all publication ids from the UDS.
        bytes32[] memory Ids = _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        // Convert the search title to lowercase for case-insensitive comparison.
        title = StringUtils.ToLower(title);

        // Initialize the array to store the preview information.
        publicationsPreview = new PublicationPreview_Model[](limit);

        // Initialize a counter to keep track of the number of previews added.
        uint previewCount;

        // Iterate through publication ids and add previews based on the search title.
        for (uint i = 0; i < Ids.length && previewCount < limit; i++) {
            bytes32 id = Ids[i];

            // Decode the publication metadata and retrieve the article title.
            string memory articleTitle = StringUtils.ToLower(
                abi.decode(
                    _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id),
                    (Publication_UDSModel)
                ).article.title
            );

            // Check if the search title is a part of the article title.
            if (StringUtils.ContainWord(title, articleTitle)) {
                // Add a new preview with the article title and ID to the array.
                publicationsPreview[previewCount] = PublicationPreview_Model(articleTitle, id);
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

    /// @notice Retrieves a preview of publications within a specified range.
    /// @param startIndex The starting index of publications to retrieve.
    /// @param endIndex The ending index of publications to retrieve.
    /// @return publicationsPreview An array of PublicationPreview_Model containing preview information about publications.
    /// @return currentSize The total number of publications in the UDS.
    function PreviewPublications(uint startIndex, uint endIndex) 
    public view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint currentSize) {
        // Retrieve the total number of publications from the UDS.
        currentSize = _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION).length;

        // Check if the specified start and end indexes are within valid bounds.
        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            // Calculate the size of the preview based on the specified range.
            uint size = endIndex - startIndex + 1;

            // Ensure that the size does not exceed the available publications.
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            // Initialize the array to store the preview information.
            publicationsPreview = new PublicationPreview_Model[](size);

            // Retrieve all publication ids from the UDS.
            bytes32[] memory Ids = _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

            // Iterate through the specified range of indexes and add previews to the array.
            for (uint i = 0; i < size; i++) {
                // Retrieve the publication ID based on the current index.
                bytes32 id = Ids[startIndex + i];

                // Decode the publication metadata and retrieve the article title.
                publicationsPreview[i] = PublicationPreview_Model(
                    abi.decode(
                        _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id),
                        (Publication_UDSModel)
                    ).article.title,
                    id
                );
            }
        }
    }

    /// @notice Retrieves a preview of publications by a specific publisher within a specified range.
    /// @param publisher The address of the publisher.
    /// @param startIndex The starting index of publications to retrieve.
    /// @param endIndex The ending index of publications to retrieve.
    /// @return previewPublicationsOfPublisher An array of PublicationPreview_Model containing preview information about publications.
    /// @return currentSize The total number of publications by the specified publisher in the UDS.
    function PreviewPublicationsOfPublisher(address publisher, uint startIndex, uint endIndex) 
    public view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint currentSize) {
        // Retrieve metadata about the publisher from the UDS.
        bytes memory publisherUDSMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLISHER, bytes32(abi.encode(publisher)));

        // Check if metadata about the publisher exists.
        if (publisherUDSMetadata.length > 0) {
            // Decode the metadata to obtain information about the publisher.
            Publisher_UDSModel memory publisherUDS = abi.decode(publisherUDSMetadata, (Publisher_UDSModel));

            // Retrieve the total number of publications by the specified publisher.
            currentSize = publisherUDS.ids.length;

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
                    // Retrieve the publication ID based on the current index.
                    bytes32 id = publisherUDS.ids[startIndex + i];

                    // Decode the publication metadata and retrieve the article title.
                    previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                        abi.decode(
                            _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id),
                            (Publication_UDSModel)
                        ).article.title,
                        id
                    );
                }
            }
        }
    }
}