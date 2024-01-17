// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranInteract.sol";
import "./DuofranSearch.sol";

contract Duofran is DuofranInteract, DuofranSearch  {
    // Created by Cleber Lucas
    constructor(address academicArticles) {
        OWNER = msg.sender;
        _academicArticles = IAcademicArticles(academicArticles);
    }
}