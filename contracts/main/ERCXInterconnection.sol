// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ERCXLog.sol";
import "./interfaces/IERCXInterconnection.sol";
import "./interfaces/IERCXSignature.sol";
import "./ERCXStorage.sol";
import "./ERCXRules.sol";

abstract contract ERCXInterconnection is IERCXInterconnection, ERCXStorage, ERCXRules {
    function Initialize()
    external payable  
    IsNotSignedEmpty
    IsNotSenderSigned(_interconnection) 
    IsNotSignatureUsed(_interconnection) {
        address sender = msg.sender;
        string memory signature = IERCXSignature(sender).SIGNATURE();

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit ERCXLog.SenderSigned(sender);
    }

    function TransferSignature(address newSender)
    external payable  
    OnlySenderSigned(_interconnection) {
        address oldSender = msg.sender;

        for (uint256 i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                string memory signature = IERCXSignature(oldSender).SIGNATURE();

                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();

                _interconnection.signature[oldSender] = "";

                _interconnection.senders.push(newSender); 
                _interconnection.sender[signature] = newSender;
                _interconnection.signature[newSender] = signature;

                emit ERCXLog.SignatureTransferred(newSender);
                return;
            }
        }
    }
}