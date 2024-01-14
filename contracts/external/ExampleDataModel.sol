// SPDX-License-Identifier: MIT

import "./ExampleModel.sol";

pragma solidity ^0.8.23;

library ExampleDataModel {

    // Write methods: PublishArticles, UnpublishArticles
    struct Publication {

        bytes32[] identifications;
        bytes32[] identificationsValid;
        bytes32[] publishers;
		mapping(bytes32 identification => address) publisher;
        mapping(bytes32 identification => uint256) dateTime;
        mapping(bytes32 identification => uint256) blockNumber;
		mapping(bytes32 identification => bool) valid; //Write methods: ValidateArticles, InvalidateArticles
		mapping(address publisher => bytes32[]) identificationsOfPublisher;	
    }

    // Write methods: LinkAffiliate, UnlinkAffiliate
    struct Affiliate {

        address[] accounts;     
    }

    // Write method: ChangeMe
    struct Me {

        string name;
        string logoUrl;
        string siteUrl;
        string requestEmail;
        string contactNumber;
    }
}