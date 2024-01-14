// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library AcademicArticlesCommon {

    function IsContractBinded(address[] storage externalContracts, address contractAccount)
    internal view 
    returns (bool isContract) {
        
        for (uint256 i = 0; i < externalContracts.length; i++) {

            if (externalContracts[i] == contractAccount) {

                isContract = true;
                
                break;
            }
        }
    }
}