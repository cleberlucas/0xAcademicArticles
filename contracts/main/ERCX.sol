// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IERCXInteract.sol";
import "./interfaces/IERCXSearch.sol";
import "./ERCXInterconnection.sol";
import "./ERCXInteract.sol";
import "./ERCXSearch.sol";

// Created by Cleber Lucas
contract ERCX is ERCXInterconnection, ERCXInteract, ERCXSearch {}