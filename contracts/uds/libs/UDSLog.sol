// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title UDSLog
 * @dev Library for logging Unified Data Storage (UDS) related events.
 * @notice This library defines events for metadata actions such as sending, updating, and cleaning,
 *         as well as events for sender-related actions like signing and transferring signatures.
 */
library UDSLog {
    
    /**
     * @dev Emitted when metadata is sent.
     * @param signature The signature associated with the metadata.
     * @param classification The classification associated with the metadata.
     * @param id The id associated with the metadata.
     * @param metadata The hash of the metadata that was sent.
     */
    event MetadataSended(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed id, bytes32 metadata);
    
    /**
     * @dev Emitted when metadata is updated.
     * @param signature The signature associated with the metadata.
     * @param classification The classification associated with the metadata.
     * @param id The id associated with the metadata.
     * @param metadata The updated hash of the metadata.
     */
    event MetadataUpdated(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed id, bytes32 metadata);
    
    /**
     * @dev Emitted when metadata is cleaned (removed).
     * @param signature The signature associated with the metadata.
     * @param classification The classification associated with the metadata.
     * @param id The id associated with the metadata.
     */
    event MetadataCleaned(bytes32 indexed signature, bytes32 indexed classification, bytes32 indexed id);
    
    /**
     * @dev Emitted when a sender signs a signature.
     * @param signature The signature that was signed.
     * @param sender The address of the sender who signed the signature.
     */
    event SenderSigned(bytes32 indexed signature, address sender);
    
    /**
     * @dev Emitted when a signature is transferred to a new sender.
     * @param signature The signature that is transferred.
     * @param sender The new address of the sender to whom the signature is transferred.
     */
    event SignatureTransferred(bytes32 indexed signature, address sender);
}
