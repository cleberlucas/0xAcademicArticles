// SPDX-License-Identifier: MIT

import "./Handlers/StateHandler.sol";
import "./Handlers/ViewHandler.sol";
import "./Interfaces/IMain.sol";

pragma solidity >= 0.8.22;

contract Main is IMain, ViewHandler, StateHandler {}