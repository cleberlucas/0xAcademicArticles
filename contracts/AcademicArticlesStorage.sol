// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AcademicArticlesStorageModel.sol";

abstract contract AcademicArticlesStorage {
    AcademicArticlesStorageModel.Article internal _article;
    AcademicArticlesStorageModel.Contract internal _contract;
}