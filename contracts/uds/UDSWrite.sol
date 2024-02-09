// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSLog.sol";
import "./interfaces/IUDSWrite.sol";
import "./UDSStorage.sol";
import "./UDSRules.sol";

/**
 * @title UDSWrite
 * @dev Abstract contract implementing write functionalities for Unified Data Storage (UDS).
 * @notice It inherits from IUDSWrite interface, UDSStorage for storage components to write data, and UDSRules for rule implementations.
 */
abstract contract UDSWrite is IUDSWrite, UDSStorage, UDSRules {
    
    /**
     * @dev Allows a sender to sign a specific signature.
     * @param signature The signature to be associated with the sender.
     */
    function Sign(bytes32 signature)
    external
    SignRule(_interconnection, signature) {
        // Get the address of the sender.
        address sender = msg.sender;

        // Add the sender to the list of senders.
        _interconnection.senders.push(sender); 

        // Associate the signature with the sender's address.
        _interconnection.sender[signature] = sender;

        // Associate the sender's address with the signature.
        _interconnection.signature[sender] = signature;

        // Emit the SenderSigned event to indicate a successful signing operation.
        emit UDSLog.SenderSigned(signature, sender);
    }

    /**
     * @dev Allows transferring the signature from one sender to another.
     * @param sender The address of the new sender.
     */
    function TransferSignature(address sender)
    external
    TransferSignatureRule(_interconnection, sender) {
        // Get the address of the old sender performing the transfer.
        address oldSender = msg.sender;

        // Retrieve the signature associated with the old sender.
        bytes32 signature = _interconnection.signature[oldSender];

        // Loop through the list of senders to find and remove the old sender.
        for (uint i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();
                break;
            }
        }

        // Update the signature association for the old sender.
        _interconnection.signature[oldSender] = "";

        // Add the new sender to the list of senders.
        _interconnection.senders.push(sender); 

        // Update the sender association for the transferred signature.
        _interconnection.sender[signature] = sender;

        // Update the signature association for the new sender.
        _interconnection.signature[sender] = signature;

        // Emit the SignatureTransferred event to indicate a successful signature transfer.
        emit UDSLog.SignatureTransferred(signature, sender);
    }

    /**
     * @dev Allows sending metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     * @param metadata The metadata to be stored.
     */
    function SendMetadata(bytes32 classification, bytes32 id, bytes calldata metadata)
    external
    SendMetadataRule(_interconnection, _token, classification, id, metadata) {
        // Retrieve the sender's signature.
        bytes32 signature = _interconnection.signature[msg.sender];

        // Check if there are existing ids for the specified classification.
        if (_token.ids[signature][classification].length == 0) {
            // If no existing ids, add the classification to the sender's token.
            _token.classifications[signature].push(classification);
        }
 
        // Add the id to the sender's token.
        _token.ids[signature][classification].push(id);

        // Store the metadata in the sender's token.
        _token.metadata[signature][classification][id] = metadata;

        // Emit the MetadataSended event to indicate successful metadata sending and storage.
        emit UDSLog.MetadataSended(signature, classification, id, keccak256(metadata));
    }

    /**
     * @dev Allows updating metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     * @param metadata The updated metadata.
     */
    function UpdateMetadata(bytes32 classification, bytes32 id, bytes calldata metadata)
    external
    UpdateMetadataRule(_interconnection, _token, classification, id, metadata) {
        // Retrieve the sender's signature.
        bytes32 signature = _interconnection.signature[msg.sender];

        // Update the metadata for the specified classification and id in the sender's token.
        _token.metadata[signature][classification][id] = metadata;

        // Emit the MetadataUpdated event to indicate successful metadata update.
        emit UDSLog.MetadataUpdated(signature, classification, id, keccak256(metadata));
    }

    /**
     * @dev Allows cleaning (removing) metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     */
    function CleanMetadata(bytes32 classification, bytes32 id)
    external
    CleanMetadataRule(_interconnection, _token, classification, id) {
        // Retrieve the sender's signature.
        bytes32 signature = _interconnection.signature[msg.sender];

        // Check if there is only one id for the specified classification.
        if (_token.ids[signature][classification].length == 1 ) {
            // If only one id, remove the classification from the sender's token.
            for (uint i = 0; i < _token.classifications[signature].length; i++) {
                if (_token.classifications[signature][i] == classification) {
                    _token.classifications[signature][i] = _token.classifications[signature][_token.classifications[signature].length - 1];
                    _token.classifications[signature].pop();             
                    break;
                }
            }

            // Set the ids for the classification to an empty array.
            _token.ids[signature][classification] = new bytes32[](0);
        } else {
            // If more than one id, remove the specified id from the sender's token.
            for (uint i = 0; i < _token.ids[signature][classification].length; i++) {
                if (_token.ids[signature][classification][i] == id) {
                    _token.ids[signature][classification][i] = _token.ids[signature][classification][_token.ids[signature][classification].length - 1];
                    _token.ids[signature][classification].pop();           
                    break;
                }
            }
        }

        // Set the metadata for the specified classification and id to an empty byte array.
        _token.metadata[signature][classification][id] = new bytes(0);

        // Emit the MetadataCleaned event to indicate successful metadata cleaning (removal).
        emit UDSLog.MetadataCleaned(signature, classification, id);
    }
}
