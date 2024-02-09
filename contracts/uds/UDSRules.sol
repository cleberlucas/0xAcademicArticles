// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSMessage.sol";
import "./libs/UDSStorageModel.sol";

/**
 * @title UDSRules
 * @dev Abstract contract implementing rules for Unified Data Storage (UDS).
 * @notice It provides modifiers for various sets of rules and functions to execute the external functions that use it.
 * @notice To prevent the "Stack Too Deep" error, separate functions have been generated for each modifier.
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
    * @param _token The storage instance for UDS tokens.
    * @param classification The classification of the metadata.
    * @param id The id associated with the metadata.
    * @param metadata The updated metadata.
    */
    modifier UpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 id, bytes calldata metadata) {
        RunUpdateMetadataRule(_interconnection, _token, classification, id, metadata);
        _;
    }

    /**
    * @dev Modifier that implements rules for sending metadata.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param _token The storage instance for UDS tokens.
    * @param classification The classification of the metadata.
    * @param id The id associated with the metadata.
    * @param metadata The metadata to be stored.
    */
    modifier SendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 id, bytes calldata metadata) {
        RunSendMetadataRule(_interconnection, _token, classification, id, metadata);
        _;
    }

    /**
    * @dev Modifier that implements rules for cleaning (removing) metadata.
    * @param _interconnection The storage instance for UDS interconnection.
    * @param _token The storage instance for UDS tokens.
    * @param classification The classification of the metadata.
    * @param id The id associated with the metadata.
    */
    modifier CleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 id) {
        RunCleanMetadataRule(_interconnection, _token, classification, id);
        _;
    }


    /**
     * @dev Run rules for signature.
     */
    function RunSignRule(UDSStorageModel.Interconnection storage _interconnection, bytes32 signature) 
    private view {
        // Get the sender's address.
        address sender = msg.sender;

        // Check if the sender is a contract.
        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);

        // Check if the signature is not empty.
        require(signature != bytes32(0), UDSMessage.SIGNATURE_EMPTY);

        // Check if the sender is not already signed.
        require(_interconnection.signature[sender] == bytes32(0), UDSMessage.SENDER_ALREADY_SIGNED);

        // Check if no other sender is using the same signature.
        require(_interconnection.sender[signature] == address(0), UDSMessage.OTHER_SENDER_USING_SIGNATURE);
    }

    /**
     * @dev Run rules for transferring signature.
     */
    function RunTransferSignatureRule(UDSStorageModel.Interconnection storage _interconnection, address sender) 
    private view {
        // Get the address of the old sender performing the transfer.
        address oldSender = msg.sender;

        // Check if the old sender is a contract.
        require(oldSender.code.length > 0, UDSMessage.ONLY_CONTRACT);

        // Check if the old sender is already signed.
        require(_interconnection.signature[oldSender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);

        // Check if the new sender is a contract.
        require(sender.code.length > 0, UDSMessage.NEW_SENDER_NOT_CONTRACT);

        // Check if the new sender is not the same as the old sender.
        require(sender != oldSender, UDSMessage.NEW_SENDER_CANNOT_BE_YOU);
    }

    /**
     * @dev Run rules for sending metadata.
     */
    function RunSendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 id, bytes calldata metadata)
    private view {
        // Get the sender's address and signature.
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];

        // Check if the sender is a contract.
        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);

        // Check if the sender is already signed.
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata is non-empty.
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);

        // Check if the metadata for the specified classification and id is not already sent.
        require(_token.metadata[signature][classification][id].length == 0, UDSMessage.METADATA_ALREADY_SENT);
    }

    /**
     * @dev Run rules for updating metadata.
     */
    function RunUpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 id, bytes calldata metadata) 
    private view {
        // Get the sender's address, signature, and existing metadata.
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];
        bytes storage oldMetadata = _token.metadata[signature][classification][id];

        // Check if the sender is a contract.
        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);

        // Check if the sender is already signed.
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata is non-empty.
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);

        // Check if the existing metadata is sent.
        require(oldMetadata.length > 0, UDSMessage.METADATA_NOT_SENT_TO_UPDATE);

        // Check if the updated metadata is not the same as the existing metadata.
        require(!(keccak256(oldMetadata) == keccak256(metadata) && oldMetadata.length == metadata.length), UDSMessage.SAME_METADATA_ALREADY_SENT);
    }

    /**
     * @dev Run rules for cleaning metadata.
    */
    function RunCleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 id)
    private view {
        // Get the sender's address and signature.
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];

        // Check if the sender is a contract.
        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);

        // Check if the sender is already signed.
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata for the specified classification and id is sent.
        require(_token.metadata[signature][classification][id].length > 0, UDSMessage.METADATA_NOT_SENT_TO_DELETE);
    }
}