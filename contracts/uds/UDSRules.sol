// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSMessage.sol";
import "./libs/UDSStorageModel.sol";

abstract contract UDSRules {
    modifier SignRule(UDSStorageModel.Interconnection storage _interconnection, bytes32 signature) {
        RunSignRule(_interconnection, signature);
        _;
    }

    modifier TransferSignatureRule(UDSStorageModel.Interconnection storage _interconnection, address sender) {
        RunTransferSignatureRule(_interconnection, sender);
        _;
    }

    modifier UpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) {
        RunUpdateMetadataRule(_interconnection, _token, classification, key, metadata);
        _;
    }

    modifier SendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) {
        RunSendMetadataRule(_interconnection, _token, classification, key, metadata);
        _;
    }

    modifier CleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key) {
        RunCleanMetadataRule(_interconnection, _token, classification, key);
        _;
    }

    function RunSignRule(UDSStorageModel.Interconnection storage _interconnection, bytes32 signature) 
    private view {
        address sender = msg.sender;

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.SIGNATURE_EMPTY);
        require(_interconnection.signature[sender] == bytes32(0), UDSMessage.SENDER_ALREADY_SIGNED);
        require(_interconnection.sender[signature] == address(0), UDSMessage.OTHER_SENDER_USING_SIGNATURE);
    }

    function RunTransferSignatureRule(UDSStorageModel.Interconnection storage _interconnection, address sender) 
    private view {
        address oldSender = msg.sender;

        require(oldSender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(_interconnection.signature[oldSender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(sender.code.length > 0, UDSMessage.NEW_SENDER_NOT_CONTRACT);
        require(sender != oldSender, UDSMessage.NEW_SENDER_CANNOT_BE_YOU);
    }

    function RunSendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata)
    private view {
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);
        require(_token.metadata[signature][classification][key].length == 0, UDSMessage.METADATA_ALREADY_SENT);
        
    }

    function RunUpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) 
    private view {
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];
        bytes storage oldMetadata = _token.metadata[signature][classification][key];

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);
        require(oldMetadata.length > 0, UDSMessage.METADATA_NOT_SENT_TO_UPDATE);
        require(!(keccak256(oldMetadata) == keccak256(metadata) && oldMetadata.length == metadata.length), UDSMessage.SAME_METADATA_ALREADY_SENT);
    }

    function RunCleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key)
    private view {
        address sender = msg.sender;
        bytes32 signature = _interconnection.signature[sender];

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(signature != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(_token.metadata[signature][classification][key].length > 0, UDSMessage.METADATA_NOT_SENT_TO_DELETE);
    }
}