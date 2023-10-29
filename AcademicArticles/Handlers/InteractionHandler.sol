// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Extensions/ModifierExtension.sol";
import "../Extensions/EventExtension.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract InteractionHandler is
    RepositoryExtension,
    ModifierExtension,
    EventExtension
{
    function RegisterInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, false, ErrorMessageLibrary.InstitutionRegistered) {
        _data.institutions[institutionKey] = institution;
        _key.institutions.push(institutionKey);
        emit InstitutionRegistered(institutionKey);
    }

    function EditInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, true, ErrorMessageLibrary.InstitutionWasNotRegistered) {
        _data.institutions[institutionKey] = institution;
        emit InstitutionRegistered(institutionKey);
    }

    function UnregisterInstitution(
        address institutionKey
    ) public payable IsOwner IsInstitutionRegistered(institutionKey, true, ErrorMessageLibrary.InstitutionWasNotRegistered) {
        delete _data.institutions[institutionKey];

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
        IsInstitution
        IsValidAddress(authenticatorKey)
        IsAuthenticatorBindedInIntituition(
            authenticatorKey,
            false,
            ErrorMessageLibrary.AuthenticatorAlreadyBindedInInstitution
        )
    {
        _data.bindingAuthenticators[authenticatorKey] = msg.sender;
        _key.authenticators.push(authenticatorKey);

        emit AuthenticatorBinded(authenticatorKey, msg.sender);
    }

    function UnbindAuthenticator(
        address authenticatorKey
    )
        public
        payable
        IsInstitution
        IsAuthenticatorBindedInIntituition(
            authenticatorKey,
            true,
            ErrorMessageLibrary.AuthenticatorWasNotBindedInInstitution
        )
    {
        delete _data.bindingAuthenticators[authenticatorKey];

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
        RepositoryLibrary.ArticleKey memory articleKey
    )
        public
        payable
        IsAuthenticator
        IsArticlePosted(articleKey)
        IsArticleAuthenticated(
            articleKey,
            false,
            ErrorMessageLibrary.ArticleAlreadyAuthenticated
        )
    {
        _data.institutionAuthenticatedArticles[articleKey.poster][
            articleKey.articleType
        ][articleKey.sequenceArticleType] = _data
            .bindingAuthenticators[msg.sender];

        emit ArticleAuthenticated(articleKey, msg.sender);
    }

    function DisauthenticateArticle(
        RepositoryLibrary.ArticleKey memory articleKey
    )
        public
        payable
        IsAuthenticator
        IsSameInstitutionBinded(articleKey)
        IsArticleAuthenticated(
            articleKey,
            true,
            ErrorMessageLibrary.ArticleNotAuthenticated
        )
    {
        delete _data.institutionAuthenticatedArticles[articleKey.poster][
            articleKey.articleType
        ][articleKey.sequenceArticleType];

        emit ArticleDisauthenticate(articleKey, msg.sender);
    }

    function PostArticle(
        DelimitationLibrary.ArticleType articleTypeKey,
        DelimitationLibrary.Article memory article
    ) public payable {
        uint256 sequenceArticleType = _data.sequenceArticleTypes[msg.sender][
            articleTypeKey
        ];

        RepositoryLibrary.ArticleKey memory articleKey = RepositoryLibrary
            .ArticleKey(msg.sender, articleTypeKey, sequenceArticleType);

        _data.articles[msg.sender][articleTypeKey][
            sequenceArticleType
        ] = article;

        _key.articles.push(articleKey);

        _data.sequenceArticleTypes[msg.sender][articleTypeKey]++;

        emit ArticlePosted(articleKey);
    }

    function EditArticle(
        uint256 sequenceArticleTypeKey,
        DelimitationLibrary.ArticleType articleTypeKey,
        DelimitationLibrary.Article memory article
    )
        public
        payable
        IsArticlePosted(
            RepositoryLibrary.ArticleKey(
                msg.sender,
                articleTypeKey,
                sequenceArticleTypeKey
            )
        )
    {
        _data.articles[msg.sender][articleTypeKey][
            sequenceArticleTypeKey
        ] = article;

        emit ArticleEdited(
            RepositoryLibrary.ArticleKey(
                msg.sender,
                articleTypeKey,
                sequenceArticleTypeKey
            )
        );
    }

    function RemoveArticle(
        uint256 sequenceArticleTypeKey,
        DelimitationLibrary.ArticleType articleTypeKey
    )
        public
        payable
        IsArticlePosted(
            RepositoryLibrary.ArticleKey(
                msg.sender,
                articleTypeKey,
                sequenceArticleTypeKey
            )
        )
    {
        delete _data.articles[msg.sender][articleTypeKey][
            sequenceArticleTypeKey
        ];

        for (uint256 i = 0; i < _key.articles.length; i++) {
            if (
                _key.articles[i].poster == msg.sender &&
                _key.articles[i].articleType == articleTypeKey &&
                _key.articles[i].sequenceArticleType == sequenceArticleTypeKey
            ) {
                _key.articles[i] = _key.articles[_key.articles.length - 1];
                _key.articles.pop();
            }
        }

        emit ArticleRemoved(
            RepositoryLibrary.ArticleKey(
                msg.sender,
                articleTypeKey,
                sequenceArticleTypeKey
            )
        );
    }
}
