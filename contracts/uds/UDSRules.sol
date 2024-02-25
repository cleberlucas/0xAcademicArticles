// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSMessage.sol";
import "./libs/UDSStorageModel.sol";

/**
 * @title UDSRules
 * @dev Abstract contract implementing rules for Unified Data Storage (UDS).
 * @notice It provides modifiers for various sets of rules and functions to execute the external functions that use it.
    To prevent the "Stack Too Deep" error, separate functions have been generated for each modifier.
 */
abstract contract UDSRules {
    
    /**
    * @dev Modifier that implements rules for signature verification.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param signature The signature to be checked against the predefined rules.
    */
    modifier SignRule(UDSStorageModel.Interconnection storage _interconnection, bytes32 signature) {
        RunSignRule(_interconnection, signature);
        _;
    }

    /**
    * @dev Modifier that implements rules for transferring signature.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param sender The address of the new sender.
    */
    modifier TransferSignatureRule(UDSStorageModel.Interconnection storage _interconnection, address sender) {
        RunTransferSignatureRule(_interconnection, sender);
        _;
    }

    /**
    * @dev Modifier that implements rules for updating metadata.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param _data The storage instance for UDS datas.
    * @param classification The classification of the metadata.
    * @param id The id associated with the metadata.
    * @param metadata The updated metadata.
    */
    modifier UpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Data storage _data, bytes32 classification, bytes32 id, bytes calldata metadata) {
        RunUpdateMetadataRule(_interconnection, _data, classification, id, metadata);
        _;
    }

    /**
    * @dev Modifier that implements rules for sending metadata.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param _data The storage instance for UDS datas.
    * @param classification The classification of the metadata.
    * @param id The id associated with the metadata.
    * @param metadata The metadata to be stored.
    */
    modifier SendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Data storage _data, bytes32 classification, bytes32 id, bytes calldata metadata) {
        RunSendMetadataRule(_interconnection, _data, classification, id, metadata);
        _;
    }

    /**
    * @dev Modifier that implements rules for cleaning (removing) metadata.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param _data The storage instance for UDS datas.
    * @param classification The classification of the metadata.
    * @param id The id associated with the metadata.
    */
    modifier CleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Data storage _data, bytes32 classification, bytes32 id) {
        RunCleanMetadataRule(_interconnection, _data, classification, id);
        _;
    }


    /// @dev Run rules for signature.
    function RunSignRule(UDSStorageModel.Interconnection storage _interconnection, bytes32 signature) 
    private view {
        address sender = msg.sender;

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.SIGNATURE_EMPTY);
        require(_interconnection.signature[sender] == bytes32(0), UDSMessage.SENDER_ALREADY_SIGNED);
        require(_interconnection.sender[signature] == address(0), UDSMessage.OTHER_SENDER_USING_SIGNATURE);
    }

    /// @dev Run rules for transferring signature.
    function RunTransferSignatureRule(UDSStorageModel.Interconnection storage _interconnection, address sender) 
    private view {
        address oldSender = msg.sender;

        require(oldSender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(_interconnection.signature[oldSender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(sender != oldSender, UDSMessage.NEW_SENDER_CANNOT_BE_YOU);
        require(sender.code.length > 0, UDSMessage.NEW_SENDER_NOT_CONTRACT);
        require(_interconnection.signature[sender] == bytes32(0), UDSMessage.NEW_SENDER_ALREADY_SIGNED);
    }

    /// @dev Run rules for sending metadata.
    function RunSendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Data storage _data, bytes32 classification, bytes32 id, bytes calldata metadata)
    private view {
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);
        require(_data.metadata[signature][classification][id].length == 0, UDSMessage.METADATA_ALREADY_SENT);
    }

    /// @dev Run rules for updating metadata.
    function RunUpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Data storage _data, bytes32 classification, bytes32 id, bytes calldata metadata) 
    private view {
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];
        bytes storage oldMetadata = _data.metadata[signature][classification][id];

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);
        require(oldMetadata.length > 0, UDSMessage.METADATA_NOT_SENT_TO_UPDATE);
        require(!(keccak256(oldMetadata) == keccak256(metadata) && oldMetadata.length == metadata.length), UDSMessage.SAME_METADATA_ALREADY_SENT);
    }

    /// @dev Run rules for cleaning metadata.
    function RunCleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Data storage _data, bytes32 classification, bytes32 id)
    private view {
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(_data.metadata[signature][classification][id].length > 0, UDSMessage.METADATA_NOT_SENT_TO_DELETE);
    }
}