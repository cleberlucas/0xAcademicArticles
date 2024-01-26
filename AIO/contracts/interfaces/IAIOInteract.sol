// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IAIOInteract
 * @notice Interface defining functions for sending and cleaning metadata in the AIO (All In One) system.
 */
interface IAIOInteract {
    /**
     * @dev Sends metadata in the AIO system.
     * @param metadata The metadata to be sent.
     */
    function SendMetaData(bytes calldata metadata) external;

    /**
     * @dev Cleans metadata associated with a specific ID in the AIO system.
     * @param id The ID of the metadata to be cleaned.
     */
    function CleanMetaData(bytes32 id) external;
}