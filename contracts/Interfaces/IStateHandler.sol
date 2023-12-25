// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import "../Librarys/DelimitationLibrary.sol";

interface IStateHandler {
    function RegisterInstitution(address[] memory institutionAccounts) external payable;
    function UnregisterInstitution(address[] memory institutionAccounts) external payable;
    function BindAuthenticator(address[] memory authenticatorAccounts) external payable;
    function UnbindAuthenticator(address[] memory authenticatorAccounts) external payable;
    function AuthenticateArticle(bytes32[] memory articleIds) external payable;
    function UnauthenticateArticle(bytes32[] memory articleIds) external payable;
    function PostArticle(DelimitationLibrary.Article[] memory articleContents) external payable;
    function RemoveArticle(bytes32[] memory articleIds) external payable;
}
