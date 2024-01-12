// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;


interface IAcademicArticlesWrite {
    function RegisterInstitution(address institutionAccount) external payable;
    function UnregisterInstitution(address institutionAccount) external payable;
    function LinkAffiliate(address affiliateAccount) external payable;
    function UnlinkAffiliate(address affiliateAccount) external payable;
    function ValidateArticle(bytes32 articleToken) external payable;
    function InvalidateArticle(bytes32 articleToken) external payable;
    function PublishArticle(string memory articleAbi) external payable returns (bytes32 articleToken);
    function UnpublishArticle(bytes32 articleToken) external payable;
}
