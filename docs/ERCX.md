# Solidity API

## ERCX

### Contract
ERCX : contracts/main/ERCX.sol

 --- 
### Functions:
inherits ERCXSearch:
### Tokens

```solidity
function Tokens(string signature) external view returns (bytes32[] tokens)
```

### Signature

```solidity
function Signature(bytes32 token) external view returns (string signature)
```

### MetaData

```solidity
function MetaData(bytes32 token) external view returns (bytes metadata)
```

### Senders

```solidity
function Senders() external view returns (address[] senders)
```

### Signature

```solidity
function Signature(address sender) external view returns (string signature)
```

### Sender

```solidity
function Sender(string signature) external view returns (address sender)
```

inherits ERCXInteract:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external payable
```

### CleanMetaData

```solidity
function CleanMetaData(bytes32 token) external payable
```

inherits ERCXInterconnection:
### Initialize

```solidity
function Initialize() external payable
```

### TransferSignature

```solidity
function TransferSignature(address newSender) external payable
```

inherits ERCXRules:
inherits ERCXStorage:
inherits IERCXSearch:
inherits IERCXInteract:
inherits IERCXInterconnection:

## ERCXInteract

### Contract
ERCXInteract : contracts/main/ERCXInteract.sol

 --- 
### Functions:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external payable
```

### CleanMetaData

```solidity
function CleanMetaData(bytes32 token) external payable
```

inherits ERCXRules:
inherits ERCXStorage:
inherits IERCXInteract:

## ERCXInterconnection

### Contract
ERCXInterconnection : contracts/main/ERCXInterconnection.sol

 --- 
### Functions:
### Initialize

```solidity
function Initialize() external payable
```

### TransferSignature

```solidity
function TransferSignature(address newSender) external payable
```

inherits ERCXRules:
inherits ERCXStorage:
inherits IERCXInterconnection:

## ERCXRules

### Contract
ERCXRules : contracts/main/ERCXRules.sol

 --- 
### Modifiers:
### OnlySenderSigned

```solidity
modifier OnlySenderSigned(struct ERCXStorageModel.Interconnection _interconnection)
```

### IsNotMetadataEmpty

```solidity
modifier IsNotMetadataEmpty(bytes metadata)
```

### IsNotSignedEmpty

```solidity
modifier IsNotSignedEmpty()
```

### IsNotSenderSigned

```solidity
modifier IsNotSenderSigned(struct ERCXStorageModel.Interconnection _interconnection)
```

### IsNotSignatureUsed

```solidity
modifier IsNotSignatureUsed(struct ERCXStorageModel.Interconnection _interconnection)
```

### IsNotMetadataSended

```solidity
modifier IsNotMetadataSended(struct ERCXStorageModel.Data _data, bytes32 token)
```

### IsMetadataSended

```solidity
modifier IsMetadataSended(struct ERCXStorageModel.Data _data, bytes32 token)
```

### IsMetadataSendedBySender

```solidity
modifier IsMetadataSendedBySender(struct ERCXStorageModel.Data _data, bytes32 token)
```

## ERCXSearch

### Contract
ERCXSearch : contracts/main/ERCXSearch.sol

 --- 
### Functions:
### Tokens

```solidity
function Tokens(string signature) external view returns (bytes32[] tokens)
```

### Signature

```solidity
function Signature(bytes32 token) external view returns (string signature)
```

### MetaData

```solidity
function MetaData(bytes32 token) external view returns (bytes metadata)
```

### Senders

```solidity
function Senders() external view returns (address[] senders)
```

### Signature

```solidity
function Signature(address sender) external view returns (string signature)
```

### Sender

```solidity
function Sender(string signature) external view returns (address sender)
```

inherits ERCXStorage:
inherits IERCXSearch:

## ERCXStorage

### Contract
ERCXStorage : contracts/main/ERCXStorage.sol

## IERCXInteract

### Contract
IERCXInteract : contracts/main/interfaces/IERCXInteract.sol

 --- 
### Functions:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external payable
```

### CleanMetaData

```solidity
function CleanMetaData(bytes32 token) external payable
```

## IERCXInterconnection

### Contract
IERCXInterconnection : contracts/main/interfaces/IERCXInterconnection.sol

 --- 
### Functions:
### Initialize

```solidity
function Initialize() external payable
```

### TransferSignature

```solidity
function TransferSignature(address newSender) external payable
```

## IERCXSearch

### Contract
IERCXSearch : contracts/main/interfaces/IERCXSearch.sol

 --- 
### Functions:
### Tokens

```solidity
function Tokens(string signature) external view returns (bytes32[] tokens)
```

### Signature

```solidity
function Signature(bytes32 token) external view returns (string signature)
```

### MetaData

```solidity
function MetaData(bytes32 token) external view returns (bytes metadata)
```

### Senders

```solidity
function Senders() external view returns (address[] senders)
```

### Signature

```solidity
function Signature(address sender) external view returns (string signature)
```

### Sender

```solidity
function Sender(string signature) external view returns (address sender)
```

## IERCXSignature

### Contract
IERCXSignature : contracts/main/interfaces/IERCXSignature.sol

 --- 
### Functions:
### SIGNATURE

```solidity
function SIGNATURE() external pure returns (string signature)
```

## ERCXLog

### Contract
ERCXLog : contracts/main/libs/ERCXLog.sol

 --- 
### Events:
### MetaDataSended

```solidity
event MetaDataSended(bytes32 token)
```

### MetaDataCleaned

```solidity
event MetaDataCleaned(bytes32 token)
```

### SenderSigned

```solidity
event SenderSigned(address sender)
```

### SignatureTransferred

```solidity
event SignatureTransferred(address newSender)
```

## ERCXMessage

### Contract
ERCXMessage : contracts/main/libs/ERCXMessage.sol

## ERCXStorageModel

### Contract
ERCXStorageModel : contracts/main/libs/ERCXStorageModel.sol

