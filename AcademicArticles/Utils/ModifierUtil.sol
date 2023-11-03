// SPDX-License-Identifier: AFL-3.0
import "../Extensions/RepositoryExtension.sol";
import "../Librarys/ErrorMessageLibrary.sol";

pragma solidity >=0.8.19;

abstract contract ModifierUtil is RepositoryExtension {
    function Require(
        bool _require,
        string memory messageOnError,
        bool indexError,
        uint256 index
    ) internal pure {
        require(_require, indexError? messageOnError : string.concat(messageOnError, ErrorMessageLibrary.ERROR_ON_INDEX, string(abi.encode(index))));
    }

    function HashIdentifiers(DelimitationLibrary.Article[] memory content
    ) internal pure returns (bytes32[] memory hashIdentifiers){
        hashIdentifiers = new bytes32[](content.length);

        for(uint256 i = 0; i < hashIdentifiers.length; i++)
            hashIdentifiers[i] = keccak256(abi.encode(content));
    }
}
