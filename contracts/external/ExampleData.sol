// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleDataModel.sol";
import "../IAcademicArticles.sol";

pragma solidity ^0.8.23;

abstract contract ExampleData {

    address internal immutable OWNER;
    address internal immutable CONTRACT;

    IAcademicArticles internal _academicArticles;

    ExampleDataModel.Publication internal _publication;
    ExampleDataModel.Affiliate internal _affiliate;
    ExampleDataModel.Me internal _me;
}