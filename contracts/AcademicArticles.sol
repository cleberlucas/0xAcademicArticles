// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./IAcademicArticles.sol";
import "./AcademicArticlesRead.sol";
import "./AcademicArticlesWrite.sol";

pragma solidity ^0.8.23;

contract AcademicArticles is IAcademicArticles, AcademicArticlesRead, AcademicArticlesWrite {}
