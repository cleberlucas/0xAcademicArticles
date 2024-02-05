// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IUDSRead
 * @dev Interface for interacting with UDS (Unified data storage) Read functionalities.
 * @notice This interface provides methods for retrieving information related to senders,
 *         signatures, classifications, keys, and metadata.
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
     * @dev Returns an array of keys associated with a specific signature and classification.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @return keys An array containing the keys related to the provided signature and classification.
     */
    function Keys(bytes32 signature, bytes32 classification) external view returns (bytes32[] memory keys);
    
    /**
     * @dev Returns the metadata associated with a specific signature, classification, and key.
     * @param signature The signature to query.
     * @param classification The classification to query.
     * @param key The key to query.
     * @return metadata The metadata corresponding to the provided signature, classification, and key.
     */
    function Metadata(bytes32 signature, bytes32 classification, bytes32 key) external view returns (bytes memory metadata);
}
