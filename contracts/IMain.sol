// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "./IWrite.sol";
import "./IRead.sol";

interface IMain is IWrite, IRead {}
