// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >= 0.8.22;

abstract contract ViewHandler is RepositoryExtension {
    function ArticlesKey()
        public
        view
        returns (RepositoryLibrary.ArticleKey[] memory articlesKey)
    {
        return _key.articles;
    }

    function ArticlesKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (RepositoryLibrary.ArticleKey[] memory articlesKey) {
        RepositoryLibrary.ArticleKey[]
            memory result = new RepositoryLibrary.ArticleKey[](
                startIndex - endIndex + 1
            );

        for (uint256 i = 0; i < _key.articles.length; i++) {
            result[i] = _key.articles[endIndex + i];
        }

        return result;
    }

    function InstitutionsKey()
        public
        view
        returns (address[] memory institutionsKey)
    {
        return _key.institutions;
    }

    function InstitutionsKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (address[] memory institutionsKey) {
        address[] memory result = new address[](startIndex - endIndex + 1);

        for (uint256 i = 0; i < _key.institutions.length; i++) {
            result[i] = _key.institutions[endIndex + i];
        }

        return result;
    }

    function AuthenticatorsKey()
        public
        view
        returns (address[] memory authenticatorsKey)
    {
        return _key.authenticators;
    }

    function AuthenticatorsKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (address[] memory authenticatorsKey) {
        address[] memory result = new address[](startIndex - endIndex + 1);

        for (uint256 i = 0; i < _key.authenticators.length; i++) {
            result[i] = _key.authenticators[endIndex + i];
        }

        return result;
    }

    function Article(
        RepositoryLibrary.ArticleKey[] memory articlesKey
    ) public view returns (DelimitationLibrary.Article[] memory articles) {
        DelimitationLibrary.Article[]
            memory result = new DelimitationLibrary.Article[](
                articlesKey.length
            );

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _data.articles[articlesKey[i].poster][
                articlesKey[i].articleType
            ][articlesKey[i].sequenceArticleType];
        }

        return result;
    }

    function Institutions(
        address[] memory institutionsKey
    )
        public
        view
        returns (DelimitationLibrary.Institution[] memory institutions)
    {
        DelimitationLibrary.Institution[]
            memory result = new DelimitationLibrary.Institution[](
                institutionsKey.length
            );

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _data.institutions[institutionsKey[i]];
        }
        return result;
    }

    function BindingIntitutionAuthenticators(
        address[] memory authenticatorsKey
    ) public view returns (address[] memory institutionsKey) {
        address[] memory result = new address[](authenticatorsKey.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _data.bindingIntitutionAuthenticators[authenticatorsKey[i]];
        }
        return result;
    }

    function InstitutionAuthenticatedArticles(
        RepositoryLibrary.ArticleKey[] memory articlesKey
    ) public view returns (address[] memory authenticatorsKeys) {
        address[] memory result = new address[](articlesKey.length);

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _data.institutionAuthenticatedArticles[articlesKey[i].poster][
                articlesKey[i].articleType
            ][articlesKey[i].sequenceArticleType];
        }

        return result;
    }
}
