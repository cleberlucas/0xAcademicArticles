// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";

import "../Abstracts/ModifierAbstract.sol";

import "../Abstracts/EventAbstract.sol";

import "../Shareds/DepositingShared.sol";

pragma solidity >=0.8.18;

contract InteractionHandler is DepositingShared, ModifierAbstract, EventAbstract {
    function RegisterInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, false) {
        institutionProfileShared[institutionKey] = institution;
        keyShared.institutions.push(institutionKey);
        emit InstitutionRegistered(institutionKey);
    }

    function EditInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, true) {
        institutionProfileShared[institutionKey] = institution;
        emit InstitutionRegistered(institutionKey);
    }

    function UnregisterInstitution(address institutionKey) public payable IsOwner IsInstitutionRegistered(institutionKey, true)  {
        delete institutionProfileShared[institutionKey];

        for (uint256 i = 0; i < keyShared.institutions.length; i++) {
            if (keyShared.institutions[i] == institutionKey) {
                keyShared.institutions[i] = keyShared.institutions[
                    keyShared.institutions.length - 1
                ];
                keyShared.institutions.pop();
            }
        }

        emit InstitutionUnregistered(institutionKey);
    }

    function RegisterAuthenticator(address authenticatorKey) public payable IsInstitutionRegistered(msg.sender, true) 
    IsAuthenticatorInstitutionRegistered(authenticatorKey, msg.sender, false)  {
        authenticatorInstitutionShared[authenticatorKey] = msg.sender;
        keyShared.authenticators.push(authenticatorKey);

        emit AuthenticatorRegistered(authenticatorKey, msg.sender);
    }

    function UnregisterAuthenticator(address authenticatorKey) public payable IsInstitutionRegistered(msg.sender, true) 
    IsAuthenticatorInstitutionRegistered(authenticatorKey, msg.sender, true)  {
        delete authenticatorInstitutionShared[authenticatorKey];

        for (uint256 i = 0; i < keyShared.authenticators.length; i++) {
            if (keyShared.authenticators[i] == authenticatorKey) {
                keyShared.authenticators[i] = keyShared.authenticators[
                    keyShared.authenticators.length - 1
                ];
                keyShared.authenticators.pop();
            }
        }

        emit AuthenticatorUnregistered(authenticatorKey, msg.sender);
    }

    function AuthenticateArticle(
        RepositoryLibrary.ArticleKey[] memory articlesKey
    ) public payable IsAuthenticatorRegistered( msg.sender, true) IsArticlesRegistered(articlesKey) IsNotArticleAutenticated(articlesKey) {
        for (uint256 i = 0; i < articlesKey.length; i++) {
         
            articleShared[articlesKey[i].poster][articlesKey[i].articleType][
                articlesKey[i].sequence
            ].authenticator = msg.sender;

            emit ArticleAuthenticated(RepositoryLibrary.ArticleKey(articlesKey[i].poster, articlesKey[i].articleType, articlesKey[i].sequence), msg.sender);
        }      
    }

    function RegisterArticle(
        DelimitationLibrary.ArticleType articleType,
        string memory title,
        string memory summary,
        string memory course,
        string memory institution,
        DelimitationLibrary.Contributors memory contributors,
        DelimitationLibrary.Document memory document,
        DelimitationLibrary.AcademicDegree academicDegree,
        int year
    ) public payable {
        uint256 sequence = sequenceShared[msg.sender][articleType];

        articleShared[msg.sender][articleType][sequence]  = DelimitationLibrary.Article(
            title,
            summary,
            course,
            institution,
            address(0),
            contributors,
            document,
            academicDegree,
            year
        );

        keyShared.articles.push(
            RepositoryLibrary.ArticleKey(msg.sender, articleType, sequence)
        );

        sequenceShared[msg.sender][articleType]++;

        emit ArticleRegistered(RepositoryLibrary.ArticleKey(msg.sender, articleType, sequence));
    }

    function EditedArticle(
        uint256 sequence,
        DelimitationLibrary.ArticleType articleType,
        string memory title,
        string memory summary,
        string memory course,
        string memory institution,
        DelimitationLibrary.Contributors memory contributors,
        DelimitationLibrary.Document memory document,
        DelimitationLibrary.AcademicDegree academicDegree,
        int year) public payable IsArticleRegistered(RepositoryLibrary.ArticleKey(msg.sender,articleType, sequence)) {

        articleShared[msg.sender][articleType][sequence] = DelimitationLibrary.Article(
            title,
            summary,
            course,
            institution,
            address(0),
            contributors,
            document,
            academicDegree,
            year
        );

        emit ArticleEdited(RepositoryLibrary.ArticleKey(msg.sender, articleType, sequence));
    }

    function UnregisterArticle(
        uint256 sequence,
        DelimitationLibrary.ArticleType articleType
  ) public payable IsNotArticleRegistered(RepositoryLibrary.ArticleKey(msg.sender,articleType, sequence))  {

        delete articleShared[msg.sender][articleType][sequence];

        for (uint256 i = 0; i < keyShared.articles.length; i++) {
            if (
                keyShared.articles[i].poster == msg.sender &&
                keyShared.articles[i].articleType == articleType &&
                keyShared.articles[i].sequence == sequence
            ) {
                keyShared.articles[i] = keyShared.articles[keyShared.articles.length - 1];
                keyShared.articles.pop();
            }
        }

        emit ArticleUnregistered(RepositoryLibrary.ArticleKey(msg.sender, articleType, sequence));
    }
}
