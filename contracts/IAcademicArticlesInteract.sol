// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

interface IAcademicArticlesInteract {

    function PublishArticle(bytes calldata articleEncode) external payable;
    function UnpublishArticle(bytes32 articleToken) external payable;
    function BindExternalContract(address externalContractAccount) external payable;
    function EnableExternalContract(address externalContractAccount) external payable;
    function DisableExternalContract(address externalContractAccount) external payable;
}