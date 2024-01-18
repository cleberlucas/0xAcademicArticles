// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IACARInteract {
    function PublishArticle(bytes calldata articleData) external payable;
    function UnpublishArticle(bytes32 articleToken) external payable;
}