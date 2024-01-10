// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "./IAcademicArticlesWrite.sol";
import "./IAcademicArticlesRead.sol";

interface IAcademicArticlesMain is IAcademicArticlesWrite, IAcademicArticlesRead {}
