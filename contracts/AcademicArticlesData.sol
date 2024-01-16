// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./AcademicArticlesDataModel.sol";

abstract contract AcademicArticlesData {
    AcademicArticlesDataModel.Article internal _article;
    AcademicArticlesDataModel.Interconnection internal _interconnection;
}