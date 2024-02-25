// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Import external contract interfaces
import "./UDSWrite.sol";
import "./UDSRead.sol";

/**
 * @title Unified Data Storage (UDS)
 * @dev This is a platform for storing contract data.
 * @notice In this platform, data from external contracts are stored and managed internally through their unique signatures. 
 * @author Cleber Lucas
 */
contract UDS is UDSWrite, UDSRead {}