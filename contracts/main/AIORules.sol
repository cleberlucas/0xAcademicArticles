// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOMessage.sol";
import "./libs/AIOStorageModel.sol";
import "./interfaces/IAIOSignature.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract AIORules {
    modifier OnlySenderSigned(AIOStorageModel.Interconnection storage _interconnection) {
        require(bytes(_interconnection.signature[msg.sender]).length > 0, AIOMessage.SENDER_IS_NOT_SIGNED);
        _;
    }

    modifier EntryNotMetadataEmpty(bytes calldata metadata) {      
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);
        _;
    }

    modifier EntryNotSignedEmpty() {      
        require(bytes(IAIOSignature(msg.sender).SIGNATURE()).length > 0, AIOMessage.SIGNATURE_EMPTY);
        _;
    }

    modifier EntryNewSenderSameSignature(address newSender) {
        require(Strings.equal(IAIOSignature(msg.sender).SIGNATURE(), IAIOSignature(newSender).SIGNATURE()), AIOMessage.NEW_SENDER_NOT_HAVE_SAME_SIGNATURE_AS_YOU);
        _;
    }

    modifier IsNotSenderSigned(AIOStorageModel.Interconnection storage _interconnection) {
        require(bytes(_interconnection.signature[msg.sender]).length == 0, AIOMessage.SENDER_ALREADY_SIGNED);
        _;
    }

    modifier IsNotSignatureUsed(AIOStorageModel.Interconnection storage _interconnection) { 
        require(_interconnection.sender[IAIOSignature(msg.sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_IS_USING_THIS_SIGNATURE);
        _;
    }

    modifier IsNotMetadataSended(AIOStorageModel.Data storage _data, bytes32 token) { 
        require(bytes(_data.signature[token]).length == 0, AIOMessage.METADATA_IS_ALREADY_SENDED);
        _;
    }

    modifier IsMetadataSended(AIOStorageModel.Data storage _data, bytes32 token) {
        require(bytes(_data.signature[token]).length > 0, AIOMessage.METADATA_IS_NOT_SENDED);
        _;
    }

    modifier IsMetadataSendedBySender(AIOStorageModel.Data storage _data, AIOStorageModel.Interconnection storage _interconnection, bytes32 token) {
        require(Strings.equal((_data.signature[token]), _interconnection.signature[msg.sender]), AIOMessage.METADATA_IS_NOT_SENDED_BY_YOU);
        _;
    }
}