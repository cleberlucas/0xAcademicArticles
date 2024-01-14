// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleInteract.sol";
import "./ExampleSearch.sol";

pragma solidity ^0.8.23;

contract Example is ExampleInteract, ExampleSearch  {

    constructor(address academicArticles) {

        OWNER = msg.sender;
        CONTRACT = address(this);

        _academicArticles = IAcademicArticles(academicArticles);
    }
}
