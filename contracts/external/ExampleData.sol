// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./ExampleDataModel.sol";
import "../IAcademicArticles.sol";

abstract contract ExampleData {
    address internal immutable OWNER;
    IAcademicArticles internal _academicArticles;
    ExampleDataModel.Publication internal _publication;
    ExampleDataModel.Affiliate internal _affiliate;
    ExampleDataModel.Me internal _me;
}