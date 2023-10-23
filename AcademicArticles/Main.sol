// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./Handlers/InteractionHandler.sol";
import "./Handlers/ViewHandler.sol";

contract Main is ViewHandler, InteractionHandler {}
