// SPDX-License-Identifier: MIT

import "./AcademicArticlesData.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesCommon is AcademicArticlesData {
    function IsContractBinded_(address contractAccount)
    internal view 
    returns (bool isContract) {
        
        for (uint256 i = 0; i < _external.contracts.length; i++) {
            if (_external.contracts[i] == contractAccount) {
                isContract = true;
                break;
            }
        }
    }
}