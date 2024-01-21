// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IAIOInteract.sol";
import "./interfaces/IAIOSearch.sol";
import "./AIOInterconnection.sol";
import "./AIOInteract.sol";
import "./AIOSearch.sol";

/*
    AIO - All in One
    Created by Cleber Lucas
    Proposal: stores data from different contracts in just one central contract, facilitating extensions of external contracts
*/
contract AIO is AIOInterconnection, AIOInteract, AIOSearch {}
