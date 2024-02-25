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
        address sender = msg.sender;

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit UDSLog.SenderSigned(signature, sender);
    }

    /**
     * @dev Allows transferring the signature from one sender to another.
     * @param sender The address of the new sender.
     */
    function TransferSignature(address sender)
    external
    TransferSignatureRule(_interconnection, sender) {
        address oldSender = msg.sender;
        bytes32 signature = _interconnection.signature[oldSender];

        for (uint i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();
                break;
            }
        }

        _interconnection.signature[oldSender] = bytes32(0);
        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

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
    SendMetadataRule(_interconnection, _data, classification, id, metadata) {
        bytes32 signature = _interconnection.signature[msg.sender];

        if (_data.ids[signature][classification].length == 0) {
            _data.classifications[signature].push(classification);
        }
 
        _data.ids[signature][classification].push(id);
        _data.metadata[signature][classification][id] = metadata;

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
    UpdateMetadataRule(_interconnection, _data, classification, id, metadata) {
        bytes32 signature = _interconnection.signature[msg.sender];

        _data.metadata[signature][classification][id] = metadata;

        emit UDSLog.MetadataUpdated(signature, classification, id, keccak256(metadata));
    }

    /**
     * @dev Allows cleaning (removing) metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     */
    function CleanMetadata(bytes32 classification, bytes32 id)
    external
    CleanMetadataRule(_interconnection, _data, classification, id) {
        bytes32 signature = _interconnection.signature[msg.sender];

        if (_data.ids[signature][classification].length == 1 ) {
            for (uint i = 0; i < _data.classifications[signature].length; i++) {
                if (_data.classifications[signature][i] == classification) {
                    _data.classifications[signature][i] = _data.classifications[signature][_data.classifications[signature].length - 1];
                    _data.classifications[signature].pop();             
                    break;
                }
            }

            _data.ids[signature][classification] = new bytes32[](0);
        } else {
            for (uint i = 0; i < _data.ids[signature][classification].length; i++) {
                if (_data.ids[signature][classification][i] == id) {
                    _data.ids[signature][classification][i] = _data.ids[signature][classification][_data.ids[signature][classification].length - 1];
                    _data.ids[signature][classification].pop();           
                    break;
                }
            }
        }

        _data.metadata[signature][classification][id] = new bytes(0);

        emit UDSLog.MetadataCleaned(signature, classification, id);
    }
}
