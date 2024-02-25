// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IUDSRead
 * @dev Interface for interacting with UDS (Unified data storage) Read functionalities.
 * @notice This interface provides methods for retrieving information related to senders,
 *         signatures, classifications, ids, and metadata.
 */
interface IUDSRead {
    
    /**
     * @dev Returns an array of all senders.
     * @return senders An array containing the addresses of all senders.
     */
    function Senders() external view returns (address[] memory senders);
    
    /**
     * @dev Returns the signature associated with a specific sender.
     * @param sender The address of the sender.
     * @return signature The signature corresponding to the provided sender address.
     */
    function Signature(address sender) external view returns (bytes32 signature);
    
    /**
     * @dev Returns the sender associated with a specific signature.
     * @param signature The signature to query.
     * @return sender The address of the sender corresponding to the provided signature.
     */
    function Sender(bytes32 signature) external view returns (address sender);
    
    /**
     * @dev Returns an array of classifications associated with a specific signature.
     * @param signature The signature to query.
     * @return classifications An array containing the classifications related to the provided signature.
     */
    function Classifications(bytes32 signature) external view returns (bytes32[] memory classifications);
    
    /**
     * @dev Returns an array of ids associated with a specific signature and classification.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @return ids An array containing the ids related to the provided signature and classification.
     */
    function Ids(bytes32 signature, bytes32 classification) external view returns (bytes32[] memory ids);
    
    /**
     * @dev Returns the metadata associated with a specific signature, classification, and id.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @param id The id to query.
     * @return metadata The metadata corresponding to the provided signature, classification, and id.
     */
    function Metadata(bytes32 signature, bytes32 classification, bytes32 id) external view returns (bytes memory metadata);
}