// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IAIOSearch.sol";
import "./AIOStorage.sol";

abstract contract AIOSearch is IAIOSearch, AIOStorage {
    function Ids(string calldata signature) 
    external view 
    returns (bytes32[] memory ids) {
        ids = _token.ids[signature];
    }

    function Signature(bytes32 id) 
    external view 
    returns (string memory signature) {
        signature = _token.signature[id];
    }

    function MetaData(bytes32 id) 
    external view 
    returns (bytes memory metadata) {
        metadata = _token.metadata[id];
    }

    function Senders()
    external view
    returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    function Signature(address sender)
    external view
    returns (string memory signature) {
        signature = _interconnection.signature[sender];
    }

    function Sender(string calldata signature)
    external view
    returns (address sender) {
        sender = _interconnection.sender[signature];
    }
}