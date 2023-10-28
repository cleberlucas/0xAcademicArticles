// SPDX-License-Identifier: AFL-3.0
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.19;

abstract contract ModifierUtil is DepositingGlobal {
    function Require(
        bool _require,
        string memory messageOnError
    ) internal pure {
        require(_require, messageOnError);
    }
}
