// SPDX-License-Identifier: AFL-3.0

pragma solidity >=0.8.18;

library AcademicRepositoryLibrary {
    struct FinalProject {
        string title;
        string summary;
        string authors;
        string advisors;
        string course;
        string institution;
        string url;
    }

    struct ScientificArticle {
        string title;
        string summary;
        string authors;
        string advisors;
        string course;
        string institution;
        string url;
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
