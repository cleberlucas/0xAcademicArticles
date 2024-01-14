// SPDX-License-Identifier: MIT

import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

library AcademicArticlesCommon {

    function IsExternalContractBinded(AcademicArticlesDataModel.ExternalContract storage externalContract, address externalContractAccount)
    internal view 
    returns (bool isExternalContractBinded) {
        
        for (uint256 i = 0; i < externalContract.accounts.length; i++) {

            if (externalContract.accounts[i] == externalContractAccount) {

                isExternalContractBinded = true;
                
                break;
            }
        }
    }
}