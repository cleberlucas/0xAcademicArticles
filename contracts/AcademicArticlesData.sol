// SPDX-License-Identifier: MIT

import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesData {

    AcademicArticlesDataModel.Article internal _article;
    AcademicArticlesDataModel.ExternalContract internal _externalContract;
}