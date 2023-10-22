// SPDX-License-Identifier: AFL-3.0

import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";
import "../Shareds/DepositingShared.sol";

pragma solidity >=0.8.18;

contract ViewHandler is DepositingShared {

    function Key() public view returns (RepositoryLibrary.Key memory key) {
        return keyShared;
    }

    function ArticlesKey()
        public
        view
        returns (RepositoryLibrary.ArticleKey[] memory articlesKey)
    {
        return keyShared.articles;
    }

    function ArticlesKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (RepositoryLibrary.ArticleKey[] memory articlesKey) {
        RepositoryLibrary.ArticleKey[]
            memory result = new RepositoryLibrary.ArticleKey[](
                startIndex - endIndex + 1
            );

        for (uint256 i = 0; i < keyShared.articles.length; i++) {
            result[i] = keyShared.articles[endIndex + i];
        }

        return result;
    }

    function InstitutionsKey()
        public
        view
        returns (address[] memory institutionsKey)
    {
        return keyShared.institutions;
    }

    function InstitutionsKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (address[] memory institutionsKey) {
        address[] memory result = new address[](startIndex - endIndex + 1);

        for (uint256 i = 0; i < keyShared.institutions.length; i++) {
            result[i] = keyShared.institutions[endIndex + i];
        }

        return result;
    }

    function AuthenticatorsKey()
        public
        view
        returns (address[] memory authenticatorsKey)
    {
        return keyShared.authenticators;
    }

    function AuthenticatorsKey(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (address[] memory authenticatorsKey) {
        address[] memory result = new address[](startIndex - endIndex + 1);

        for (uint256 i = 0; i < keyShared.authenticators.length; i++) {
            result[i] = keyShared.authenticators[endIndex + i];
        }

        return result;
    }

    function Article(
        RepositoryLibrary.ArticleKey[] memory articlesKey
    ) public view returns (DelimitationLibrary.Article[] memory article) {
        DelimitationLibrary.Article[]
            memory result = new DelimitationLibrary.Article[](
                articlesKey.length
            );

        for (uint256 i = 0; i < result.length; i++) {
            result[i] = articleShared[articlesKey[i].poster][
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
            result[i] = institutionProfileShared[institutionsKey[i]];
        }
        return result;
    }
}
