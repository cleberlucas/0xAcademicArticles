// SPDX-License-Identifier: MIT

import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleDataModel {
    struct Publication {
        bytes32[] articleIdentifications;
        bytes32[] articleIdentificationsValidPublications;
        mapping(address publisherAccount => bytes32[]) articleIdentificationsPublisher;
        mapping(bytes32 articleIdentifications => ExampleModel.Publication) publication;
    }

    struct Institution {
        ExampleModel.Institution institution;
        address[] affiliateAccounts;     
    }
}