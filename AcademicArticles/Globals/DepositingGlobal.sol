// SPDX-License-Identifier: AFL-3.0

import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/DepositingLibrary.sol";

pragma solidity >=0.8.18;

abstract contract DepositingGlobal {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;
    DepositingLibrary.Key _key;
    mapping(address authenticator => address institution) internal _bindedAuthenticators;
    mapping(address institution => DelimitationLibrary.Institution) internal _institutions;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => uint256 sequence)) internal _sequenceArticleTypes;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => mapping(uint256 sequence => DelimitationLibrary.Article))) internal _articles;
    mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => mapping(uint256 sequence => address authenticator))) internal _authenticatedArticles;
}
