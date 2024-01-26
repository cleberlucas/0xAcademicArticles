// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title AIOSearch
 * @notice This abstract contract provides functions for searching and retrieving data from the AIOStorage contract.
 */
 
// Import the interface for AIO search functionality
import "./interfaces/IAIOSearch.sol";
// Import the AIOStorage contract for accessing stored data
import "./AIOStorage.sol";

abstract contract AIOSearch is IAIOSearch, AIOStorage {
    /**
     * @dev Retrieves the IDs associated with a given signature.
     * @param signature The signature to query.
     * @return ids An array of IDs associated with the provided signature.
     */
    function Ids(string calldata signature) 
    external view 
    returns (bytes32[] memory ids) {
        ids = _token.ids[signature];
    }

    /**
     * @dev Retrieves the signature associated with a given ID.
     * @param id The ID to query.
     * @return signature The signature associated with the provided ID.
     */
    function Signature(bytes32 id) 
    external view 
    returns (string memory signature) {
        signature = _token.signature[id];
    }

    /**
     * @dev Retrieves the metadata associated with a given ID.
     * @param id The ID to query.
     * @return metadata The metadata associated with the provided ID.
     */
    function MetaData(bytes32 id) 
    external view 
    returns (bytes memory metadata) {
        metadata = _token.metadata[id];
    }

    /**
     * @dev Retrieves the array of all senders registered in the AIO system.
     * @return senders An array containing all registered senders.
     */
    function Senders()
    external view
    returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    /**
     * @dev Retrieves the signature associated with a given sender's address.
     * @param sender The sender's address to query.
     * @return signature The signature associated with the provided sender's address.
     */
    function Signature(address sender)
    external view
    returns (string memory signature) {
        signature = _interconnection.signature[sender];
    }

    /**
     * @dev Retrieves the sender's address associated with a given signature.
     * @param signature The signature to query.
     * @return sender The sender's address associated with the provided signature.
     */
    function Sender(string calldata signature)
    external view
    returns (address sender) {
        sender = _interconnection.sender[signature];
    }
}