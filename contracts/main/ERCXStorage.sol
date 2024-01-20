// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ERCXStorageModel.sol";

abstract contract ERCXStorage {
    ERCXStorageModel.Data internal _data;
    ERCXStorageModel.Interconnection internal _interconnection;
}