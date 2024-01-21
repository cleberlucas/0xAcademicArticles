# Solidity API

## AIO

### Contract
AIO : contracts/AIO/AIO.sol

 --- 
### Functions:
inherits AIOSearch:
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

inherits AIOInteract:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external payable
```

### CleanMetaData

```solidity
function CleanMetaData(bytes32 token) external payable
```

inherits AIOInterconnection:
### Initialize

```solidity
function Initialize() external payable
```

### TransferSignature

```solidity
function TransferSignature(address newSender) external payable
```

inherits AIORules:
inherits AIOStorage:
inherits IAIOSearch:
inherits IAIOInteract:
inherits IAIOInterconnection:

## AIOInteract

### Contract
AIOInteract : contracts/AIO/AIOInteract.sol

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

inherits AIORules:
inherits AIOStorage:
inherits IAIOInteract:

## AIOInterconnection

### Contract
AIOInterconnection : contracts/AIO/AIOInterconnection.sol

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

inherits AIORules:
inherits AIOStorage:
inherits IAIOInterconnection:

## AIORules

### Contract
AIORules : contracts/AIO/AIORules.sol

 --- 
### Modifiers:
### OnlySenderSigned

```solidity
modifier OnlySenderSigned(struct AIOStorageModel.Interconnection _interconnection)
```

### EntryNotMetadataEmpty

```solidity
modifier EntryNotMetadataEmpty(bytes metadata)
```

### EntryNotSignedEmpty

```solidity
modifier EntryNotSignedEmpty()
```

### EntryNewSenderSameSignature

```solidity
modifier EntryNewSenderSameSignature(address newSender)
```

### IsNotSenderSigned

```solidity
modifier IsNotSenderSigned(struct AIOStorageModel.Interconnection _interconnection)
```

### IsNotSignatureUsed

```solidity
modifier IsNotSignatureUsed(struct AIOStorageModel.Interconnection _interconnection)
```

### IsNotMetadataSended

```solidity
modifier IsNotMetadataSended(struct AIOStorageModel.Data _data, bytes32 token)
```

### IsMetadataSended

```solidity
modifier IsMetadataSended(struct AIOStorageModel.Data _data, bytes32 token)
```

### IsMetadataSendedBySender

```solidity
modifier IsMetadataSendedBySender(struct AIOStorageModel.Data _data, struct AIOStorageModel.Interconnection _interconnection, bytes32 token)
```

## AIOSearch

### Contract
AIOSearch : contracts/AIO/AIOSearch.sol

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

inherits AIOStorage:
inherits IAIOSearch:

## AIOStorage

### Contract
AIOStorage : contracts/AIO/AIOStorage.sol

## IAIOInteract

### Contract
IAIOInteract : contracts/AIO/interfaces/IAIOInteract.sol

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

## IAIOInterconnection

### Contract
IAIOInterconnection : contracts/AIO/interfaces/IAIOInterconnection.sol

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

## IAIOSearch

### Contract
IAIOSearch : contracts/AIO/interfaces/IAIOSearch.sol

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

## IAIOSignature

### Contract
IAIOSignature : contracts/AIO/interfaces/IAIOSignature.sol

 --- 
### Functions:
### SIGNATURE

```solidity
function SIGNATURE() external pure returns (string signature)
```

## AIOLog

### Contract
AIOLog : contracts/AIO/libs/AIOLog.sol

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

## AIOMessage

### Contract
AIOMessage : contracts/AIO/libs/AIOMessage.sol

## AIOStorageModel

### Contract
AIOStorageModel : contracts/AIO/libs/AIOStorageModel.sol

