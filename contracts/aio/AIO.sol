// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

// Import external contract interfaces
import "./AIOWrite.sol";
import "./AIORead.sol";

/**
 * @title AIO (All in One)
 * @notice This is a platform for storing contract data
 * @dev Unified storage platform where data is managed and classified by contracts utilizing this medium through their unique signatures.
 * Storing data outside the contract enhances modularity and extensibility, as the data isn't stored directly within it.
 * @author Cleber Lucas
 */
contract AIO is AIOWrite, AIORead {}