// SPDX-License-Identifier: AFL-3.0

pragma solidity >=0.8.18;

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
        address authenticator;
        Contributors contributors;
        Document document;
        AcademicDegree academicDegree;
        int year;
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
        Dissertation   
    }

    enum AcademicDegree {
        Technologist,
        Bachelor,
        BachelorEducation,
        Specialization,
        Master,
        Doctorate
    }
}