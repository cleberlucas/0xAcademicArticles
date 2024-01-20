// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IERCXSearch {
    function Tokens(string calldata signature) external view returns (bytes32[] memory tokens);
    function Signature(bytes32 token) external view returns (string memory signature);
    function MetaData(bytes32 token) external view returns (bytes memory metadata);
    function Senders() external view returns (address[] memory senders);
    function Signature(address sender) external view returns (string memory signature);
    function Sender(string calldata signature) external view returns (address sender);
}