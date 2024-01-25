// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOLog.sol";
import "./interfaces/IAIOInteract.sol";
import "./AIOStorage.sol";
import "./AIORules.sol";

contract AIOInteract is IAIOInteract, AIOStorage, AIORules {
    function SendMetaData(bytes calldata metadata)
    external payable
    SendMetaDataRule(_interconnection, _token, metadata) {
        string storage signature = _interconnection.signature[msg.sender];
        bytes32 id = keccak256(metadata);

        _token.ids[signature].push(id);
        _token.signature[id] = signature;
        _token.metadata[id] = metadata;

        emit AIOLog.MetadataSended(id);
    }

    function CleanMetaData(bytes32 id)
    external payable
    CleanMetaDataRule(_interconnection, _token, id) {
        string storage signature = _interconnection.signature[msg.sender];

        for (uint256 i = 0; i < _token.ids[signature].length; i++) {
            if (_token.ids[signature][i] == id) {
                _token.ids[signature][i] = _token.ids[signature][_token.ids[signature].length - 1];
                _token.ids[signature].pop();

                _token.signature[id] = "";
                _token.metadata[id] = new bytes(0);

                emit AIOLog.MetadataCleaned(id);
                break;
            }
        }
    }
}