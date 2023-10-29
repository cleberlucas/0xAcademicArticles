// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Bases/ModifierBase.sol";
import "../Bases/EventBase.sol";
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.22;

abstract contract InteractionHandler is
    DepositingGlobal,
    ModifierBase,
    EventBase
{
    function RegisterInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner {
        _institutions[institutionKey] = institution;
        _key.institutions.push(institutionKey);
        emit InstitutionRegistered(institutionKey);
    }

    function EditInstitution(
        address institutionKey,
        DelimitationLibrary.Institution memory institution
    ) public payable IsOwner {
        _institutions[institutionKey] = institution;
        emit InstitutionRegistered(institutionKey);
    }

    function UnregisterInstitution(
        address institutionKey
    ) public payable IsOwner {
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
        IsInstitution
        IsValidAddress(authenticatorKey)
        IsAuthenticatorBindedInIntituition(
            authenticatorKey,
            false,
            ErrorMessageLibrary.AuthenticatorBindedInInstitution
        )
    {
        _bindingIntitutionAuthenticators[authenticatorKey] = msg.sender;
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
        delete _bindingIntitutionAuthenticators[authenticatorKey];

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
        DepositingLibrary.ArticleKey memory articleKey
    )
        public
        payable
        IsAuthenticator
        IsArticlePosted(articleKey)
        IsArticleAuthenticated(
            articleKey,
            false,
            ErrorMessageLibrary.ArticleAuthenticated
        )
    {
        _institutionAuthenticatedArticles[articleKey.poster][articleKey.articleType][
            articleKey.sequenceArticleType
        ] = _bindingIntitutionAuthenticators[msg.sender];

        emit ArticleAuthenticated(articleKey, msg.sender);
    }

    function DisauthenticateArticle(
        DepositingLibrary.ArticleKey memory articleKey
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
        _institutionAuthenticatedArticles[articleKey.poster][articleKey.articleType][
            articleKey.sequenceArticleType
        ] = address(0);

        emit ArticleDisauthenticate(articleKey, msg.sender);
    }

    function PostArticle(
        DelimitationLibrary.ArticleType articleType,
        DelimitationLibrary.Article memory article
    ) public payable {
        uint256 sequenceArticleType = _sequenceArticleTypes[msg.sender][
            articleType
        ];

        DepositingLibrary.ArticleKey memory articleKey = DepositingLibrary
            .ArticleKey(msg.sender, articleType, sequenceArticleType);

        _articles[msg.sender][articleType][sequenceArticleType] = article;

        _key.articles.push(articleKey);

        _sequenceArticleTypes[msg.sender][articleType]++;

        emit ArticlePosted(articleKey);
    }

    function EditArticle(
        uint256 sequenceArticleType,
        DelimitationLibrary.ArticleType articleType,
        DelimitationLibrary.Article memory article
    )
        public
        payable
        IsArticlePosted(
            DepositingLibrary.ArticleKey(
                msg.sender,
                articleType,
                sequenceArticleType
            )
        )
    {
        _articles[msg.sender][articleType][sequenceArticleType] = article;

        emit ArticleEdited(
            DepositingLibrary.ArticleKey(
                msg.sender,
                articleType,
                sequenceArticleType
            )
        );
    }

    function RemoveArticle(
        uint256 sequenceArticleType,
        DelimitationLibrary.ArticleType articleType
    )
        public
        payable
        IsArticlePosted(
            DepositingLibrary.ArticleKey(
                msg.sender,
                articleType,
                sequenceArticleType
            )
        )
    {
        delete _articles[msg.sender][articleType][sequenceArticleType];

        for (uint256 i = 0; i < _key.articles.length; i++) {
            if (
                _key.articles[i].poster == msg.sender &&
                _key.articles[i].articleType == articleType &&
                _key.articles[i].sequenceArticleType == sequenceArticleType
            ) {
                _key.articles[i] = _key.articles[_key.articles.length - 1];
                _key.articles.pop();
            }
        }

        emit ArticleRemoved(
            DepositingLibrary.ArticleKey(
                msg.sender,
                articleType,
                sequenceArticleType
            )
        );
    }
}