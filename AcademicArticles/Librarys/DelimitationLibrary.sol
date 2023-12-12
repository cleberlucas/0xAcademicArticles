// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.22;

library DelimitationLibrary {
    struct Institution {
        string name;
        string phone;
        string email;
        string websiteUrl;
        string institutionType;
        string institutionAddress;
        File logoUrl;
    }

    struct Article {
        string title;
        string summary;
        string course;
        string additional;
        string institution;
        string articleType;
        string academicDegree;
        int yearPresentation;
        File document;
        Contributors contributors;
    }

    struct Contributors {
        string[] authors;
        string[] advisors;
        string[] examinationsBoard;
    }

    struct File {
        string Url;
        string[] Base64;
    }
}
