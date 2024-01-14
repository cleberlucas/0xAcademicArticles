// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

interface IAcademicArticlesInteract {
    
    function PublishArticle(bytes calldata articleEncode) external payable;
    function UnpublishArticle(bytes32 articleToken) external payable;
    function BindContract(address contractAccount) external payable;
    function UnbindContract(address contractAccount) external payable;
}