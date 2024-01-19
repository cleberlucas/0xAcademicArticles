// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IACAR.sol";
import "./ACARConnection.sol";
import "./ACARInteract.sol";
import "./ACARSearch.sol";

// Created by Cleber Lucas
contract ACAR is IACAR, ACARConnection, ACARInteract, ACARSearch {}