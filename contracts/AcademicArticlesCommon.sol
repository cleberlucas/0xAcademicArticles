// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./AcademicArticlesDataModel.sol";

library AcademicArticlesCommon {
    
    function IsContractConnected(AcademicArticlesDataModel.Connected storage connected, address connectedContract)
    internal view
    returns (bool isContractConnected) {
        for (uint256 i = 0; i < connected.contracts.length; i++) {
            if (connected.contracts[i] == connectedContract) {
                isContractConnected = true;
                break;
            }
        }
    }
}