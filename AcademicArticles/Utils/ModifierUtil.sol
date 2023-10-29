// SPDX-License-Identifier: AFL-3.0
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.19;

abstract contract ModifierUtil is RepositoryExtension {
    function Require(
        bool _require,
        string memory messageOnError
    ) internal pure {
        require(_require, messageOnError);
    }
}
