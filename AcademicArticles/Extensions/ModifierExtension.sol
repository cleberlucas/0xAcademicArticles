// SPDX-License-Identifier: AFL-3.0
import "../Librarys/RepositoryLibrary.sol";
import "../Librarys/ErrorMessageLibrary.sol";
import "../Utils/ModifierUtil.sol";
import "../Extensions/RepositoryExtension.sol";

pragma solidity >=0.8.22;

abstract contract ModifierExtension is RepositoryExtension, ModifierUtil {
    modifier IsOwner() {
        Require(OWNER == msg.sender, ErrorMessageLibrary.OWNER_ACTION);
        _;
    }

    modifier IsInstitution() {
        Require(_institution.owner[msg.sender] != address(0), ErrorMessageLibrary.INSTITUTION_ACTION);
        _;
    }

    modifier IsAuthenticator() {
         Require(_authenticator.institution[msg.sender] != address(0), ErrorMessageLibrary.AUTHENTICATOR_ACTION);
        _;
    }

    modifier IsValidAddress(address validateAddress) {
        Require(validateAddress != address(0), ErrorMessageLibrary.NOT_VALID_ADDRESS);
        _;
    }

    modifier IsInstitutionRegistered(address account, bool registered, string memory messageOnError) {
        Require( (_institution.owner[account] != address(0)) == registered, messageOnError);
        _;
    }

    modifier IsAuthenticatorBindedInInstitution(address account, bool binded, string memory messageOnError) 
    {
        Require((_authenticator.institution[account] == msg.sender) == binded, messageOnError);
        _;
    }

    modifier IsSameInstitutionBindedArticle(bytes32 hashIdentifier)
    {
        Require( 
            _authenticator.institution[_article.authenticator[hashIdentifier]] == _authenticator.institution[msg.sender],   
            ErrorMessageLibrary.AUTHENTICATOR_NOT_BELONG_INSTITUTION_BINDED
        );
        _;
    }

    modifier IsArticlePosted(bytes32 hashIdentifier, bool posted, string memory messageOnError) {     
        Require((_article.poster[hashIdentifier] != address(0)) == posted, messageOnError);
        _;
    }

    modifier IsArticleAuthenticated(bytes32 hashIdentifier,bool authenticated, string memory messageOnError) 
    {
        Require((_article.poster[hashIdentifier] != address(0)) == authenticated, messageOnError);
        _;
    }

    modifier IsArticleMy(bytes32 hashIdentifier) 
    {
        Require(_article.poster[hashIdentifier] == msg.sender, ErrorMessageLibrary.ARTICLE_NOT_YOURS);
        _;
    }
}
