// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IAcademicArticles.sol";
import "./AcademicArticlesInteract.sol";
import "./AcademicArticlesSearch.sol";

contract AcademicArticles is IAcademicArticles, AcademicArticlesInteract, AcademicArticlesSearch {
    // Created by Cleber Lucas
    constructor() {
        OWNER = msg.sender;
    }
}