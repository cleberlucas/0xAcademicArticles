// SPDX-License-Identifier: MIT

import "./AcademicArticlesDataLib.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesRepository {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;

    AcademicArticlesDataLib.Article _article;
    AcademicArticlesDataLib.Institution _institution;
}
