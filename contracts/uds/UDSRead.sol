// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IUDSRead.sol";
import "./UDSStorage.sol";

/**
 * @title UDSRead
 * @dev Abstract contract implementing read functionalities for Unified Data Storage (UDS).
 * @notice It inherits from IUDSRead interface and uses the storage components from UDSStorage to read data.
 */
abstract contract UDSRead is IUDSRead, UDSStorage {
    
    /**
     * @dev Returns an array of all senders.
     * @return senders An array containing the addresses of all senders.
     */
    function Senders() external view override returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    /**
     * @dev Returns the signature associated with a specific sender.
     * @param sender The address of the sender.
     * @return signature The signature corresponding to the provided sender address.
     */
    function Signature(address sender) external view override returns (bytes32 signature) {
        signature = _interconnection.signature[sender];
    }

    /**
     * @dev Returns the sender associated with a specific signature.
     * @param signature The signature to query.
     * @return sender The address of the sender corresponding to the provided signature.
     */
    function Sender(bytes32 signature) external view override returns (address sender) {
        sender = _interconnection.sender[signature];
    }

    /**
     * @dev Returns an array of classifications associated with a specific signature.
     * @param signature The signature to query.
     * @return classifications An array containing the classifications related to the provided signature.
     */
    function Classifications(bytes32 signature) external view override returns (bytes32[] memory classifications) {
        classifications = _token.classifications[signature];
    }

    /**
     * @dev Returns an array of keys associated with a specific signature and classification.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @return keys An array containing the keys related to the provided signature and classification.
     */
    function Keys(bytes32 signature, bytes32 classification) external view override returns (bytes32[] memory keys) {
        keys = _token.keys[signature][classification];
    }

    /**
     * @dev Returns the metadata associated with a specific signature, classification, and key.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @param key The key to query.
     * @return metadata The metadata corresponding to the provided signature, classification, and key.
     */
    function Metadata(bytes32 signature, bytes32 classification, bytes32 key) external view override returns (bytes memory metadata) {
        metadata = _token.metadata[signature][classification][key];
    }
}
