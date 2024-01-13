// SPDX-License-Identifier: MIT

import "./AcademicArticlesModel.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesData {
    constructor() {
        OWNER = tx.origin;
    }

    address internal immutable OWNER;

    AcademicArticlesModel.Article internal _article;
    AcademicArticlesModel.External internal _external;
}