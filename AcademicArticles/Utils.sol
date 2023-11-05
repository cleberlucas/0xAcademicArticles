// SPDX-License-Identifier: AFL-3.0
import "./Extensions/RepositoryExtension.sol";
import "./Librarys/ErrorMessageLibrary.sol";

pragma solidity >=0.8.19;

abstract contract Utils is RepositoryExtension {

    function Require(bool condition, string memory messageOnError) 
    internal pure {
        require(condition, messageOnError);
    }

    function ContentsToHashIdentifiers(DelimitationLibrary.Article[] memory contents)
    internal pure 
    returns (bytes32[] memory hashIdentifiers) {
        hashIdentifiers = new bytes32[](contents.length);

        for(uint256 i = 0; i < contents.length; i++)
            hashIdentifiers[i] = keccak256(abi.encode(contents[i]));
    }

    function SearchInstitutionOfAuthenticator(address account)
    internal view 
    returns (address institution){
         for (uint256 i = 0; i < _institution.accounts.length; i++) 
            for (uint256 ii = 0; ii < _institution.authenticators[_institution.accounts[i]].length; ii++)
                if (_institution.authenticators[_institution.accounts[i]][ii] == account) return _institution.accounts[i];
    }

    function ExistInstitution(address account)
    internal view 
    returns (bool exist){
        for (uint256 i = 0; i < _institution.accounts.length; i++) 
            if (_institution.accounts[i] == account) return  true;
    }

   
    
}
