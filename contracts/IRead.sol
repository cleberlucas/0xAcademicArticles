// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "./DelimitationLib.sol";

interface IRead{
    function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) external view returns (bytes32[] memory result, uint256 size);
    function ArticlePoster(bytes32[] memory articleIds) external view returns (address[] memory result);
    function ArticleInstitution(bytes32[] memory articleIds) external view returns (address[] memory result);
    function ArticleContent(bytes32[] memory articleIds) external view returns (DelimitationLib.Article[] memory result);
    function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse) external view returns (address[] memory result, uint256 size);
    function InstitutionAuthenticators(address[] memory institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) external view returns (address[][] memory result, uint256[] memory size);
}
