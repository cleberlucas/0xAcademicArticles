// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.22;

library DelimitationLibrary {
    struct Institution {
        string name;
        string country;
        string websiteUrl;
        string logoUrl;
        string[] phone;
        string[] email;
    }

    struct Article {
        string title;
        string summary;
        string course;
        string institution;
        string additional;
        ArticleType articleType;
        Contributors contributors;
        Document document;
        AcademicDegree academicDegree;
        int yearPresentation;
    }

    struct Contributors {
        string[] authors;
        string[] advisors;
        string[] examinationsBoard;
    }

    struct Document {
        string Url;
        string[] Base64;
    }

    enum ArticleType {
        FinalProject,
        ScientificArticle,
        These,
        Monograph,
        Dissertation,
        ResearchProject,
        Others
    }

    enum AcademicDegree {
        Technologist,
        BachelorEducation,
        Bachelor,
        Specialization,
        Master,
        Doctorate
    }
}
