// SPDX-License-Identifier: MIT

import "./AcademicArticlesDataModel.sol";

pragma solidity ^0.8.23;

interface IAcademicArticlesSearch {

    function ArticleTokens(address externalContractAccount) external view returns (bytes32[] memory articleTokens);
    function ArticlePublisher(bytes32 articleToken) external view returns (address articlePublisher);
    function ArticleEncode(bytes32 articleToken) external view returns (bytes memory articleEncode);
    function ExternalContract() external view returns (AcademicArticlesDataModel.ExternalContract memory externalContract);  
}
