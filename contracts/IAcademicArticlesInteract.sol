// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

interface IAcademicArticlesInteract {
    function PublishArticle(string memory articleAbi) external payable returns (bytes32 articleToken);
    function UnpublishArticle(bytes32 articleToken) external payable;
    function StampArticle(bytes32 articleToken) external payable;
    function UnstampArticle(bytes32 articleToken) external payable;
    function RegisterInstitution(address institutionAccount) external payable;
    function UnregisterInstitution(address institutionAccount) external payable;
    function LinkAffiliate(address affiliateAccount) external payable;
    function UnlinkAffiliate(address affiliateAccount) external payable;
    function AddContract(address contractAccount) external payable;
    function RemoveContract(address contractAccount) external payable;
}