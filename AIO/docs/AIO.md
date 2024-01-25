# Solidity API

## AIO

### Contract
AIO : AIO/contracts/AIO.sol

 --- 
### Functions:
inherits AIOSearch:
### Ids

```solidity
function Ids(string signature) external view returns (bytes32[] ids)
```

### Signature

```solidity
function Signature(bytes32 id) external view returns (string signature)
```

### MetaData

```solidity
function MetaData(bytes32 id) external view returns (bytes metadata)
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
function CleanMetaData(bytes32 id) external payable
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
AIOInteract : AIO/contracts/AIOInteract.sol

 --- 
### Functions:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external payable
```

### CleanMetaData

```solidity
function CleanMetaData(bytes32 id) external payable
```

inherits AIORules:
inherits AIOStorage:
inherits IAIOInteract:

## AIOInterconnection

### Contract
AIOInterconnection : AIO/contracts/AIOInterconnection.sol

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
AIORules : AIO/contracts/AIORules.sol

 --- 
### Modifiers:
### InitializeRule

```solidity
modifier InitializeRule(struct AIOStorageModel.Interconnection _interconnection)
```

### TransferSignatureRule

```solidity
modifier TransferSignatureRule(struct AIOStorageModel.Interconnection _interconnection, address newSender)
```

### SendMetaDataRule

```solidity
modifier SendMetaDataRule(struct AIOStorageModel.Interconnection _interconnection, struct AIOStorageModel.Token _token, bytes metadata)
```

### CleanMetaDataRule

```solidity
modifier CleanMetaDataRule(struct AIOStorageModel.Interconnection _interconnection, struct AIOStorageModel.Token _token, bytes32 id)
```

## AIOSearch

### Contract
AIOSearch : AIO/contracts/AIOSearch.sol

 --- 
### Functions:
### Ids

```solidity
function Ids(string signature) external view returns (bytes32[] ids)
```

### Signature

```solidity
function Signature(bytes32 id) external view returns (string signature)
```

### MetaData

```solidity
function MetaData(bytes32 id) external view returns (bytes metadata)
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
AIOStorage : AIO/contracts/AIOStorage.sol

## IAIOInteract

### Contract
IAIOInteract : AIO/contracts/interfaces/IAIOInteract.sol

 --- 
### Functions:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external payable
```

### CleanMetaData

```solidity
function CleanMetaData(bytes32 id) external payable
```

## IAIOInterconnection

### Contract
IAIOInterconnection : AIO/contracts/interfaces/IAIOInterconnection.sol

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
IAIOSearch : AIO/contracts/interfaces/IAIOSearch.sol

 --- 
### Functions:
### Ids

```solidity
function Ids(string signature) external view returns (bytes32[] ids)
```

### Signature

```solidity
function Signature(bytes32 id) external view returns (string signature)
```

### MetaData

```solidity
function MetaData(bytes32 id) external view returns (bytes metadata)
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
IAIOSignature : AIO/contracts/interfaces/IAIOSignature.sol

 --- 
### Functions:
### SIGNATURE

```solidity
function SIGNATURE() external pure returns (string signature)
```

## AIOLog

### Contract
AIOLog : AIO/contracts/libs/AIOLog.sol

 --- 
### Events:
### MetadataSended

```solidity
event MetadataSended(bytes32 id)
```

### MetadataCleaned

```solidity
event MetadataCleaned(bytes32 id)
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
AIOMessage : AIO/contracts/libs/AIOMessage.sol

## AIOStorageModel

### Contract
AIOStorageModel : AIO/contracts/libs/AIOStorageModel.sol

