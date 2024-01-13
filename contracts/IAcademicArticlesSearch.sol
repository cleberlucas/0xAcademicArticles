// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

interface IAcademicArticlesSearch {
    function ArticleTokens(uint256 startIndex, uint256 endIndex) external view returns (bytes32[] memory result, uint256 currentSize);
    function ArticlePoster(bytes32[] memory articlesToken) external view returns (address[] memory result);
    function ArticleInstitutionStamp(bytes32[] memory articlesToken) external view returns (address[] memory result);
    function InstitutionAccounts(uint256 startIndex, uint256 endIndex) external view returns (address[] memory result, uint256 currentSize);
    function InstitutionAffiliates(address institutionAccount, uint256 startIndex, uint256 endIndex) external view returns (address[] memory result, uint256 currentSize);
    function ExternalContracts(uint256 startIndex, uint256 endIndex) external view returns (address[] memory result, uint256 currentSize);    
}