// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IACAR.sol";
import "./ACARInteract.sol";
import "./ACARSearch.sol";

contract ACAR is IACAR, ACARInteract, ACARSearch {
    /*
        ACAR - Academic Articles   
        Created by Cleber Lucas
    */
    constructor() {
        OWNER = msg.sender;
    }
}