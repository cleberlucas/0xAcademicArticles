// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAIOSearch {
    function Classifications(bytes32 signature) external view returns (bytes32[] memory classifications);
    function Keys(bytes32 signature, bytes32 classification) external view returns (bytes32[] memory keys);
    function Metadata(bytes32 signature, bytes32 classification, bytes32 key) external view returns (bytes memory metadata);
    function States(bytes32 signature, bytes32 classification, bytes32 key) external view returns (bytes32[] memory states);
    function Senders() external view returns (address[] memory senders);
    function Signature(address sender) external view returns (bytes32 signature);
    function Sender(bytes32 signature) external view returns (address sender);
}