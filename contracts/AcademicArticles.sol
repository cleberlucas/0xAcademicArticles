// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./IAcademicArticles.sol";
import "./AcademicArticlesInteract.sol";
import "./AcademicArticlesSearch.sol";

pragma solidity ^0.8.23;

contract AcademicArticles is IAcademicArticles, AcademicArticlesInteract, AcademicArticlesSearch {
    constructor() {
        OWNER = msg.sender;
    }
}