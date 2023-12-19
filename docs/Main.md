# Solidity API

## EventComplement

### Contract
EventComplement : AcademicArticles/Complements/EventComplement.sol

 --- 
### Events:
### InstitutionRegistered

```solidity
event InstitutionRegistered(address institutionAccount)
```

### InstitutionUnregistered

```solidity
event InstitutionUnregistered(address institutionAccount)
```

### AuthenticatorBinded

```solidity
event AuthenticatorBinded(address authenticatorAccount)
```

### AuthenticatorUnbinded

```solidity
event AuthenticatorUnbinded(address authenticatorAccount)
```

### ArticleAuthenticated

```solidity
event ArticleAuthenticated(bytes32 articleId)
```

### ArticleUnauthenticate

```solidity
event ArticleUnauthenticate(bytes32 articleId)
```

### ArticlePosted

```solidity
event ArticlePosted(bytes32 articleId)
```

### ArticleRemoved

```solidity
event ArticleRemoved(bytes32 articleId)
```

## ModifierComplement

### Contract
ModifierComplement : AcademicArticles/Complements/ModifierComplement.sol

 --- 
### Modifiers:
### IsOwner

```solidity
modifier IsOwner()
```

### IsInstitution

```solidity
modifier IsInstitution()
```

### IsInstitutionOrAuthenticator

```solidity
modifier IsInstitutionOrAuthenticator()
```

### AreNotInstitution

```solidity
modifier AreNotInstitution(address[] accounts)
```

### AreNotAuthenticator

```solidity
modifier AreNotAuthenticator(address[] accounts)
```

### AreNotEmptyAccountEntrie

```solidity
modifier AreNotEmptyAccountEntrie(address[] accounts)
```

### AreNotDuplicatedAccountEntrie

```solidity
modifier AreNotDuplicatedAccountEntrie(address[] accounts)
```

### AreNotDuplicatedArticleEntrie

```solidity
modifier AreNotDuplicatedArticleEntrie(bytes32[] articleids)
```

### IsInstitutionRegistered

```solidity
modifier IsInstitutionRegistered(address institutionAccount, bool registered, string messageOnError)
```

### AreInstitutionRegistered

```solidity
modifier AreInstitutionRegistered(address[] institutionAccounts, bool registered, string messageOnError)
```

### AreBindedInInstitution

```solidity
modifier AreBindedInInstitution(address[] authenticatorAccounts)
```

### AreNotBindedToAnInstitution

```solidity
modifier AreNotBindedToAnInstitution(address[] authenticatorAccounts)
```

### AreArticleAuthenticatedByInstitution

```solidity
modifier AreArticleAuthenticatedByInstitution(bytes32[] articleIds)
```

### AreArticlePosted

```solidity
modifier AreArticlePosted(bytes32[] articleIds, bool posted, string messageOnError)
```

### AreArticleAuthenticated

```solidity
modifier AreArticleAuthenticated(bytes32[] articleIds, bool authenticated, string messageOnError)
```

### AreArticleMy

```solidity
modifier AreArticleMy(bytes32[] ArticleIds)
```

 --- 
### Functions:
inherits UtilsComplement:
### ArticleIdFromArticleContents

```solidity
function ArticleIdFromArticleContents(struct DelimitationLibrary.Article[] articleContents) internal pure returns (bytes32[] result)
```

### InstitutionOfAuthenticator

```solidity
function InstitutionOfAuthenticator(address authenticatorAccount) internal view returns (address result)
```

### IsInstitution_

```solidity
function IsInstitution_(address institutionAccount) internal view returns (bool result)
```

inherits RepositoryComplement:

## RepositoryComplement

### Contract
RepositoryComplement : AcademicArticles/Complements/RepositoryComplement.sol

 --- 
### Functions:
### constructor

```solidity
constructor() internal
```

## UtilsComplement

### Contract
UtilsComplement : AcademicArticles/Complements/UtilsComplement.sol

 --- 
### Functions:
### ArticleIdFromArticleContents

```solidity
function ArticleIdFromArticleContents(struct DelimitationLibrary.Article[] articleContents) internal pure returns (bytes32[] result)
```

### InstitutionOfAuthenticator

```solidity
function InstitutionOfAuthenticator(address authenticatorAccount) internal view returns (address result)
```

### IsInstitution_

```solidity
function IsInstitution_(address institutionAccount) internal view returns (bool result)
```

inherits RepositoryComplement:

## StateHandler

### Contract
StateHandler : AcademicArticles/Handlers/StateHandler.sol

 --- 
### Functions:
### RegisterInstitution

```solidity
function RegisterInstitution(address[] institutionAccounts) public payable
```

### UnregisterInstitution

```solidity
function UnregisterInstitution(address[] institutionAccounts) public payable
```

### BindAuthenticator

```solidity
function BindAuthenticator(address[] authenticatorAccounts) public payable
```

### UnbindAuthenticator

```solidity
function UnbindAuthenticator(address[] authenticatorAccounts) public payable
```

### AuthenticateArticle

```solidity
function AuthenticateArticle(bytes32[] articleIds) public payable
```

### UnauthenticateArticle

```solidity
function UnauthenticateArticle(bytes32[] articleIds) public payable
```

### PostArticle

```solidity
function PostArticle(struct DelimitationLibrary.Article[] articleContents) public payable
```

### RemoveArticle

```solidity
function RemoveArticle(bytes32[] articleIds) public payable
```

inherits EventComplement:
inherits ModifierComplement:
inherits UtilsComplement:
### ArticleIdFromArticleContents

```solidity
function ArticleIdFromArticleContents(struct DelimitationLibrary.Article[] articleContents) internal pure returns (bytes32[] result)
```

### InstitutionOfAuthenticator

```solidity
function InstitutionOfAuthenticator(address authenticatorAccount) internal view returns (address result)
```

### IsInstitution_

```solidity
function IsInstitution_(address institutionAccount) internal view returns (bool result)
```

inherits RepositoryComplement:
inherits IStateHandler:

 --- 
### Events:
inherits EventComplement:
### InstitutionRegistered

```solidity
event InstitutionRegistered(address institutionAccount)
```

### InstitutionUnregistered

```solidity
event InstitutionUnregistered(address institutionAccount)
```

### AuthenticatorBinded

```solidity
event AuthenticatorBinded(address authenticatorAccount)
```

### AuthenticatorUnbinded

```solidity
event AuthenticatorUnbinded(address authenticatorAccount)
```

### ArticleAuthenticated

```solidity
event ArticleAuthenticated(bytes32 articleId)
```

### ArticleUnauthenticate

```solidity
event ArticleUnauthenticate(bytes32 articleId)
```

### ArticlePosted

```solidity
event ArticlePosted(bytes32 articleId)
```

### ArticleRemoved

```solidity
event ArticleRemoved(bytes32 articleId)
```

inherits ModifierComplement:
inherits UtilsComplement:
inherits RepositoryComplement:
inherits IStateHandler:

## ViewHandler

### Contract
ViewHandler : AcademicArticles/Handlers/ViewHandler.sol

 --- 
### Functions:
### ArticleIds

```solidity
function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) public view returns (bytes32[] result, uint256 size)
```

### ArticlePoster

```solidity
function ArticlePoster(bytes32[] articleIds) public view returns (address[] result)
```

### ArticleInstitution

```solidity
function ArticleInstitution(bytes32[] articleIds) public view returns (address[] result)
```

### ArticleContent

```solidity
function ArticleContent(bytes32[] articleIds) public view returns (struct DelimitationLibrary.Article[] result)
```

### InstitutionAccounts

```solidity
function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse) public view returns (address[] result, uint256 size)
```

### InstitutionAuthenticators

```solidity
function InstitutionAuthenticators(address[] institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) public view returns (address[][] result, uint256[] size)
```

inherits RepositoryComplement:
inherits IViewHandler:

## IMain

### Contract
IMain : AcademicArticles/Interfaces/IMain.sol

 --- 
### Functions:
inherits IStateHandler:
### RegisterInstitution

```solidity
function RegisterInstitution(address[] institutionAccounts) external payable
```

### UnregisterInstitution

```solidity
function UnregisterInstitution(address[] institutionAccounts) external payable
```

### BindAuthenticator

```solidity
function BindAuthenticator(address[] authenticatorAccounts) external payable
```

### UnbindAuthenticator

```solidity
function UnbindAuthenticator(address[] authenticatorAccounts) external payable
```

### AuthenticateArticle

```solidity
function AuthenticateArticle(bytes32[] articleIds) external payable
```

### UnauthenticateArticle

```solidity
function UnauthenticateArticle(bytes32[] articleIds) external payable
```

### PostArticle

```solidity
function PostArticle(struct DelimitationLibrary.Article[] articleContents) external payable
```

### RemoveArticle

```solidity
function RemoveArticle(bytes32[] articleIds) external payable
```

inherits IViewHandler:
### ArticleIds

```solidity
function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) external view returns (bytes32[] result, uint256 size)
```

### ArticlePoster

```solidity
function ArticlePoster(bytes32[] articleIds) external view returns (address[] result)
```

### ArticleInstitution

```solidity
function ArticleInstitution(bytes32[] articleIds) external view returns (address[] result)
```

### ArticleContent

```solidity
function ArticleContent(bytes32[] articleIds) external view returns (struct DelimitationLibrary.Article[] result)
```

### InstitutionAccounts

```solidity
function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse) external view returns (address[] result, uint256 size)
```

### InstitutionAuthenticators

```solidity
function InstitutionAuthenticators(address[] institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) external view returns (address[][] result, uint256[] size)
```

## IStateHandler

### Contract
IStateHandler : AcademicArticles/Interfaces/IStateHandler.sol

 --- 
### Functions:
### RegisterInstitution

```solidity
function RegisterInstitution(address[] institutionAccounts) external payable
```

### UnregisterInstitution

```solidity
function UnregisterInstitution(address[] institutionAccounts) external payable
```

### BindAuthenticator

```solidity
function BindAuthenticator(address[] authenticatorAccounts) external payable
```

### UnbindAuthenticator

```solidity
function UnbindAuthenticator(address[] authenticatorAccounts) external payable
```

### AuthenticateArticle

```solidity
function AuthenticateArticle(bytes32[] articleIds) external payable
```

### UnauthenticateArticle

```solidity
function UnauthenticateArticle(bytes32[] articleIds) external payable
```

### PostArticle

```solidity
function PostArticle(struct DelimitationLibrary.Article[] articleContents) external payable
```

### RemoveArticle

```solidity
function RemoveArticle(bytes32[] articleIds) external payable
```

## IViewHandler

### Contract
IViewHandler : AcademicArticles/Interfaces/IViewHandler.sol

 --- 
### Functions:
### ArticleIds

```solidity
function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) external view returns (bytes32[] result, uint256 size)
```

### ArticlePoster

```solidity
function ArticlePoster(bytes32[] articleIds) external view returns (address[] result)
```

### ArticleInstitution

```solidity
function ArticleInstitution(bytes32[] articleIds) external view returns (address[] result)
```

### ArticleContent

```solidity
function ArticleContent(bytes32[] articleIds) external view returns (struct DelimitationLibrary.Article[] result)
```

### InstitutionAccounts

```solidity
function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse) external view returns (address[] result, uint256 size)
```

### InstitutionAuthenticators

```solidity
function InstitutionAuthenticators(address[] institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) external view returns (address[][] result, uint256[] size)
```

## DelimitationLibrary

### Contract
DelimitationLibrary : AcademicArticles/Librarys/DelimitationLibrary.sol

## MessageLibrary

### Contract
MessageLibrary : AcademicArticles/Librarys/MessageLibrary.sol

## RepositoryLibrary

### Contract
RepositoryLibrary : AcademicArticles/Librarys/RepositoryLibrary.sol

## Main

### Contract
Main : AcademicArticles/Main.sol

 --- 
### Functions:
inherits StateHandler:
### RegisterInstitution

```solidity
function RegisterInstitution(address[] institutionAccounts) public payable
```

### UnregisterInstitution

```solidity
function UnregisterInstitution(address[] institutionAccounts) public payable
```

### BindAuthenticator

```solidity
function BindAuthenticator(address[] authenticatorAccounts) public payable
```

### UnbindAuthenticator

```solidity
function UnbindAuthenticator(address[] authenticatorAccounts) public payable
```

### AuthenticateArticle

```solidity
function AuthenticateArticle(bytes32[] articleIds) public payable
```

### UnauthenticateArticle

```solidity
function UnauthenticateArticle(bytes32[] articleIds) public payable
```

### PostArticle

```solidity
function PostArticle(struct DelimitationLibrary.Article[] articleContents) public payable
```

### RemoveArticle

```solidity
function RemoveArticle(bytes32[] articleIds) public payable
```

inherits EventComplement:
inherits ModifierComplement:
inherits UtilsComplement:
### ArticleIdFromArticleContents

```solidity
function ArticleIdFromArticleContents(struct DelimitationLibrary.Article[] articleContents) internal pure returns (bytes32[] result)
```

### InstitutionOfAuthenticator

```solidity
function InstitutionOfAuthenticator(address authenticatorAccount) internal view returns (address result)
```

### IsInstitution_

```solidity
function IsInstitution_(address institutionAccount) internal view returns (bool result)
```

inherits ViewHandler:
### ArticleIds

```solidity
function ArticleIds(uint256 startIndex, uint256 endIndex, bool reverse) public view returns (bytes32[] result, uint256 size)
```

### ArticlePoster

```solidity
function ArticlePoster(bytes32[] articleIds) public view returns (address[] result)
```

### ArticleInstitution

```solidity
function ArticleInstitution(bytes32[] articleIds) public view returns (address[] result)
```

### ArticleContent

```solidity
function ArticleContent(bytes32[] articleIds) public view returns (struct DelimitationLibrary.Article[] result)
```

### InstitutionAccounts

```solidity
function InstitutionAccounts(uint256 startIndex, uint256 endIndex, bool reverse) public view returns (address[] result, uint256 size)
```

### InstitutionAuthenticators

```solidity
function InstitutionAuthenticators(address[] institutionAccounts, uint256 startIndex, uint256 endIndex, bool reverse) public view returns (address[][] result, uint256[] size)
```

inherits RepositoryComplement:
inherits IMain:
inherits IStateHandler:
inherits IViewHandler:

 --- 
### Events:
inherits StateHandler:
inherits EventComplement:
### InstitutionRegistered

```solidity
event InstitutionRegistered(address institutionAccount)
```

### InstitutionUnregistered

```solidity
event InstitutionUnregistered(address institutionAccount)
```

### AuthenticatorBinded

```solidity
event AuthenticatorBinded(address authenticatorAccount)
```

### AuthenticatorUnbinded

```solidity
event AuthenticatorUnbinded(address authenticatorAccount)
```

### ArticleAuthenticated

```solidity
event ArticleAuthenticated(bytes32 articleId)
```

### ArticleUnauthenticate

```solidity
event ArticleUnauthenticate(bytes32 articleId)
```

### ArticlePosted

```solidity
event ArticlePosted(bytes32 articleId)
```

### ArticleRemoved

```solidity
event ArticleRemoved(bytes32 articleId)
```

inherits ModifierComplement:
inherits UtilsComplement:
inherits ViewHandler:
inherits RepositoryComplement:
inherits IMain:
inherits IStateHandler:
inherits IViewHandler:

