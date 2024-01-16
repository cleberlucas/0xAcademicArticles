// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./AcademicArticlesDataModel.sol";

interface IAcademicArticlesSearch {
    
    function ArticleTokens(address connectedContract) external view returns (bytes32[] memory articleTokens);
    function ArticlePublisher(bytes32 articleToken) external view returns (address articlePublisher);
    function ArticleEncoded(bytes32 articleToken) external view returns (bytes memory articleEncoded);
    function Connected() external view returns (AcademicArticlesDataModel.Connected memory connected);
}