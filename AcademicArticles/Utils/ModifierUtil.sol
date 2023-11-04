// SPDX-License-Identifier: AFL-3.0
import "../Extensions/RepositoryExtension.sol";
import "../Librarys/ErrorMessageLibrary.sol";

pragma solidity >=0.8.19;

abstract contract ModifierUtil is RepositoryExtension {

    function Require(bool condition, string memory messageOnError) 
    internal pure {
        require(condition, messageOnError);
    }

    function HashIdentifiers(DelimitationLibrary.Article[] memory contents)
    internal pure 
    returns (bytes32[] memory hashIdentifiers) {
        hashIdentifiers = new bytes32[](contents.length);

        for(uint256 i = 0; i < contents.length; i++)
            hashIdentifiers[i] = keccak256(abi.encode(contents[i]));
    }

    function Int256(uint256 value)
    internal pure 
    returns (int256){
        return int256(value);
    }
    
}
