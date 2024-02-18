// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../uds/interfaces/IUDSWrite.sol";
import "../uds/interfaces/IUDSRead.sol";
import "../uds/libs/UDSMessage.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract AcademicArticles {

    struct UDSStorageModel {
        bool transferedUDSSignature;
        bool connectedToUDS;
        IUDSRead read;
        IUDSWrite write;
    }

    struct UDSPublicationModel {
        ArticleModel article;
        address publisher;
        uint datetime;
        uint blockNumber;
    }

    struct ArticleModel {
        string title;
        string summary;
        string additionalInfo;
        string institution;
        string course;
        string articleType; 
        string academicDegree;
        string documentationCID;
        string[] authors;
        string[] advisors;
        string[] examiningBoard;
        uint16 presentationYear;
    }

    UDSStorageModel private _UDS;

    bytes32 private constant UDS_CLASSIFICATION_PUBLICATION = "Publication";

    address private immutable OWNER;
    bytes32 private immutable SECRET_KEY_HASH;
    bytes32 private immutable UDS_SIGNATURE;

    constructor(bytes32 secretKeyHash, bytes32 UDSSignature) {
        OWNER = msg.sender;
        SECRET_KEY_HASH = secretKeyHash;
        UDS_SIGNATURE = UDSSignature;
    }

    function SignToUDS(address UDSaccount) 
    public {
        require(OWNER == msg.sender, "Owner action");

        require(!_UDS.connectedToUDS, "Already connected to UDS");

        _UDS.read = IUDSRead(UDSaccount);
        _UDS.write = IUDSWrite(UDSaccount);
        _UDS.write.Sign(UDS_SIGNATURE);
        _UDS.connectedToUDS = true;
    }

    function TransferUDSSignature(address sender, bytes calldata secretKey) 
    public {
        require(OWNER == msg.sender, "Owner action");
        require(SECRET_KEY_HASH == keccak256(secretKey), "Invalid secretKey");
        require(!_UDS.transferedUDSSignature, "Already transferred UDS signature");

        _UDS.write.TransferSignature(sender);
        _UDS.transferedUDSSignature = true;
    }

    function PublishArticles(ArticleModel[] calldata articles) 
    public {
        bytes32[] memory publicationIds = new bytes32[](articles.length);
        address publisher = msg.sender;

        for (uint i = 0; i < articles.length; i++) {
            bytes32 UDSPublicationId = keccak256(abi.encode(articles[i].summary));

            try _UDS.write.SendMetadata(
                UDS_CLASSIFICATION_PUBLICATION,
                UDSPublicationId,           
                abi.encode( 
                    UDSPublicationModel ( 
                        articles[i],
                        publisher,
                        block.timestamp,
                        block.number
                    )
                )
            ) {            
                publicationIds[i] = UDSPublicationId;
            } catch Error(string memory errorMessage) {
                if (Strings.equal(errorMessage, UDSMessage.METADATA_ALREADY_SENT)) {
                    revert(string.concat("Article[", Strings.toString(i), "] already published"));
                } else {
                    revert(errorMessage);
                }
            }
        }
    }

    function UnpublishArticles(bytes32[] calldata ids) 
    public {
        address publisher = msg.sender;

        for (uint i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            UDSPublicationModel memory publicationUDS = Publication(id);

            require(publicationUDS.publisher != address(0), string.concat("Article[", Strings.toString(i), "] is not published"));
            require(publicationUDS.publisher == publisher, string.concat("Article[", Strings.toString(i), "] is not published by you"));

            _UDS.write.CleanMetadata(UDS_CLASSIFICATION_PUBLICATION, id);
        }      
    }

    function Publication(bytes32 id) 
    public view 
    returns (UDSPublicationModel memory publication) {
        bytes memory UDSPublicationMetadata = _UDS.read.Metadata(UDS_SIGNATURE, UDS_CLASSIFICATION_PUBLICATION, id);

        if (UDSPublicationMetadata.length > 0) {
            publication = abi.decode(UDSPublicationMetadata, (UDSPublicationModel));
        }
    }
}