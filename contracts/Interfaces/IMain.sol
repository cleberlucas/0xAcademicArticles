// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "../Interfaces/IStateHandler.sol";
import "../Interfaces/IViewHandler.sol";


interface IMain is IStateHandler, IViewHandler {}
