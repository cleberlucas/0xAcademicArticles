// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./IACARConnection.sol";
import "./IACARInteract.sol";
import "./IACARSearch.sol";

interface IACAR is IACARConnection, IACARInteract, IACARSearch {}