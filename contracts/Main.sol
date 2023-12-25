// SPDX-License-Identifier: MIT

import "./Interfaces/IMain.sol";
import "./Handlers/StateHandler.sol";
import "./Handlers/ViewHandler.sol";

pragma solidity ^0.8.23;

contract Main is IMain, StateHandler, ViewHandler {}