// SPDX-License-Identifier: AFL-3.0

import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/DepositingLibrary.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.18;

abstract contract ViewHandler is DepositingGlobal {
    function ArticlesKey()
        public
        view
        returns (DepositingLibrary.ArticleKey[] memory articlesKey)
    {
        return _key.articles;
    }

    function ArticlesKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (DepositingLibrary.ArticleKey[] memory articlesKey) {
        DepositingLibrary.ArticleKey[]
            memory result = new DepositingLibrary.ArticleKey[](
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
        DepositingLibrary.ArticleKey[] memory articlesKey
    ) public view returns (DelimitationLibrary.Article[] memory article) {
        DelimitationLibrary.Article[]
            memory result = new DelimitationLibrary.Article[](
                articlesKey.length
            );

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _articles[articlesKey[i].poster][
                articlesKey[i].articleType
            ][articlesKey[i].sequence];
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
            result[i] = _institutions[institutionsKey[i]];
        }
        return result;
    }

    function Authenticators(
        address[] memory authenticatorsKey
    )
        public
        view
        returns (address[] memory institutions)
    {
        address[]
            memory result = new address[](
                authenticatorsKey.length
            );

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = _authenticators[authenticatorsKey[i]];
        }
        return result;
    }
}
