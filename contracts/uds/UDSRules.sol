// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/UDSMessage.sol";
import "./libs/UDSStorageModel.sol";
import "./interfaces/IUDSSignature.sol";

abstract contract UDSRules {
    modifier InitializeRule(UDSStorageModel.Interconnection storage _interconnection) {
        address newSender = msg.sender;

        require(newSender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        try IUDSSignature(newSender).SIGNATURE() {
            bytes32 newSignature = IUDSSignature(newSender).SIGNATURE();

            require(newSignature != bytes32(0), UDSMessage.SIGNATURE_EMPTY);
            require(_interconnection.signature[newSender] == bytes32(0), UDSMessage.SENDER_ALREADY_SIGNED);
            require(_interconnection.sender[newSignature] == address(0), UDSMessage.OTHER_SENDER_USING_SIGNATURE);
        } catch {
            revert(UDSMessage.SENDER_NO_SIGNATURE);
        }
        _;
    }

    modifier TransferSignatureRule(UDSStorageModel.Interconnection storage _interconnection, address newSender) {
        address sender = msg.sender;

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(newSender.code.length > 0, UDSMessage.NEW_SENDER_NOT_CONTRACT);
        require(newSender != sender, UDSMessage.NEW_SENDER_CANNOT_BE_YOU);
        try IUDSSignature(newSender).SIGNATURE() {
            require(_interconnection.signature[sender] == IUDSSignature(newSender).SIGNATURE(), UDSMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        } catch {
            revert(UDSMessage.NEW_SENDER_NO_SIGNATURE);
        }
        _;
    }

    modifier SendMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) {
        address sender = msg.sender;

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);
        require(_token.metadata[_interconnection.signature[sender]][classification][key].length == 0, UDSMessage.METADATA_ALREADY_SENT);
        _;
    }

    modifier UpdateMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) {
        address sender = msg.sender;

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, UDSMessage.METADATA_EMPTY);
        require(_token.metadata[_interconnection.signature[sender]][classification][key].length > 0, UDSMessage.METADATA_NOT_SENT_TO_UPDATE);
        require(!(keccak256(_token.metadata[_interconnection.signature[sender]][classification][key]) == keccak256(metadata) &&
            _token.metadata[_interconnection.signature[sender]][classification][key].length == metadata.length), UDSMessage.SAME_METADATA_ALREADY_SENT);
        _;
    }

    modifier CleanMetadataRule(UDSStorageModel.Interconnection storage _interconnection, UDSStorageModel.Token storage _token, bytes32 classification, bytes32 key) {
        address sender = msg.sender;

        require(sender.code.length > 0, UDSMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), UDSMessage.ONLY_SIGNED_EXEC);
        require(_token.metadata[_interconnection.signature[sender]][classification][key].length > 0, UDSMessage.METADATA_NOT_SENT_TO_DELETE);
        _;
    }
}