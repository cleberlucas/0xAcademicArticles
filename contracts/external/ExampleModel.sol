// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library ExampleModel {

    struct Publication {
        Article article;
        bytes32 identification;
        address publisher;
        uint256 datatime;
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
}