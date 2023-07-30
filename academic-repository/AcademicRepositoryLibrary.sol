// SPDX-License-Identifier: AFL-3.0

pragma solidity >=0.8.18;

library AcademicRepositoryLibrary {
    struct StoreData {
        mapping(address posterID => AuthenticatedPoster) AuthenticatedPosters;
        mapping(AcademicTypes academicTypes => mapping(address posterID => uint256 sequence)) NextSequenceAcademicType;
        mapping(address posterID => mapping(uint256 sequence => FinalProject)) FinalProject;
        mapping(address posterID => mapping(uint256 sequence => ScientificPaper)) ScientificPaper;
        mapping(address posterID => mapping(uint256 sequence => Monograph)) Monograph;
        mapping(address posterID => mapping(uint256 sequence => MastersThesis)) MastersThesis;
        mapping(address posterID => mapping(uint256 sequence => DoctoralThesis)) DoctoralThesis;
        mapping(address posterID => mapping(uint256 sequence => ResearchReport)) ResearchReport;
        mapping(address posterID => mapping(uint256 sequence => BookReview)) BookReview;
        mapping(address posterID => mapping(uint256 sequence => ResearchProposal)) ResearchProposal;
        mapping(address posterID => mapping(uint256 sequence => InternshipReport)) InternshipReport;
        mapping(address posterID => mapping(uint256 sequence => Coursework)) Coursework;
    }

    struct StoreKey {
        address[] posterIDs;
        PostID[] postIDs;
    }

    struct PostID {
        address posterID;
        AcademicTypes academicType;
        uint256 sequence;
    }

    struct AuthenticatedPoster {
        string name;
        posterTypes posterType;
        string country;
        string phone;
        string email;
        string website;
    }

    enum posterTypes {
        normal,
        institution
    }

    enum AcademicTypes {
        FinalProject,
        ScientificPaper,
        Monograph,
        MastersThesis,
        DoctoralThesis,
        ResearchReport,
        BookReview,
        ResearchProposal,
        InternshipReport,
        Coursework
    }

    struct FinalProject {
        string title;
        string summary;
        string authors;
        string advisors;
        string course;
        string institution;
        string url;
    }

    struct ScientificPaper {
        string title;
        string summary;
        string authors;
        string advisors;
        string course;
        string institution;
        string url;
    }

    struct Monograph {
        string comming;
    }

    struct MastersThesis {
        string comming;
    }

    struct DoctoralThesis {
        string comming;
    }

    struct ResearchReport {
        string comming;
    }

    struct BookReview {
        string comming;
    }

    struct ResearchProposal {
        string comming;
    }

    struct InternshipReport {
        string comming;
    }

    struct Coursework {
        string comming;
    }
}
