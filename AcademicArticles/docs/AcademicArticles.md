# Solidity API

## AcademicArticles

### Contract
AcademicArticles : AcademicArticles/contracts/AcademicArticles.sol

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
function Publication(bytes32 id) external view returns (struct AcademicArticles.Publication_Model publication)
```

### PreviewPublications

```solidity
function PreviewPublications(uint256 startIndex, uint256 endIndex) external view returns (struct AcademicArticles.PublicationPreview_Model[] publicationsPreview, uint256 currentSize)
```

### PreviewPublicationsOfPublisher

```solidity
function PreviewPublicationsOfPublisher(address publicationPublisher, uint256 startIndex, uint256 endIndex) external view returns (struct AcademicArticles.PublicationPreview_Model[] previewPublicationsOfPublisher, uint256 currentSize)
```

### PublishArticles

```solidity
function PublishArticles(struct AcademicArticles.Article_Model[] articles) external payable
```

### UnpublishArticles

```solidity
function UnpublishArticles(bytes32[] ids) external payable
```

inherits IAIOSignature:

 --- 
### Events:
### ArticlesPublished

```solidity
event ArticlesPublished(bytes32[] ids)
```

### ArticlesUnpublished

```solidity
event ArticlesUnpublished(bytes32[] ids)
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

