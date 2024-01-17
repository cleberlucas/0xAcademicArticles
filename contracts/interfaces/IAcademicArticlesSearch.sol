// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAcademicArticlesSearch {
    function ArticleTokens(address contractContract) external view returns (bytes32[] memory articleTokens);
    function ArticlePublisher(bytes32 articleToken) external view returns (address articlePublisher);
    function ArticleData(bytes32 articleToken) external view returns (bytes memory articleData);
}