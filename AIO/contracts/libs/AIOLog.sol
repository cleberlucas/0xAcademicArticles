// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIOLog
 * @notice Library for logging events related to the AIO (All In One) system.
 */
library AIOLog {
    /**
     * @dev Emitted when metadata is successfully sent.
     * @param id The unique identifier of the metadata.
     */
    event MetadataSended(bytes32 indexed id);

    /**
     * @dev Emitted when metadata is successfully cleaned.
     * @param id The unique identifier of the cleaned metadata.
     */
    event MetadataCleaned(bytes32 indexed id);

    /**
     * @dev Emitted when a new sender is successfully signed.
     * @param sender The address of the newly signed sender.
     */
    event SenderSigned(address indexed sender);

    /**
     * @dev Emitted when a signature is successfully transferred to a new sender.
     * @param newSender The address of the new sender who now holds the signature.
     */
    event SignatureTransferred(address indexed newSender);
}