// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IUDSWrite
 * @dev Interface for interacting with UDS (Unified data storage) Write functionalities.
 * @notice This interface provides methods for signing, transferring signatures, sending metadata,
 *         updating metadata, and cleaning metadata.
 */
interface IUDSWrite {
    
    /**
     * @dev Signs a given signature.
     * @param signature The signature to be signed.
     */
    function Sign(bytes32 signature) external;
    
    /**
     * @dev Transfers the ownership of a signature to a new sender.
     * @param sender The address of the new sender to transfer the signature to.
     */
    function TransferSignature(address sender) external;
    
    /**
     * @dev Sends metadata for a specific classification and key.
     * @param classification The classification associated with the metadata.
     * @param key The key associated with the metadata.
     * @param metadata The metadata to be sent.
     */
    function SendMetadata(bytes32 classification, bytes32 key, bytes calldata metadata) external;
    
    /**
     * @dev Updates existing metadata for a specific classification and key.
     * @param classification The classification associated with the metadata to be updated.
     * @param key The key associated with the metadata to be updated.
     * @param metadata The updated metadata.
     */
    function UpdateMetadata(bytes32 classification, bytes32 key, bytes calldata metadata) external;
    
    /**
     * @dev Cleans (removes) metadata for a specific classification and key.
     * @param classification The classification associated with the metadata to be cleaned.
     * @param key The key associated with the metadata to be cleaned.
     */
    function CleanMetadata(bytes32 classification, bytes32 key) external;
}
