// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOLog.sol";
import "./interfaces/IAIOWrite.sol";
import "./AIOStorage.sol";
import "./AIORules.sol";

abstract contract AIOWrite is IAIOWrite, AIOStorage, AIORules {
    function Initialize()
    external
    InitializeRule(_interconnection) {
        address sender = msg.sender;
        bytes32 signature = IAIOSignature(sender).SIGNATURE();

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit AIOLog.SenderSigned(sender);
    }

    function TransferSignature(address newSender)
    external
    TransferSignatureRule(_interconnection, newSender) {
        address oldSender = msg.sender;

        for (uint i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                bytes32 signature = IAIOSignature(oldSender).SIGNATURE();

                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();

                _interconnection.signature[oldSender] = "";

                _interconnection.senders.push(newSender); 
                _interconnection.sender[signature] = newSender;
                _interconnection.signature[newSender] = signature;

                emit AIOLog.SignatureTransferred(newSender);
                break;
            }
        }
    }

    function SendMetadata(bytes32 classification, bytes32 key, bytes calldata metadata)
    external
    SendMetadataRule(_interconnection, _token, classification, key, metadata) {
        bytes32 signature = _interconnection.signature[msg.sender];

        if (_token.keys[signature][classification].length == 0) {
            _token.classifications[signature].push(classification);
        }

        _token.keys[signature][classification].push(key);
        _token.metadata[signature][classification][key] = metadata;

        emit AIOLog.MetadataSended(signature, classification, key);
    }

    function UpdateMetadata(bytes32 classification, bytes32 key, bytes calldata metadata)
    external
    UpdateMetadataRule(_interconnection, _token, classification, key, metadata) {
        bytes32 signature = _interconnection.signature[msg.sender];

        _token.metadata[signature][classification][key] = metadata;

        emit AIOLog.MetadataUpdated(signature, classification, key);
    }

    function CleanMetadata(bytes32 classification, bytes32 key)
    external
    CleanMetadataRule(_interconnection, _token, classification, key) {
        bytes32 signature = _interconnection.signature[msg.sender];

        if (_token.keys[signature][classification].length == 1 ) {
            for (uint i = 0; i < _token.classifications[signature].length; i++) {            
                if (_token.classifications[signature][i] == classification) {
                    _token.classifications[signature][i] = _token.classifications[signature][_token.classifications[signature].length - 1];
                    _token.classifications[signature].pop();
                    
                    break;
                }
            }
        }

        for (uint i = 0; i < _token.keys[signature][classification].length; i++) {            
            if (_token.keys[signature][classification][i] == key) {
                _token.keys[signature][classification][i] = _token.keys[signature][classification][_token.keys[signature][classification].length - 1];
                _token.keys[signature][classification].pop();

                _token.metadata[signature][classification][key] = new bytes(0);

                emit AIOLog.MetadataCleaned(signature, classification, key);
                break;
            }
        }

        emit AIOLog.MetadataCleaned(signature, classification, key);
    }
}