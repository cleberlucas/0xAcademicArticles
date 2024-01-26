// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIORules
 * @notice This abstract contract provides modifiers for initializing, transferring signatures, and managing metadata in the AIO system.
 */
 
// Import the messaging library for AIORules
import "./libs/AIOMessage.sol";
// Import the storage model for AIORules
import "./libs/AIOStorageModel.sol";
// Import the interface for AIO signature functionality
import "./interfaces/IAIOSignature.sol";
// Import the OpenZeppelin Strings utility library
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract AIORules {
    /**
     * @dev Modifier for initializing the sender's signature.
     * @param _interconnection The storage instance for interconnection-related data.
     */
    modifier InitializeRule(AIOStorageModel.Interconnection storage _interconnection) {
        address sender = msg.sender;

        // Check if the sender is a contract
        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        try IAIOSignature(sender).SIGNATURE() {
            // Check if the sender has a non-empty signature
            require(bytes(IAIOSignature(sender).SIGNATURE()).length > 0, AIOMessage.SIGNATURE_EMPTY);

            // Check if the sender is not already signed
            require(bytes(_interconnection.signature[sender]).length == 0, AIOMessage.SENDER_ALREADY_SIGNED);

            // Check if the signature is not already used by another sender
            require(_interconnection.sender[IAIOSignature(sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_USING_SIGNATURE);
        } catch {
            // Revert if the sender has no signature
            revert(AIOMessage.SENDER_NO_SIGNATURE);
        }

        _;
    }

    /**
     * @dev Modifier for transferring the signature from the old sender to the new sender.
     * @param _interconnection The storage instance for interconnection-related data.
     * @param newSender The address of the new sender.
     */
    modifier TransferSignatureRule(AIOStorageModel.Interconnection storage _interconnection, address newSender) {
        address oldSender = msg.sender;

        // Check if the old sender is a contract
        require(oldSender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        // Check if the new sender is a contract
        require(newSender.code.length > 0, AIOMessage.NEW_SENDER_NOT_CONTRACT);

        // Check if the old sender is signed
        require(bytes(_interconnection.signature[oldSender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);

        // Check if the new sender is not the same as the old sender
        require(newSender != oldSender, AIOMessage.NEW_SENDER_CANNOT_BE_YOU);

        try IAIOSignature(newSender).SIGNATURE() {
            // Check if the signatures of old and new senders are the same
            require(Strings.equal(IAIOSignature(oldSender).SIGNATURE(), IAIOSignature(newSender).SIGNATURE()), AIOMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        } catch {
            // Revert if the new sender has no signature
            revert(AIOMessage.NEW_SENDER_NO_SIGNATURE);
        }

        _;
    }

    /**
     * @dev Modifier for sending metadata.
     * @param _interconnection The storage instance for interconnection-related data.
     * @param _token The storage instance for token-related data.
     * @param metadata The metadata to be sent.
     */
    modifier SendMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes calldata metadata) {
        address sender = msg.sender;

        // Check if the sender is a contract
        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        // Check if the sender is signed
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata is not empty
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);

        // Check if the metadata is not already sent
        require(bytes(_token.signature[keccak256(metadata)]).length == 0, AIOMessage.METADATA_ALREADY_SENT);

        _;
    }

    /**
     * @dev Modifier for cleaning metadata.
     * @param _interconnection The storage instance for interconnection-related data.
     * @param _token The storage instance for token-related data.
     * @param id The ID of the metadata to be cleaned.
     */
    modifier CleanMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes32 id) {
        address sender = msg.sender;

        // Check if the sender is a contract
        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        // Check if the sender is signed
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata with the given ID is sent
        require(bytes(_token.signature[id]).length > 0, AIOMessage.METADATA_NOT_SENT);

        // Check if the metadata is sent by the sender
        require(Strings.equal((_token.signature[id]), _interconnection.signature[sender]), AIOMessage.METADATA_NOT_SENT_BY_YOU);

        _;
    }
}