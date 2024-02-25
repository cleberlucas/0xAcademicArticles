// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSStorageModel.sol";

/**
 * @title UDSStorage
 * @dev Abstract contract implementing the storage components for Unified Data Storage (UDS).
 */
abstract contract UDSStorage {
    /// @dev Instance of Data for managing data.
    UDSStorageModel.Data internal _data;
    
    /// @dev Instance of Interconnection for managing sender interconnection.
    UDSStorageModel.Interconnection internal _interconnection;
}
