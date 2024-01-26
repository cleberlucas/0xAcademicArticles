// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IAIOSearch
 * @notice Interface for searching and retrieving information related to the AIO (All In One) system.
 */
interface IAIOSearch {
    /**
     * @dev Get the unique identifiers (IDs) associated with a given signature.
     * @param signature The signature for which IDs are to be retrieved.
     * @return ids An array of unique identifiers (IDs) associated with the given signature.
     */
    function Ids(string calldata signature) external view returns (bytes32[] memory ids);

    /**
     * @dev Get the signature associated with a specific ID.
     * @param id The unique identifier (ID) for which the associated signature is to be retrieved.
     * @return signature The signature associated with the given ID.
     */
    function Signature(bytes32 id) external view returns (string memory signature);

    /**
     * @dev Get the metadata associated with a specific ID.
     * @param id The unique identifier (ID) for which the associated metadata is to be retrieved.
     * @return metadata The metadata associated with the given ID.
     */
    function MetaData(bytes32 id) external view returns (bytes memory metadata);

    /**
     * @dev Get the list of all senders in the AIO system.
     * @return senders An array containing all sender addresses in the AIO system.
     */
    function Senders() external view returns (address[] memory senders);

    /**
     * @dev Get the signature associated with a specific sender address.
     * @param sender The address for which the associated signature is to be retrieved.
     * @return signature The signature associated with the given sender address.
     */
    function Signature(address sender) external view returns (string memory signature);

    /**
     * @dev Get the sender address associated with a specific signature.
     * @param signature The signature for which the associated sender address is to be retrieved.
     * @return sender The sender address associated with the given signature.
     */
    function Sender(string calldata signature) external view returns (address sender);
}