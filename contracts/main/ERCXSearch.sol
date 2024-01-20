// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IERCXSearch.sol";
import "./ERCXStorage.sol";

abstract contract ERCXSearch is IERCXSearch, ERCXStorage {
    function Tokens(string calldata signature) 
    external view 
    returns (bytes32[] memory tokens) {
        tokens = _data.tokens[signature];
    }

    function Signature(bytes32 token) 
    external view 
    returns (string memory signature) {
        signature = _data.signature[token];
    }

    function MetaData(bytes32 token) 
    external view 
    returns (bytes memory metadata) {
        metadata = _data.metadata[token];
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