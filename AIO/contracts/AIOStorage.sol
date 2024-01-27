// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOStorageModel.sol";

abstract contract AIOStorage {
    AIOStorageModel.Token internal _token;
    AIOStorageModel.Interconnection internal _interconnection;
}