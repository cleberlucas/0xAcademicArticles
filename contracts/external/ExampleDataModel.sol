// SPDX-License-Identifier: MIT

import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleDataModel {
    
    struct Publication {
        bytes32[] identifications;
        bytes32[] identificationsValid;
        bytes32[] publishers;
		mapping(bytes32 identification => address) publisher;
        mapping(bytes32 identification => uint256) datatime;
        mapping(bytes32 identification => uint256) blockNumber;
		mapping(bytes32 identification => bool) valid;
		mapping(address publisherAccount => bytes32[]) identificationsOfPublisher;	
    }

    struct Me {
        ExampleModel.Me me;
        address[] affiliateAccounts;     
    }
}