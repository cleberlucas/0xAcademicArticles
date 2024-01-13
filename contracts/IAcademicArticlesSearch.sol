// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

interface IAcademicArticlesSearch {
    function ArticleTokens() external view returns (bytes32[] memory articleTokens);
    function ArticlePublisher(bytes32 articleToken) external view returns (address articlePublisher);
    function ArticleAbi(bytes32 articleToken, address contractAccount) external view returns (string memory articleAbi);
    function ExternalContracts() external view returns (address[] memory externalContracts);    
}