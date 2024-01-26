// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title IAIOSignature
 * @notice This interface defines a function to retrieve a fixed signature associated with the sender.
 * @dev This interface should be inherited by the sender contract.
 */
interface IAIOSignature {
    /**
     * @dev Returns a fixed signature for the sender that the AIO contract will read later to use as
     * the signature for its initialization and transfer.
     * @return signature A string representing the fixed signature of the sender.
     */
    function SIGNATURE() external pure returns (string memory signature);
}