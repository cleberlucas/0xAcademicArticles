// SPDX-License-Identifier: AFL-3.0

import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >=0.8.18;

abstract contract DepositingShared {
    constructor() {
        OWNER = msg.sender;
    }

    address immutable OWNER;
    RepositoryLibrary.Key keyShared;
    mapping(address authenticator => address institution) authenticatorInstitutionShared;
    mapping(address institution => DelimitationLibrary.Institution) institutionProfileShared;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => uint256 sequence)) sequenceShared;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => mapping(uint256 sequence => DelimitationLibrary.Article))) articleShared;
}
