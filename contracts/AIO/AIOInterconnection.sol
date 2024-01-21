// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/AIOLog.sol";
import "./interfaces/IAIOInterconnection.sol";
import "./interfaces/IAIOSignature.sol";
import "./AIOStorage.sol";
import "./AIORules.sol";

abstract contract AIOInterconnection is IAIOInterconnection, AIOStorage, AIORules {
    function Initialize()
    external payable  
    EntryNotSignedEmpty
    IsNotSenderSigned(_interconnection) 
    IsNotSignatureUsed(_interconnection) {
        address sender = msg.sender;
        string memory signature = IAIOSignature(sender).SIGNATURE();

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit AIOLog.SenderSigned(sender);
    }

    function TransferSignature(address newSender)
    external payable  
    OnlySenderSigned(_interconnection)
    EntryNewSenderDifferentMe(newSender)
    EntryNewSenderSameSignature(newSender) {
        address oldSender = msg.sender;

        for (uint256 i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                string memory signature = IAIOSignature(oldSender).SIGNATURE();

                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();

                _interconnection.signature[oldSender] = "";

                _interconnection.senders.push(newSender); 
                _interconnection.sender[signature] = newSender;
                _interconnection.signature[newSender] = signature;

                emit AIOLog.SignatureTransferred(newSender);
                return;
            }
        }
    }
}