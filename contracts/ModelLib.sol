// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library ModelLib {
    struct Article {
        string title;
        string summary;
        string additional;
        string institution;
        string course;
        string articleType;
        string academicDegree;
        string documentUrl;
        string[] authors;
        string[] advisors;
        string[] examinationsBoard;
        int yearPresentation;
    }
}
