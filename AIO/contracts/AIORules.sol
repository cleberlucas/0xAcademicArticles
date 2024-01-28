// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOMessage.sol";
import "./libs/AIOStorageModel.sol";
import "./interfaces/IAIOSignature.sol";

abstract contract AIORules {
    modifier InitializeRule(AIOStorageModel.Interconnection storage _interconnection) {
        address sender = msg.sender;

        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);
        try IAIOSignature(sender).SIGNATURE() {
            require(IAIOSignature(sender).SIGNATURE() != bytes32(0), AIOMessage.SIGNATURE_EMPTY);
            require(_interconnection.signature[sender] == bytes32(0), AIOMessage.SENDER_ALREADY_SIGNED);
            require(_interconnection.sender[IAIOSignature(sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_USING_SIGNATURE);
        } catch {
            revert(AIOMessage.SENDER_NO_SIGNATURE);
        }
        _;
    }

    modifier TransferSignatureRule(AIOStorageModel.Interconnection storage _interconnection, address newSender) {
        address oldSender = msg.sender;

        require(oldSender.code.length > 0, AIOMessage.ONLY_CONTRACT);
        require(newSender.code.length > 0, AIOMessage.NEW_SENDER_NOT_CONTRACT);
        require(_interconnection.signature[oldSender] != bytes32(0), AIOMessage.ONLY_SIGNED_EXEC);
        require(newSender != oldSender, AIOMessage.NEW_SENDER_CANNOT_BE_YOU);
        try IAIOSignature(newSender).SIGNATURE() {
            require(IAIOSignature(oldSender).SIGNATURE() == IAIOSignature(newSender).SIGNATURE(), AIOMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        } catch {
            revert(AIOMessage.NEW_SENDER_NO_SIGNATURE);
        }
        _;
    }

    modifier SendMetadataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) {
        address sender = msg.sender;

        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), AIOMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);
        require(_token.metadata[_interconnection.signature[sender]][classification][key].length == 0, AIOMessage.METADATA_ALREADY_SENT);
        _;
    }

    modifier UpdateMetadataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes32 classification, bytes32 key, bytes calldata metadata) {
        address sender = msg.sender;

        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), AIOMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);
        require(_token.metadata[_interconnection.signature[sender]][classification][key].length > 0, AIOMessage.METADATA_NOT_SENT_TO_UPDATE);
        require(!(keccak256(_token.metadata[_interconnection.signature[sender]][classification][key]) == keccak256(metadata) &&
            _token.metadata[_interconnection.signature[sender]][classification][key].length == metadata.length), AIOMessage.SAME_METADATA_ALREADY_SENT);
        _;
    }

    modifier CleanMetadataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes32 classification, bytes32 key) {
        address sender = msg.sender;

        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);
        require(_interconnection.signature[sender] != bytes32(0), AIOMessage.ONLY_SIGNED_EXEC);
        require(_token.metadata[_interconnection.signature[sender]][classification][key].length > 0, AIOMessage.METADATA_NOT_SENT_TO_DELETE);
        _;
    }
}