// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

contract ExampleModel {
    struct Publication {
        Article content;
        bytes32 identification;
        address publisher;
        uint256 publicationTimestamp;
        uint256 blockNumber;
        bool valid;
    }

    struct PublicationPreview {
        string title;
        bool validated;
    }

    struct Article {
        string title;
        string summary;
        string additionalInfo;
        string institution;
        string course;
        string articleType;
        string academicDegree;
        string documentationUrl;
        string[] authors;
        string[] supervisors;
        string[] examiningBoard;
        int presentationYear;
    }

    struct Institution {
        string name;
        string logoUrl;
        string siteUrl;
        string requestEmail;
        string contactNumber;
    }
}