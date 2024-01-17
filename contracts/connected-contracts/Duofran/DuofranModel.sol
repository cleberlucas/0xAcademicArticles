// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library DuofranModel {
    struct Publication {
        Article article;
        address publisher;
        uint256 datatime;
        bool valid;
    }

    struct PublicationPreview {
        string title;
        bool validated;
        bytes32 identification;
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