// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./IUDSRead.sol";
import "./UDSStorage.sol";

/**
 * @title UDSRead
 * @dev Abstract contract implementing read functionalities for Unified Data Storage (UDS).
 * @notice It inherits from IUDSRead interface and uses the storage components from UDSStorage to read data.
 */
abstract contract UDSRead is IUDSRead, UDSStorage {
    
    /**
     * @dev Get an array of all senders.
     * @return senders An array containing the addresses of all senders.
     */
    function Senders() 
    external view 
    returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    /**
     * @dev Get the signature associated with a specific sender.
     * @param sender The address of the sender.
     * @return signature The signature corresponding to the provided sender address.
     */
    function Signature(address sender) 
    external view 
    returns (bytes32 signature) {
        signature = _interconnection.signature[sender];
    }

    /**
     * @dev Get the sender associated with a specific signature.
     * @param signature The signature to query.
     * @return sender The address of the sender corresponding to the provided signature.
     */
    function Sender(bytes32 signature) 
    external view 
    returns (address sender) {
        sender = _interconnection.sender[signature];
    }

    /**
     * @dev Get an array of classifications associated with a specific signature.
     * @param signature The signature to query.
     * @return classifications An array containing the classifications related to the provided signature.
     */
    function Classifications(bytes32 signature) 
    external view
    returns (bytes32[] memory classifications) {
        classifications = _data.classifications[signature];
    }

    /**
     * @dev Get an array of ids associated with a specific signature and classification.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @return ids An array containing the ids related to the provided signature and classification.
     */
    function Ids(bytes32 signature, bytes32 classification) 
    external view 
    returns (bytes32[] memory ids) {
        ids = _data.ids[signature][classification];
    }

    /**
     * @dev Get the metadata associated with a specific signature, classification, and id.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @param id The id to query.
     * @return metadata The metadata corresponding to the provided signature, classification, and id.
     */
    function Metadata(bytes32 signature, bytes32 classification, bytes32 id) 
    external view
    returns (bytes memory metadata) {
        metadata = _data.metadata[signature][classification][id];
    }
}
