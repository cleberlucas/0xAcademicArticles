// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "./ModelLib.sol";

interface IWrite {
    function RegisterInstitutions(address[] memory institutionsAccount) external payable;
    function UnregisterInstitutions(address[] memory institutionsAccount) external payable;
    function LinkAffiliates(address[] memory affiliatesAccount) external payable;
    function UnlinkAffiliates(address[] memory affiliatesAccount) external payable;
    function ValidateArticles(bytes32[] memory articlesId) external payable;
    function InvalidateArticles(bytes32[] memory articlesd) external payable;
    function PublishArticles(ModelLib.Article[] memory articlesContent) external payable;
    function UnpublishArticles(bytes32[] memory articlesId) external payable;
}
