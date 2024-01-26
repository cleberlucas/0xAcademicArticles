// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIOInterconnection
 * @notice This contract handles the initialization and transfer of signatures in the AIO system.
 */

// Import the logging library for AIOInterconnection
import "./libs/AIOLog.sol";
// Import the interface for AIO interconnection functionality
import "./interfaces/IAIOInterconnection.sol";
// Import the interface for AIO signature functionality
import "./interfaces/IAIOSignature.sol";
// Import the AIOStorage contract for accessing stored data
import "./AIOStorage.sol";
// Import the rules and modifiers for AIO functionality
import "./AIORules.sol";

contract AIOInterconnection is IAIOInterconnection, AIOStorage, AIORules {
    /**
     * @dev Initializes the sender by signing with a unique signature.
     */
    function Initialize()
    external
    InitializeRule(_interconnection) {
        // Get the sender's address and retrieve the associated fixed signature
        address sender = msg.sender;
        string memory signature = IAIOSignature(sender).SIGNATURE();

        // Update interconnection mappings with sender information
        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        // Emit an event indicating that the sender has been signed
        emit AIOLog.SenderSigned(sender);
    }

    /**
     * @dev Transfers the signature from the old sender to the new sender.
     * @param newSender The address of the new sender.
     */
    function TransferSignature(address newSender)
    external
    TransferSignatureRule(_interconnection, newSender) {
        // Get the old sender's address
        address oldSender = msg.sender;

        // Iterate through the array of senders to find the old sender
        for (uint256 i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                string memory signature = IAIOSignature(oldSender).SIGNATURE();

                // Find the matching old sender and remove it from the array
                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();

                // Clear the old sender's signature in the mapping
                _interconnection.signature[oldSender] = "";

                // Update the interconnection mappings with the new sender information
                _interconnection.senders.push(newSender); 
                _interconnection.sender[signature] = newSender;
                _interconnection.signature[newSender] = signature;

                // Emit an event indicating that the signature has been transferred
                emit AIOLog.SignatureTransferred(newSender);
                break;
            }
        }
    }
}