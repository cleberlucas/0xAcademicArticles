# Solidity API

## OpenAcademicArticles

### Contract
OpenAcademicArticles : OpenAcademicArticles/contracts/OpenAcademicArticles.sol

 --- 
### Functions:
### constructor

```solidity
constructor(address aio) public
```

### ConnectToAIO

```solidity
function ConnectToAIO() external payable
```

### TransferSignature

```solidity
function TransferSignature(address newSender) external payable
```

### SIGNATURE

```solidity
function SIGNATURE() external pure returns (string signature)
```

### PublicationIdentifications

```solidity
function PublicationIdentifications() external view returns (bytes32[] publicationIdentifications)
```

### PublicationPublishers

```solidity
function PublicationPublishers() external view returns (address[] publicationPublishers)
```

### PublicationIdentificationsOfPublisher

```solidity
function PublicationIdentificationsOfPublisher(address publicationPublisher) external view returns (bytes32[] publicationIdentificationsOfPublisher)
```

### Publication

```solidity
function Publication(bytes32 publicationIdentification) external view returns (struct OpenAcademicArticles.Publication_Model publication)
```

### PreviewPublications

```solidity
function PreviewPublications(uint256 startIndex, uint256 endIndex) external view returns (struct OpenAcademicArticles.PublicationPreview_Model[] publicationsPreview, uint256 currentSize)
```

### PublishArticles

```solidity
function PublishArticles(struct OpenAcademicArticles.Article_Model[] articles) external payable
```

### UnpublishArticles

```solidity
function UnpublishArticles(bytes32[] publicationIdentifications) external payable
```

inherits IAIOSignature:

 --- 
### Events:
### ArticlesPublished

```solidity
event ArticlesPublished(bytes32[] publicationIdentifications)
```

### ArticlesUnpublished

```solidity
event ArticlesUnpublished(bytes32[] publicationIdentifications)
```

inherits IAIOSignature:

