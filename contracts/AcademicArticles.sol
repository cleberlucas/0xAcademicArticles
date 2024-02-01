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
 * @notice This is a platform for publishing academic articles
 * @dev Smart contract managing academic articles with integration to the UDS (Unified data storage) platform.
 * @author Cleber Lucas
 */
contract AcademicArticles{
    struct UDS_StorageModel {     
        IUDSRead read;
        IUDSWrite write;
    }

    struct Publication_UDSModel {
        Article_Model article;
        address publisher;
        uint datetime;
        uint blockNumber;
    }

    struct Publisher_UDSModel {
        bytes32[] ids;
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

    struct PublicationPreview_Model {
        string title;
        bytes32 id;
    }

    /**
     * @notice Instance of a bridge for storage on the UDS platform.
     */
    UDS_StorageModel private _uds;

    // Internal control variables
    /**
     * @notice Secret key used for signature transfer.
     */
    bytes32 private constant SECRETKEY = 0x07855b46a623a8ecabac76ed697aa4e13631e3b6718c8a0d342860c13c30d2fc;
    /**
     * @notice Fixed keys used as classification on the UDS platform.
     */
    bytes32 private constant UDS_SIGNATURE = "AcademicArticles";
    bytes32 private constant UDS_CLASSIFICATION_PUBLISHER = "Publisher";
    bytes32 private constant UDS_CLASSIFICATION_PUBLICATION = "Publication";

    /**
     * @notice Variable to prevent double connection of UDS signature.
     */
    bool private connectToUDS;
    /**
     * @notice Variable to prevent double transfer of UDS signature.
     */
    bool private transferUDSSignature;

    /**
     * @notice Owner of the contract.
     */
    address private immutable OWNER;

    /**
     * @notice Constructor initializes the contract with the deploying address as the owner.
     */
    constructor() {
        OWNER = msg.sender;
    }

    /**
     * @notice Allows connection to the UDS platform.
     * @param account The address of the UDS account to connect to.
     */
    function ConnectToUDS(address account) external {
        require(OWNER == msg.sender, "Owner action");
        require(!connectToUDS, "Already connected to UDS");

        IUDSWrite(account).Sign(UDS_SIGNATURE);
        _uds.read = IUDSRead(account);
        _uds.write = IUDSWrite(account);

        connectToUDS = true;
    }

    /**
     * @notice Transfers the UDS signature to a new address.
     * @param sender The new address to receive the UDS signature.
     * @param secretKey The secret key for the transfer. 
     * @dev Can be used only once; revealing its value during the transaction.
     */
    function TransferUDSSignature(address sender, bytes calldata secretKey) external {
        require(OWNER == msg.sender, "Owner action");
        require(SECRETKEY == keccak256(secretKey), "Invalid secretKey");
        require(!transferUDSSignature, "Already transferred UDS signature");

        _uds.write.TransferSignature(sender);

        transferUDSSignature = true;
    }

    function PublishArticles(Article_Model[] calldata articles) 
    external {
        bytes32[] memory ids = new bytes32[](articles.length);
        address publisher = msg.sender;
        bytes32 publisherUDSKey = bytes32(abi.encode(publisher));   
        Publisher_UDSModel memory publisherUDS = Publisher(publisher);
       
        for (uint i = 0; i < articles.length; i++) {
            bytes32 id = keccak256(abi.encode(articles[i]));
            Publication_UDSModel memory publication;

            publication.article = articles[i];
            publication.publisher = publisher;
            publication.datetime = block.timestamp;
            publication.blockNumber = block.number;

            try _uds.write.SendMetadata(UDS_CLASSIFICATION_PUBLICATION, id, abi.encode(publication)) {
            } catch Error(string memory errorMessage) {
                if (keccak256(abi.encodePacked(errorMessage)) == keccak256(abi.encodePacked(UDSMessage.METADATA_ALREADY_SENT))) {
                    revert(string.concat("Article[", Strings.toString(i), "] already published"));          
                } else {
                    revert( errorMessage);
                }
            }
            
            ids[i] = id;
        }

        if (publisherUDS.ids.length > 0) {
            bytes32[] memory newIds = new bytes32[](publisherUDS.ids.length + ids.length);

            for (uint i = 0; i < newIds.length; i++) {
                if (i < publisherUDS.ids.length) {
                    newIds[i] = publisherUDS.ids[i];
                } else {
                    newIds[i] = ids[i - publisherUDS.ids.length];
                }
            }

            publisherUDS.ids = newIds;          
            _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey, abi.encode(publisherUDS));
        } else {
            publisherUDS.ids = ids;
            _uds.write.SendMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey, abi.encode(publisherUDS));
        }
    }

    function UnpublishArticles(bytes32[] calldata ids) 
    external {
        address publisher = msg.sender;
        bytes32 publisherUDSKey = bytes32(abi.encode(publisher));
        Publisher_UDSModel memory publisherUDS = Publisher(publisher);

        require(publisherUDS.ids.length > 0, "You have nothing to unpublish");

        for (uint i = 0; i < ids.length; i++) {
            bytes32 id = ids[i]; 
            bytes memory publicationMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id);

            if (publicationMetadata.length == 0) {
                revert(string.concat("Article[", Strings.toString(i), "] is not published"));
            } else {
                require (abi.decode(publicationMetadata, (Publication_UDSModel)).publisher == publisher, string.concat("Article[", Strings.toString(i), "] is not published by you"));
            }

            _uds.write.CleanMetadata(UDS_CLASSIFICATION_PUBLICATION, id);     
        }

        if (publisherUDS.ids.length == ids.length) {
            _uds.write.CleanMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey);
        } else {  
            bytes32[] memory newIds = new bytes32[](publisherUDS.ids.length - ids.length);     
            uint i_;

            for (uint i = 0; i < publisherUDS.ids.length; i++) {
                bool addId = true;

                for (uint ii = 0; ii < ids.length; ii++) {
                    if (ids[ii] == publisherUDS.ids[i]) {
                        addId = false;
                        break;
                    }
                }

                if (addId) {
                    newIds[i_] = publisherUDS.ids[i];
                    i_ ++;
                }
            }

            publisherUDS.ids = newIds;
            _uds.write.UpdateMetadata(UDS_CLASSIFICATION_PUBLISHER, publisherUDSKey, abi.encode(publisherUDS));
        }
    }

    function Publisher(address publisher) 
    private view 
    returns (Publisher_UDSModel memory publisherUDS) {
        bytes memory publisherUDSMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLISHER, bytes32(abi.encode(publisher)));

        if(publisherUDSMetadata.length > 0) {
            publisherUDS = abi.decode(publisherUDSMetadata, (Publisher_UDSModel));
        }
    }

    function Publication(bytes32 id) 
    external view 
    returns (Publication_UDSModel memory publication) {
        bytes memory publicationUDSMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id);

        if(publicationUDSMetadata.length > 0) {
            publication = abi.decode(publicationUDSMetadata, (Publication_UDSModel));
        }
    }

    function PreviewPublicationsWithTitle(string memory title, uint limit) 
    external view  
    returns (PublicationPreview_Model[] memory publicationsPreview) {
        bytes32[] memory publicationKeys = _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION);

        title = StringUtils.ToLower(title);
        publicationsPreview = new PublicationPreview_Model[](limit);

        uint previewCount;
        for (uint i = 0; i < publicationKeys.length && previewCount < limit; i++) {
            bytes32 id = publicationKeys[i];
            string memory articleTitle = StringUtils.ToLower(
                abi.decode(_uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id), (Publication_UDSModel)).article.title
            );

            if (StringUtils.ContainWord(title, articleTitle)) {
                publicationsPreview[previewCount] = PublicationPreview_Model(articleTitle, id);
                previewCount++;
            }
        }

        if (previewCount < limit) {
            PublicationPreview_Model[] memory publicationsPreviewCopy = publicationsPreview;

            publicationsPreview = new PublicationPreview_Model[](previewCount);
            
            for (uint i = 0; i < previewCount; i++) {
                if (publicationsPreviewCopy[i].id != bytes32(0)) {
                    publicationsPreview[i] = publicationsPreviewCopy[i];
                } else {
                    break;
                }
            }
        }
    }

    function PreviewPublications(uint startIndex, uint endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory publicationsPreview, uint currentSize) {     
        currentSize = _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION).length;

        if (!(startIndex >= currentSize || startIndex > endIndex)) {
            uint size = endIndex - startIndex + 1;
            
            size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
            publicationsPreview = new PublicationPreview_Model[](size); 
            
            for (uint i = 0; i < size; i++) {
                publicationsPreview[i] = PublicationPreview_Model(
                    abi.decode(_uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION)[startIndex + i]), (Publication_UDSModel)).article.title,
                    _uds.read.Keys(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION)[startIndex + i]
                );
            }
        }
    }

    function PreviewPublicationsOfPublisher(address publisher, uint startIndex, uint endIndex) 
    external view 
    returns (PublicationPreview_Model[] memory previewPublicationsOfPublisher, uint currentSize) {
        bytes memory publisherUDSMetadata = _uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLISHER, bytes32(abi.encode(publisher)));

        if(publisherUDSMetadata.length > 0) {
            Publisher_UDSModel memory publisherUDS = abi.decode(publisherUDSMetadata, (Publisher_UDSModel));
            
            currentSize = publisherUDS.ids.length;

            if (!(startIndex >= currentSize || startIndex > endIndex)) {
                uint size = endIndex - startIndex + 1;
                
                size = (size <= currentSize - startIndex) ? size : currentSize - startIndex;
                previewPublicationsOfPublisher = new PublicationPreview_Model[](size); 
                
                for (uint i = 0; i < size; i++) {
                    previewPublicationsOfPublisher[i] = PublicationPreview_Model(
                        abi.decode(_uds.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, publisherUDS.ids[startIndex + i]), (Publication_UDSModel)).article.title,
                        publisherUDS.ids[startIndex + i]
                    );
                }
            }
        } 
    }
}