// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ACARLog.sol";
import "./interfaces/IACARConnection.sol";
import "./interfaces/IACARSignature.sol";
import "./ACARStorage.sol";
import "./ACARRules.sol";

abstract contract ACARConnection is IACARConnection, ACARStorage, ACARRules {
    function Initialize()
    public payable  
    IsContractSigned
    IsNotContractConnected(_contract) 
    IsNotContractSignatureUsed(_contract) {
        address contractAccount = msg.sender;
        string memory contractSignature = IACARSignature(msg.sender).SIGNATURE();

        _contract.accounts.push(contractAccount); 
        _contract.account[contractSignature] = contractAccount;
        _contract.signature[contractAccount] = contractSignature;

        emit ACARLog.ContractConnected(contractAccount);
    }
}