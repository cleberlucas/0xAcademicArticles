// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./interfaces/IAIORead.sol";
import "./AIOStorage.sol";

abstract contract AIORead is IAIORead, AIOStorage {
    function Senders()
    external view
    returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    function Signature(address sender)
    external view
    returns (bytes32 signature) {
        signature = _interconnection.signature[sender];
    }

    function Sender(bytes32 signature)
    external view
    returns (address sender) {
        sender = _interconnection.sender[signature];
    }

    function Classifications(bytes32 signature) 
    external view 
    returns (bytes32[] memory classifications) {
        classifications = _token.classifications[signature];
    }

    function Keys(bytes32 signature, bytes32 classification) 
    external view 
    returns (bytes32[] memory keys) {
        keys = _token.keys[signature][classification];
    }

    function Metadata(bytes32 signature, bytes32 classification, bytes32 key) 
    external view 
    returns (bytes memory metadata) {
        metadata = _token.metadata[signature][classification][key];
    }
}