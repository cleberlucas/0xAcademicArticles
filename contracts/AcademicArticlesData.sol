// SPDX-License-Identifier: MIT

import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesData {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;

    AcademicArticlesDataModel.Article internal _article;
    AcademicArticlesDataModel.Institution internal _institution;
}
