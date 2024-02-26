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
     * @dev Allows a sender to sign a specific signature.
     * @param signature The signature to be associated with the sender.
     */
    function Sign(bytes32 signature) external;
    
    /**
     * @dev Allows transferring the signature from one sender to another.
     * @param sender The address of the new sender.
     */
    function TransferSignature(address sender) external;
    
    /**
     * @dev Allows sending metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     * @param metadata The metadata to be stored.
     */
    function SendMetadata(bytes32 classification, bytes32 id, bytes calldata metadata) external;
    
    /**
     * @dev Allows updating metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     * @param metadata The updated metadata.
     */
    function UpdateMetadata(bytes32 classification, bytes32 id, bytes calldata metadata) external;
    
    /**
     * @dev Allows cleaning (removing) metadata for a specific classification and id.
     * @param classification The classification of the metadata.
     * @param id The id associated with the metadata.
     */
    function CleanMetadata(bytes32 classification, bytes32 id) external;
}
