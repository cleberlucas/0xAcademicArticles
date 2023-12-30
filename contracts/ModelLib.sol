// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

library ModelLib {
    struct Article {
        string title;
        string summary;
        string course;
        string additional;
        string institution;
        string articleType;
        string academicDegree;
        string documentUrl;
        int yearPresentation;
        Contributors contributors;
    }

    struct Contributors {
        string[] authors;
        string[] advisors;
        string[] examinationsBoard;
    }
}
