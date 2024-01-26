// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIOStorage
 * @notice This abstract contract provides internal storage instances for the AIO system.
 */

// Import the AIOStorageModel library for defining the storage structure
import "./libs/AIOStorageModel.sol";

abstract contract AIOStorage {
    // Internal storage instance for token-related data
    AIOStorageModel.Token internal _token;
    // Internal storage instance for interconnection-related data
    AIOStorageModel.Interconnection internal _interconnection;
}