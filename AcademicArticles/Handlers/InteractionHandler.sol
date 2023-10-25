// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Bases/ModifierBase.sol";
import "../Bases/EventBase.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.18;

contract InteractionHandler is
    DepositingGlobal,
    ModifierBase,
    EventBase
{
    function RegisterInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, false) {
        _institutions[institutionKey] = institution;
        _key.institutions.push(institutionKey);
        emit InstitutionRegistered(institutionKey);
    }

    function EditInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, true) {
        _institutions[institutionKey] = institution;
        emit InstitutionRegistered(institutionKey);
    }

    function UnregisterInstitution(
        address institutionKey
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, true) {
        delete _institutions[institutionKey];

        for (uint256 i = 0; i < _key.institutions.length; i++) {
            if (_key.institutions[i] == institutionKey) {
                _key.institutions[i] = _key.institutions[
                    _key.institutions.length - 1
                ];
                _key.institutions.pop();
            }
        }

        emit InstitutionUnregistered(institutionKey);
    }

    function BindAuthenticator(
        address authenticatorKey
    )
        public
        payable
        IsInstitutionRegistered(msg.sender, true)
        IsAuthenticatorBinded(
            authenticatorKey,
            msg.sender,
            false
        )
    {
        _authenticators[authenticatorKey] = msg.sender;
        _key.authenticators.push(authenticatorKey);

        emit AuthenticatorBinded(authenticatorKey, msg.sender);
    }

    function UnBindAuthenticator(
        address authenticatorKey
    )
        public
        payable
        IsInstitutionRegistered(msg.sender, true)
        IsAuthenticatorBinded(authenticatorKey, msg.sender, true)
    {
        delete _authenticators[authenticatorKey];

        for (uint256 i = 0; i < _key.authenticators.length; i++) {
            if (_key.authenticators[i] == authenticatorKey) {
                _key.authenticators[i] = _key.authenticators[
                    _key.authenticators.length - 1
                ];
                _key.authenticators.pop();
            }
        }

        emit AuthenticatorUnbinded(authenticatorKey, msg.sender);
    }

    function AuthenticateArticle(
        DepositingLibrary.ArticleKey[] memory articlesKey
    )
        public
        payable
        IsAuthenticatorRegistered(msg.sender)
        IsArticlesPosted(articlesKey)
        IsNotArticlesAuthenticated(articlesKey)
    {
        for (uint256 i = 0; i < articlesKey.length; i++) {
            _articles[articlesKey[i].poster][articlesKey[i].articleType][
                articlesKey[i].sequence
            ].authenticator = msg.sender;

            emit ArticleAuthenticated(
                DepositingLibrary.ArticleKey(
                    articlesKey[i].poster,
                    articlesKey[i].articleType,
                    articlesKey[i].sequence
                ),
                msg.sender
            );
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
        uint256 sequence = _sequences[msg.sender][articleType];

        _articles[msg.sender][articleType][sequence] = DelimitationLibrary
            .Article(
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

        _key.articles.push(
            DepositingLibrary.ArticleKey(msg.sender, articleType, sequence)
        );

        _sequences[msg.sender][articleType]++;

        emit ArticlePosted(
            DepositingLibrary.ArticleKey(msg.sender, articleType, sequence)
        );
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
        int year
    )
        public
        payable
        IsArticlePosted(
            DepositingLibrary.ArticleKey(msg.sender, articleType, sequence)
        )
    {
        _articles[msg.sender][articleType][sequence] = DelimitationLibrary
            .Article(
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

        emit ArticleEdited(
            DepositingLibrary.ArticleKey(msg.sender, articleType, sequence)
        );
    }

    function UnregisterArticle(
        uint256 sequence,
        DelimitationLibrary.ArticleType articleType
    )
        public
        payable
        IsArticlePosted(
            DepositingLibrary.ArticleKey(msg.sender, articleType, sequence)
        )
    {
        delete _articles[msg.sender][articleType][sequence];

        for (uint256 i = 0; i < _key.articles.length; i++) {
            if (
                _key.articles[i].poster == msg.sender &&
                _key.articles[i].articleType == articleType &&
                _key.articles[i].sequence == sequence
            ) {
                _key.articles[i] = _key.articles[
                    _key.articles.length - 1
                ];
                _key.articles.pop();
            }
        }

        emit ArticleRemoved(
            DepositingLibrary.ArticleKey(msg.sender, articleType, sequence)
        );
    }
}
