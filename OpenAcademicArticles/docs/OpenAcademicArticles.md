# Solidity API

## OpenAcademicArticles

### Contract
OpenAcademicArticles : OpenAcademicArticles/contracts/OpenAcademicArticles.sol

 --- 
### Functions:
### SIGNATURE

```solidity
function SIGNATURE() external pure returns (string signature)
```

### constructor

```solidity
constructor() public
```

### ConnectToAIO

```solidity
function ConnectToAIO(address account) external payable
```

### TransferAIOSignature

```solidity
function TransferAIOSignature(address newSender) external payable
```

### Publication

```solidity
function Publication(bytes32 publicationIdentification) external view returns (struct OpenAcademicArticles.Publication_Model publication)
```

### PreviewPublications

```solidity
function PreviewPublications(uint256 startIndex, uint256 endIndex) external view returns (struct OpenAcademicArticles.PublicationPreview_Model[] publicationsPreview, uint256 currentSize)
```

### PreviewPublicationsOfPublisher

```solidity
function PreviewPublicationsOfPublisher(address publicationPublisher, uint256 startIndex, uint256 endIndex) external view returns (struct OpenAcademicArticles.PublicationPreview_Model[] previewPublicationsOfPublisher, uint256 currentSize)
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

### ConnectedToAIO

```solidity
event ConnectedToAIO(address account)
```

### TransferredAIOSignature

```solidity
event TransferredAIOSignature(address newSender)
```

inherits IAIOSignature:

