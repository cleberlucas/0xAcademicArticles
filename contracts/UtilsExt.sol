// SPDX-License-Identifier: MIT

import "./DataExt.sol";

pragma solidity ^0.8.23;

abstract contract UtilsExt is DataExt {

    function Keccak256ArticlesContent(ModelLib.Article[] memory articlesContent)
    internal pure 
    returns (bytes32[] memory result) {

        result = new bytes32[](articlesContent.length);

        for(uint256 i = 0; i < articlesContent.length; i++) {
            result[i] = keccak256(abi.encode(articlesContent[i]));
        }
    }

    function InstitutionOfAffiliation(address affiliationAccount)
    internal view 
    returns (address result) {

         for (uint256 i = 0; i < _institution.accounts.length; i++) {
            for (uint256 ii = 0; ii < _institution.affiliations[_institution.accounts[i]].length; ii++) {
                if (_institution.affiliations[_institution.accounts[i]][ii] == affiliationAccount) {
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
}
