// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIOInteract
 * @notice This contract handles the interaction with metadata in the AIO system.
 */

// Import the logging library for AIOInteract
import "./libs/AIOLog.sol";
// Import the interface for AIO interaction functionality
import "./interfaces/IAIOInteract.sol";
// Import the AIOStorage contract for accessing stored data
import "./AIOStorage.sol";
// Import the rules and modifiers for AIO functionality
import "./AIORules.sol";

contract AIOInteract is IAIOInteract, AIOStorage, AIORules {
    /**
     * @dev Sends metadata to the AIO contract.
     * @param metadata The metadata to be sent.
     */
    function SendMetaData(bytes calldata metadata)
    external
    SendMetaDataRule(_interconnection, _token, metadata) {
        // Retrieve the sender's signature from the interconnection mapping
        string storage signature = _interconnection.signature[msg.sender];
        // Generate an ID using the metadata and store it in the token mappings
        bytes32 id = keccak256(metadata);

        _token.ids[signature].push(id);
        _token.signature[id] = signature;
        _token.metadata[id] = metadata;

        // Emit an event indicating that metadata has been successfully sent
        emit AIOLog.MetadataSended(id);
    }

    /**
     * @dev Cleans metadata based on its ID.
     * @param id The ID of the metadata to be cleaned.
     */
    function CleanMetaData(bytes32 id)
    external
    CleanMetaDataRule(_interconnection, _token, id) {
        // Retrieve the sender's signature from the interconnection mapping
        string storage signature = _interconnection.signature[msg.sender];

        // Iterate through the array of IDs associated with the sender's signature
        for (uint256 i = 0; i < _token.ids[signature].length; i++) {            
            if (_token.ids[signature][i] == id) {
                // Find the matching ID and remove it from the array
                _token.ids[signature][i] = _token.ids[signature][_token.ids[signature].length - 1];
                _token.ids[signature].pop();

                // Clear the corresponding entries in the token mappings
                _token.signature[id] = "";
                _token.metadata[id] = new bytes(0);

                // Emit an event indicating that metadata has been successfully cleaned
                emit AIOLog.MetadataCleaned(id);
                break;
            }
        }
    }
}