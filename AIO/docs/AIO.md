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

_Retrieves the IDs associated with a given signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| ids | bytes32[] | An array of IDs associated with the provided signature. |

### Signature

```solidity
function Signature(bytes32 id) external view returns (string signature)
```

_Retrieves the signature associated with a given ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature associated with the provided ID. |

### MetaData

```solidity
function MetaData(bytes32 id) external view returns (bytes metadata)
```

_Retrieves the metadata associated with a given ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| metadata | bytes | The metadata associated with the provided ID. |

### Senders

```solidity
function Senders() external view returns (address[] senders)
```

_Retrieves the array of all senders registered in the AIO system._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| senders | address[] | An array containing all registered senders. |

### Signature

```solidity
function Signature(address sender) external view returns (string signature)
```

_Retrieves the signature associated with a given sender's address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The sender's address to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature associated with the provided sender's address. |

### Sender

```solidity
function Sender(string signature) external view returns (address sender)
```

_Retrieves the sender's address associated with a given signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The sender's address associated with the provided signature. |

inherits AIOInteract:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external
```

_Sends metadata to the AIO contract._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| metadata | bytes | The metadata to be sent. |

### CleanMetaData

```solidity
function CleanMetaData(bytes32 id) external
```

_Cleans metadata based on its ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID of the metadata to be cleaned. |

inherits AIOInterconnection:
### Initialize

```solidity
function Initialize() external
```

_Initializes the sender by signing with a unique signature._

### TransferSignature

```solidity
function TransferSignature(address newSender) external
```

_Transfers the signature from the old sender to the new sender._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newSender | address | The address of the new sender. |

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
function SendMetaData(bytes metadata) external
```

_Sends metadata to the AIO contract._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| metadata | bytes | The metadata to be sent. |

### CleanMetaData

```solidity
function CleanMetaData(bytes32 id) external
```

_Cleans metadata based on its ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID of the metadata to be cleaned. |

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
function Initialize() external
```

_Initializes the sender by signing with a unique signature._

### TransferSignature

```solidity
function TransferSignature(address newSender) external
```

_Transfers the signature from the old sender to the new sender._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newSender | address | The address of the new sender. |

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

_Modifier for initializing the sender's signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _interconnection | struct AIOStorageModel.Interconnection | The storage instance for interconnection-related data. |

### TransferSignatureRule

```solidity
modifier TransferSignatureRule(struct AIOStorageModel.Interconnection _interconnection, address newSender)
```

_Modifier for transferring the signature from the old sender to the new sender._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _interconnection | struct AIOStorageModel.Interconnection | The storage instance for interconnection-related data. |
| newSender | address | The address of the new sender. |

### SendMetaDataRule

```solidity
modifier SendMetaDataRule(struct AIOStorageModel.Interconnection _interconnection, struct AIOStorageModel.Token _token, bytes metadata)
```

_Modifier for sending metadata._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _interconnection | struct AIOStorageModel.Interconnection | The storage instance for interconnection-related data. |
| _token | struct AIOStorageModel.Token | The storage instance for token-related data. |
| metadata | bytes | The metadata to be sent. |

### CleanMetaDataRule

```solidity
modifier CleanMetaDataRule(struct AIOStorageModel.Interconnection _interconnection, struct AIOStorageModel.Token _token, bytes32 id)
```

_Modifier for cleaning metadata._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _interconnection | struct AIOStorageModel.Interconnection | The storage instance for interconnection-related data. |
| _token | struct AIOStorageModel.Token | The storage instance for token-related data. |
| id | bytes32 | The ID of the metadata to be cleaned. |

## AIOSearch

### Contract
AIOSearch : AIO/contracts/AIOSearch.sol

 --- 
### Functions:
### Ids

```solidity
function Ids(string signature) external view returns (bytes32[] ids)
```

_Retrieves the IDs associated with a given signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| ids | bytes32[] | An array of IDs associated with the provided signature. |

### Signature

```solidity
function Signature(bytes32 id) external view returns (string signature)
```

_Retrieves the signature associated with a given ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature associated with the provided ID. |

### MetaData

```solidity
function MetaData(bytes32 id) external view returns (bytes metadata)
```

_Retrieves the metadata associated with a given ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| metadata | bytes | The metadata associated with the provided ID. |

### Senders

```solidity
function Senders() external view returns (address[] senders)
```

_Retrieves the array of all senders registered in the AIO system._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| senders | address[] | An array containing all registered senders. |

### Signature

```solidity
function Signature(address sender) external view returns (string signature)
```

_Retrieves the signature associated with a given sender's address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The sender's address to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature associated with the provided sender's address. |

### Sender

```solidity
function Sender(string signature) external view returns (address sender)
```

_Retrieves the sender's address associated with a given signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature to query. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The sender's address associated with the provided signature. |

inherits AIOStorage:
inherits IAIOSearch:

## AIOStorage

### Contract
AIOStorage : AIO/contracts/AIOStorage.sol

## IAIOInteract

Interface defining functions for sending and cleaning metadata in the AIO (All In One) system.

### Contract
IAIOInteract : AIO/contracts/interfaces/IAIOInteract.sol

 --- 
### Functions:
### SendMetaData

```solidity
function SendMetaData(bytes metadata) external
```

_Sends metadata in the AIO system._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| metadata | bytes | The metadata to be sent. |

### CleanMetaData

```solidity
function CleanMetaData(bytes32 id) external
```

_Cleans metadata associated with a specific ID in the AIO system._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The ID of the metadata to be cleaned. |

## IAIOInterconnection

Interface defining functions for initializing and transferring signatures in the AIO (All In One) system.

### Contract
IAIOInterconnection : AIO/contracts/interfaces/IAIOInterconnection.sol

 --- 
### Functions:
### Initialize

```solidity
function Initialize() external
```

_Initializes the sender by signing them up in the AIO system._

### TransferSignature

```solidity
function TransferSignature(address newSender) external
```

_Transfers the signature from the current sender to a new sender._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newSender | address | The address of the new sender. |

## IAIOSearch

Interface for searching and retrieving information related to the AIO (All In One) system.

### Contract
IAIOSearch : AIO/contracts/interfaces/IAIOSearch.sol

 --- 
### Functions:
### Ids

```solidity
function Ids(string signature) external view returns (bytes32[] ids)
```

_Get the unique identifiers (IDs) associated with a given signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature for which IDs are to be retrieved. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| ids | bytes32[] | An array of unique identifiers (IDs) associated with the given signature. |

### Signature

```solidity
function Signature(bytes32 id) external view returns (string signature)
```

_Get the signature associated with a specific ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The unique identifier (ID) for which the associated signature is to be retrieved. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature associated with the given ID. |

### MetaData

```solidity
function MetaData(bytes32 id) external view returns (bytes metadata)
```

_Get the metadata associated with a specific ID._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The unique identifier (ID) for which the associated metadata is to be retrieved. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| metadata | bytes | The metadata associated with the given ID. |

### Senders

```solidity
function Senders() external view returns (address[] senders)
```

_Get the list of all senders in the AIO system._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| senders | address[] | An array containing all sender addresses in the AIO system. |

### Signature

```solidity
function Signature(address sender) external view returns (string signature)
```

_Get the signature associated with a specific sender address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address for which the associated signature is to be retrieved. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature associated with the given sender address. |

### Sender

```solidity
function Sender(string signature) external view returns (address sender)
```

_Get the sender address associated with a specific signature._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | The signature for which the associated sender address is to be retrieved. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The sender address associated with the given signature. |

## IAIOSignature

This interface defines a function to retrieve a fixed signature associated with the sender.

_This interface should be inherited by the sender contract._

### Contract
IAIOSignature : AIO/contracts/interfaces/IAIOSignature.sol

This interface should be inherited by the sender contract.

 --- 
### Functions:
### SIGNATURE

```solidity
function SIGNATURE() external pure returns (string signature)
```

_Returns a fixed signature for the sender that the AIO contract will read later to use as
the signature for its initialization and transfer._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| signature | string | A string representing the fixed signature of the sender. |

## AIOLog

Library for logging events related to the AIO (All In One) system.

### Contract
AIOLog : AIO/contracts/libs/AIOLog.sol

 --- 
### Events:
### MetadataSended

```solidity
event MetadataSended(bytes32 id)
```

_Emitted when metadata is successfully sent._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The unique identifier of the metadata. |

### MetadataCleaned

```solidity
event MetadataCleaned(bytes32 id)
```

_Emitted when metadata is successfully cleaned._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| id | bytes32 | The unique identifier of the cleaned metadata. |

### SenderSigned

```solidity
event SenderSigned(address sender)
```

_Emitted when a new sender is successfully signed._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| sender | address | The address of the newly signed sender. |

### SignatureTransferred

```solidity
event SignatureTransferred(address newSender)
```

_Emitted when a signature is successfully transferred to a new sender._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newSender | address | The address of the new sender who now holds the signature. |

## AIOMessage

Library for defining standardized error messages in the AIO (All In One) system.

### Contract
AIOMessage : AIO/contracts/libs/AIOMessage.sol

## AIOStorageModel

Library defining the storage model for the AIO (All In One) system.

### Contract
AIOStorageModel : AIO/contracts/libs/AIOStorageModel.sol

