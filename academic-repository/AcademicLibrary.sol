// SPDX-License-Identifier: AFL-3.0

pragma solidity >=0.8.18;

library AcademicLibrary {
    struct Institution {
        string name;
        string country;
        string phone;
        string email;
        string websiteUrl;
        string logoUrl;
    }

    struct FinalProject {
        string title;
        string summary;
        string authors;
        string advisors;
        string course;
        string institution;
        string documentUrl;
    }

    struct ScientificArticle {
        string title;
        string summary;
        string authors;
        string advisors;
        string course;
        string institution;
        string documentUrl;
    }

    struct Monograph {
        string title;
        string comming;
    }

    struct MastersThesis {
        string title;
        string comming;
    }

    struct DoctoralThesis {
        string title;
        string comming;
    }
}
