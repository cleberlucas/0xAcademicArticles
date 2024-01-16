// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./AcademicArticlesDataModel.sol";

library AcademicArticlesCommon {
    function IsContractConnected(AcademicArticlesDataModel.Interconnection storage Interconnection, address interconnectionContract)
    internal view
    returns (bool isContractConnected) {
        for (uint256 i = 0; i < Interconnection.contracts.length; i++) {
            if (Interconnection.contracts[i] == interconnectionContract) {
                isContractConnected = true;
                break;
            }
        }
    }
}