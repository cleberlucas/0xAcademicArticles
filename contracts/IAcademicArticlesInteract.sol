// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAcademicArticlesInteract {
    
    function PublishArticle(bytes calldata articleEncoded) external payable;
    function UnpublishArticle(bytes32 articleToken) external payable;
    function ConnectContract(address connectedContract) external payable; 
    function DisconnectContract(address connectedContract) external payable;
}