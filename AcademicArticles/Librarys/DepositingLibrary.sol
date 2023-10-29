// SPDX-License-Identifier: AFL-3.0
import "./DelimitationLibrary.sol";

pragma solidity >= 0.8.22;

library DepositingLibrary {
    struct Key {
        ArticleKey[] articles;
        address[] institutions;
        address[] authenticators;
    }

    struct ArticleKey {
        address poster;
        DelimitationLibrary.ArticleType articleType;
        uint256 sequenceArticleType;
    }
}
