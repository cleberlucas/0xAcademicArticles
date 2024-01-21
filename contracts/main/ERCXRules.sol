// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ERCXMessage.sol";
import "./libs/ERCXStorageModel.sol";
import "./interfaces/IERCXSignature.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract ERCXRules {
    modifier OnlySenderSigned(ERCXStorageModel.Interconnection storage _interconnection) {
        require(bytes(_interconnection.signature[msg.sender]).length > 0, ERCXMessage.SENDER_IS_NOT_SIGNED);
        _;
    }

    modifier EntryNotMetadataEmpty(bytes calldata metadata) {      
        require(metadata.length > 0, ERCXMessage.METADATA_EMPTY);
        _;
    }

    modifier EntryNotSignedEmpty() {      
        require(bytes(IERCXSignature(msg.sender).SIGNATURE()).length > 0, ERCXMessage.SIGNATURE_EMPTY);
        _;
    }

    modifier EntryNewSenderSameSignature(address newSender) {
        require(Strings.equal(IERCXSignature(msg.sender).SIGNATURE(), IERCXSignature(newSender).SIGNATURE()), ERCXMessage.NEW_SENDER_NOT_HAVE_SAME_SIGNATURE_AS_YOU);
        _;
    }

    modifier IsNotSenderSigned(ERCXStorageModel.Interconnection storage _interconnection) {
        require(bytes(_interconnection.signature[msg.sender]).length == 0, ERCXMessage.SENDER_ALREADY_SIGNED);
        _;
    }

    modifier IsNotSignatureUsed(ERCXStorageModel.Interconnection storage _interconnection) { 
        require(_interconnection.sender[IERCXSignature(msg.sender).SIGNATURE()] == address(0), ERCXMessage.OTHER_SENDER_IS_USING_THIS_SIGNATURE);
        _;
    }

    modifier IsNotMetadataSended(ERCXStorageModel.Data storage _data, bytes32 token) { 
        require(bytes(_data.signature[token]).length == 0, ERCXMessage.METADATA_IS_ALREADY_SENDED);
        _;
    }

    modifier IsMetadataSended(ERCXStorageModel.Data storage _data, bytes32 token) {
        require(bytes(_data.signature[token]).length > 0, ERCXMessage.METADATA_IS_NOT_SENDED);
        _;
    }

    modifier IsMetadataSendedBySender(ERCXStorageModel.Data storage _data, ERCXStorageModel.Interconnection storage _interconnection, bytes32 token) {
        require(Strings.equal((_data.signature[token]), _interconnection.signature[msg.sender]), ERCXMessage.METADATA_IS_NOT_SENDED_BY_YOU);
        _;
    }
}