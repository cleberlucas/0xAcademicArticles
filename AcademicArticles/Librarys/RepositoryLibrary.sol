// SPDX-License-Identifier: AFL-3.0
import "./DelimitationLibrary.sol";

pragma solidity >=0.8.22;

library RepositoryLibrary {
    struct Data {
        mapping(address authenticator => address institution) bindingIntitutionAuthenticators;
        mapping(address institution => DelimitationLibrary.Institution) institutions;
        mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => uint256 sequence)) sequenceArticleTypes;
        mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => mapping(uint256 sequence => DelimitationLibrary.Article))) articles;
        mapping(address poster => mapping(DelimitationLibrary.ArticleType articleType => mapping(uint256 sequence => address institution))) institutionAuthenticatedArticles;
    }

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
