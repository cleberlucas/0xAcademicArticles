// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ACARStorageModel.sol";

abstract contract ACARStorage {
    ACARStorageModel.Article internal _article;
    ACARStorageModel.Contract internal _contract;
}