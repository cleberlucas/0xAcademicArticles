// SPDX-License-Identifier: MIT

import "./AcademicArticlesData.sol";

pragma solidity ^0.8.23;

abstract contract AcademicArticlesUtils is AcademicArticlesData{
    function InstitutionOfAffiliate(address affiliateAccount)
    internal view 
    returns (address result) {
         for (uint256 i = 0; i < _institution.accounts.length; i++) {
            for (uint256 ii = 0; ii < _institution.affiliates[_institution.accounts[i]].length; ii++) {
                if (_institution.affiliates[_institution.accounts[i]][ii] == affiliateAccount) {
                    return _institution.accounts[i];
                }
            }
         }
    }

    function IsInstitution_(address institutionAccount)
    internal view 
    returns (bool result) {
        for (uint256 i = 0; i < _institution.accounts.length; i++) {
            if (_institution.accounts[i] == institutionAccount) {
                return true;
            }
        }
    }

    function IsContract_(address contractAccount)
    internal view 
    returns (bool result) {
        for (uint256 i = 0; i < _external.contracts.length; i++) {
            if (_external.contracts[i] == contractAccount) {
                return true;
            }
        }
    }
}