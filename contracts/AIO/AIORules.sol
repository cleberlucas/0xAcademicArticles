// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOMessage.sol";
import "./libs/AIOStorageModel.sol";
import "./interfaces/IAIOSignature.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract AIORules  {
    modifier InitializeRule(AIOStorageModel.Interconnection storage _interconnection) {
        require(address(this) != msg.sender, AIOMessage.AIO_NOT_EXEC);
        require(bytes(IAIOSignature(msg.sender).SIGNATURE()).length > 0, AIOMessage.SIGNATURE_EMPTY);
        require(bytes(_interconnection.signature[msg.sender]).length == 0, AIOMessage.SENDER_ALREADY_SIGNED);
        require(_interconnection.sender[IAIOSignature(msg.sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_USING_SIGNATURE);
        _;
    }

    modifier TransferSignatureRule(AIOStorageModel.Interconnection storage _interconnection, address newSender) {
        require(address(this) != msg.sender, AIOMessage.AIO_NOT_EXEC);
        require(bytes(_interconnection.signature[msg.sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(newSender != msg.sender, AIOMessage.NEW_SENDER_CANNOT_BE_YOU);
        require(Strings.equal(IAIOSignature(msg.sender).SIGNATURE(), IAIOSignature(newSender).SIGNATURE()), AIOMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        _;
    }

    modifier SendMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Data storage _data, bytes calldata metadata) {
        require(address(this) != msg.sender, AIOMessage.AIO_NOT_EXEC);
        require(bytes(_interconnection.signature[msg.sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);
        require(bytes(_data.signature[keccak256(metadata)]).length == 0, AIOMessage.METADATA_ALREADY_SENT);
        _;
    }

    modifier CleanMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Data storage _data, bytes32 token) {
        require(address(this) != msg.sender, AIOMessage.AIO_NOT_EXEC);
        require(bytes(_interconnection.signature[msg.sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(bytes(_data.signature[token]).length > 0, AIOMessage.METADATA_NOT_SENT);
        require(Strings.equal((_data.signature[token]), _interconnection.signature[msg.sender]), AIOMessage.METADATA_NOT_SENT_BY_YOU);
        _;
    }
}