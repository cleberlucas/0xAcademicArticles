// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ERCXLog.sol";
import "./interfaces/IERCXInteract.sol";
import "./ERCXStorage.sol";
import "./ERCXRules.sol";

 contract ERCXInteract is IERCXInteract, ERCXStorage, ERCXRules {
    function SendMetaData(bytes calldata metadata)
    external payable
    OnlySenderSigned(_interconnection)
    IsNotMetadataEmpty(metadata)
    IsNotMetadataSended(_data, keccak256(metadata)) {
        string memory signature = IERCXSignature(msg.sender).SIGNATURE();
        bytes32 token = keccak256(metadata);

        _data.tokens[signature].push(token);
        _data.signature[token] = signature;
        _data.metadata[token] = metadata;

        emit ERCXLog.MetaDataSended(token);
    }

    function CleanMetaData(bytes32 token)
    external payable
    OnlySenderSigned(_interconnection)
    IsMetadataSended(_data, token)
    IsMetadataSendedBySender(_data, token) {
        string memory signature = IERCXSignature(msg.sender).SIGNATURE();

        for (uint256 i = 0; i < _data.tokens[signature].length; i++) {
            if (_data.tokens[signature][i] == token) {
                _data.tokens[signature][i] = _data.tokens[signature][_data.tokens[signature].length - 1];
                _data.tokens[signature].pop();

                _data.signature[token] = "";
                _data.metadata[token] = new bytes(0);

                emit ERCXLog.MetaDataCleaned(token);
                return;
            }
        }
    }
}