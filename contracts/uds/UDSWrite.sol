// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSLog.sol";
import "./interfaces/IUDSWrite.sol";
import "./UDSStorage.sol";
import "./UDSRules.sol";

abstract contract UDSWrite is IUDSWrite, UDSStorage, UDSRules {
    function Sign(bytes32 signature)
    external
    SignRule(_interconnection, signature) {
        address sender = msg.sender;

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit UDSLog.SenderSigned(sender);
    }

    function TransferSignature(address sender)
    external
    TransferSignatureRule(_interconnection, sender) {
        address oldSender = msg.sender;
        bytes32 signature = _interconnection.signature[oldSender];

        for (uint i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();
                break;
            }
        }

        _interconnection.signature[oldSender] = "";

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit UDSLog.SignatureTransferred(sender);
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

        emit UDSLog.MetadataSended(signature, classification, key);
    }

    function UpdateMetadata(bytes32 classification, bytes32 key, bytes calldata metadata)
    external
    UpdateMetadataRule(_interconnection, _token, classification, key, metadata) {
        bytes32 signature = _interconnection.signature[msg.sender];

        _token.metadata[signature][classification][key] = metadata;

        emit UDSLog.MetadataUpdated(signature, classification, key);
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

            _token.keys[signature][classification] = new bytes32[](0);
        } else {
            for (uint i = 0; i < _token.keys[signature][classification].length; i++) {
                if (_token.keys[signature][classification][i] == key) {
                    _token.keys[signature][classification][i] = _token.keys[signature][classification][_token.keys[signature][classification].length - 1];
                    _token.keys[signature][classification].pop();           
                    break;
                }
            }
        }

        _token.metadata[signature][classification][key] = new bytes(0);

        emit UDSLog.MetadataCleaned(signature, classification, key);
    }
}