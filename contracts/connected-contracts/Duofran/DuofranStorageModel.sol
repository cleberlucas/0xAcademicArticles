// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranModel.sol";

library DuofranStorageModel {
    struct Publication {
        bytes32[] identifications;
        bytes32[] identificationsValid;
        address[] publishers;
		mapping(bytes32 identification => address) publisher;
        mapping(bytes32 identification => uint256) dateTime;
        mapping(bytes32 identification => uint256) blockNumber;
		mapping(bytes32 identification => bool) valid;
		mapping(address publisher => bytes32[]) identificationsOfPublisher;
    }

    struct Affiliate {
        address[] accounts;
        mapping(address account => string) name;
    }

    struct Me {
        string name;
        string logoUrl;
        string siteUrl;
        string requestEmail;
        string contactNumber;
    }
}