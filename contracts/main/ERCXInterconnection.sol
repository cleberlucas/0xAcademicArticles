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
        string memory contractSignature = IERCXSignature(msg.sender).SIGNATURE();

        _interconnection.senders.push(sender); 
        _interconnection.sender[contractSignature] = sender;
        _interconnection.signature[sender] = contractSignature;

        emit ERCXLog.SenderSigned(sender);
    }
}