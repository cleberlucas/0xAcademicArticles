// SPDX-License-Identifier: MIT

import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesData {

    address internal immutable OWNER;

    AcademicArticlesDataModel.Article internal _article;

    AcademicArticlesDataModel.External internal _external;
}