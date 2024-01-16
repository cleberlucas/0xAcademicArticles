// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./ExampleInteract.sol";
import "./ExampleSearch.sol";

contract Example is ExampleInteract, ExampleSearch  {
    // Created by Cleber Lucas
    constructor(address academicArticles) {
        OWNER = msg.sender;
        _academicArticles = IAcademicArticles(academicArticles);
    }
}