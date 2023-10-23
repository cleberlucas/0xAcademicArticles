// SPDX-License-Identifier: AFL-3.0

import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/DepositingLibrary.sol";

pragma solidity >=0.8.18;

abstract contract DepositingGlobal {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;
    DepositingLibrary.Key keyShared;
    mapping(address authenticator => address institution) internal authenticatorInstitutionShared;
    mapping(address institution => DelimitationLibrary.Institution) internal institutionProfileShared;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => uint256 sequence)) internal sequenceShared;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => mapping(uint256 sequence => DelimitationLibrary.Article))) internal articleShared;
}
