// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSStorageModel.sol";

abstract contract UDSStorage {
    UDSStorageModel.Token internal _token;
    UDSStorageModel.Interconnection internal _interconnection;
}