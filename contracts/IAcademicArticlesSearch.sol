// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

interface IAcademicArticlesSearch {
    
    function ArticleTokens() external view returns (bytes32[] memory articleTokens);
    function ArticlePublisher(bytes32 articleToken) external view returns (address articlePublisher);
    function ArticleEncode(bytes32 articleToken, address contractAccount) external view returns (bytes memory articleEncode);
    function ExternalContracts() external view returns (address[] memory externalContracts);    
}