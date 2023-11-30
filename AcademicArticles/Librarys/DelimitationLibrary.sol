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
        int yearPresentation;
        Document document;
        ArticleType articleType;
        Contributors contributors;
        AcademicDegree academicDegree;
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
        Others,
        These,
        CaseStudy,
        Monograph,
        FinalProject,
        Dissertation,
        ReviewArticle,
        ScientificArticle,
        TheoreticalArticles,
        MethodologicalArticles
    }

    enum AcademicDegree {
        Mba,
        Master,
        Bachelor,
        Doctorate,
        Technologist,
        PostDoctoral,
        Specialization,    
        BachelorEducation
    }
}
