// SPDX-License-Identifier: MIT

pragma solidity >=0.8.22;

import "../Interfaces/IStateHandler.sol";
import "../Interfaces/IViewHandler.sol";

interface IMain is IViewHandler, IStateHandler {}
