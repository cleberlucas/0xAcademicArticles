# Solidity API

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

