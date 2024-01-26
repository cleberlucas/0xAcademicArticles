// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIO (All In One) Contract
 * @author Cleber Lucas
 * @notice This contract serves as the central point in the AIO system with data traceability.
 * - Combines functionalities from AIOInterconnection, AIOInteract, and AIOSearch contracts.
 * - Acts as the central component providing a unified interface for interaction, interconnection, data retrieval, and traceability within the AIO system.
 * - Designed to facilitate continuous communication and collaboration among various components in the AIO ecosystem.
 * - Users can interact, transfer signatures, send and search metadata, and perform other actions through this unified contract.
 *
 */

// Import the contract providing functionality for interconnecting senders
import "./AIOInterconnection.sol";
// Import the contract providing functionality for sender interactions
import "./AIOInteract.sol";
// Import the contract providing functionality for searching and retrieving data
import "./AIOSearch.sol";

contract AIO is AIOInterconnection, AIOInteract, AIOSearch {}