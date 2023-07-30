// SPDX-License-Identifier: AFL-3.0

pragma solidity >=0.8.18;

library AcademicRepositoryLibrary  {
    struct StoreData {
        mapping(address authorityID => Authority) authoritys;
        mapping(address authorityID => PostID[]) requests;
        mapping(address posterID => mapping(string model => uint256)) postSequences;
        mapping(address posterID => mapping(string model => mapping(uint256 sequence => Post))) posts;
    }

    struct StoreKey {
        address[] authorityIDs;
        string[] authorizedModels;
        PostID[] postIDs;
    }

    struct PostID {
        address posterID;
        string model;
        uint256 sequence;
    }

    struct Authority {
        string name;
        string typeInstitution;
        string country;
        string phone;
        string email;
        string website;
    }

    struct Post {
        uint256 time;
        string[] description;
        Authenticity authenticity;
    }

    struct Authenticity {
        address authority;
        bool authentic;
        string message;
    }
}
