// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOMessage.sol";
import "./libs/AIOStorageModel.sol";
import "./interfaces/IAIOSignature.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract AIORules {
    modifier InitializeRule(AIOStorageModel.Interconnection storage _interconnection) {
        address sender = msg.sender;

        require(sender != tx.origin, AIOMessage.NOT_EXEC_DIRECT_AIO);
        try IAIOSignature(sender).SIGNATURE() {
            require(bytes(IAIOSignature(sender).SIGNATURE()).length > 0, AIOMessage.SIGNATURE_EMPTY);
            require(bytes(_interconnection.signature[sender]).length == 0, AIOMessage.SENDER_ALREADY_SIGNED);
            require(_interconnection.sender[IAIOSignature(sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_USING_SIGNATURE);
        }   catch {
                revert(AIOMessage.SENDER_NO_SIGNATURE);
        } 
        _;
    }

    modifier TransferSignatureRule(AIOStorageModel.Interconnection storage _interconnection, address newSender) {
        address oldSender = msg.sender;

        require(oldSender != tx.origin, AIOMessage.NOT_EXEC_DIRECT_AIO);
        require(bytes(_interconnection.signature[oldSender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(newSender != oldSender, AIOMessage.NEW_SENDER_CANNOT_BE_YOU); 
        try IAIOSignature(newSender).SIGNATURE() {
            require(Strings.equal(IAIOSignature(oldSender).SIGNATURE(), IAIOSignature(newSender).SIGNATURE()), AIOMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        }   catch {
                revert(AIOMessage.NEW_SENDER_NO_SIGNATURE);
        }    
        _;
    }

    modifier SendMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Data storage _data, bytes calldata metadata) {
        address sender = msg.sender;

        require(address(this) != sender, AIOMessage.NOT_EXEC_DIRECT_AIO);
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);
        require(bytes(_data.signature[keccak256(metadata)]).length == 0, AIOMessage.METADATA_ALREADY_SENT);
        _;
    }

    modifier CleanMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Data storage _data, bytes32 token) {
        address sender = msg.sender;
        
        require(address(this) != sender, AIOMessage.NOT_EXEC_DIRECT_AIO);
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(bytes(_data.signature[token]).length > 0, AIOMessage.METADATA_NOT_SENT);
        require(Strings.equal((_data.signature[token]), _interconnection.signature[sender]), AIOMessage.METADATA_NOT_SENT_BY_YOU);
        _;
    }
}