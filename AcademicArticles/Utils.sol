// SPDX-License-Identifier: MIT
import "./Extensions/RepositoryExtension.sol";
import "./Librarys/ErrorMessageLibrary.sol";

pragma solidity >=0.8.19;

abstract contract Utils is RepositoryExtension {

    function Require(bool condition, string memory messageOnError) 
    internal pure {
        require(condition, messageOnError);
    }

    function ArticleContentsToKeccak256(DelimitationLibrary.Article[] memory articleContents)
    internal pure 
    returns (bytes32[] memory articleIds) {
        articleIds = new bytes32[](articleContents.length);

        for(uint256 i = 0; i < articleContents.length; i++)
            articleIds[i] = keccak256(abi.encode(articleContents[i]));
    }

    function SearchInstitutionOfAuthenticator(address authenticatorAccount)
    internal view 
    returns (address institutionAccount){
         for (uint256 i = 0; i < _institution.accounts.length; i++) 
            for (uint256 ii = 0; ii < _institution.authenticators[_institution.accounts[i]].length; ii++)
                if (_institution.authenticators[_institution.accounts[i]][ii] == authenticatorAccount) return _institution.accounts[i];
    }

    function ExistInstitution(address institutionAccount)
    internal view 
    returns (bool exist){
        for (uint256 i = 0; i < _institution.accounts.length; i++) 
            if (_institution.accounts[i] == institutionAccount) return true;
    }

   
    
}
