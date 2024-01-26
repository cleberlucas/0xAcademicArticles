// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IAIOInterconnection
 * @notice Interface defining functions for initializing and transferring signatures in the AIO (All In One) system.
 */
interface IAIOInterconnection {
    /**
     * @dev Initializes the sender by signing them up in the AIO system.
     */
    function Initialize() external;

    /**
     * @dev Transfers the signature from the current sender to a new sender.
     * @param newSender The address of the new sender.
     */
    function TransferSignature(address newSender) external;
}