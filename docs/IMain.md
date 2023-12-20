# Solidity API

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

