// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./libs/ACARLog.sol";
import "./interfaces/IACARConnection.sol";
import "./interfaces/IACARInteract.sol";
import "./ACARStorage.sol";
import "./ACARRules.sol";

abstract contract ACARInteract is IACARInteract, ACARStorage, ACARRules {
    function PublishArticle(bytes calldata articleData)
    public payable
    OnlyContractConnected(_contract)
    IsNotArticleEmpty(articleData)
    IsNotArticlePublished(_article, keccak256(articleData)) {
        address contractAccount = msg.sender;
        address articlePublisher = tx.origin;
        bytes32 articleToken = keccak256(articleData);

        _article.tokens[contractAccount].push(articleToken);
        _article.contractAccount[articleToken] = contractAccount;
        _article.publisher[articleToken] = articlePublisher;
        _article.data[articleToken] = articleData;

        emit ACARLog.ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    OnlyContractConnected(_contract)
    IsArticlePublished(_article, articleToken)
    IsArticlePublishedByContract(_article, articleToken)
    IsArticlePublishedByMe(_article, articleToken) {
        address contractAccount = msg.sender;

        for (uint256 i = 0; i < _article.tokens[contractAccount].length; i++) {
            if (_article.tokens[contractAccount][i] == articleToken) {
                _article.tokens[contractAccount][i] = _article.tokens[contractAccount][_article.tokens[contractAccount].length - 1];
                _article.tokens[contractAccount].pop();

                emit ACARLog.ArticleUnpublished(articleToken);
                return;
            }
        }

        _article.contractAccount[articleToken] = address(0);
        _article.publisher[articleToken] = address(0);
        _article.data[articleToken] = new bytes(0);
    }

    function ConnectContract(address contractAccount)
    public payable
    OnlyOwner
    IsContractSigned(contractAccount)
    IsNotContractConnected(_contract, contractAccount) {
        _contract.accounts.push(contractAccount);
        _contract.signature[contractAccount] = IACARConnection(contractAccount).SIGNATURE();

        emit ACARLog.ContractConnected(contractAccount);
    }

    function DisconnectContract(address contractAccount)
    public payable
    OnlyOwner
    IsContractConnected(_contract, contractAccount) {
        IACARConnection(contractAccount).Wipe();  

        for (uint256 i = 0; i < _contract.accounts.length; i++) {
            if (_contract.accounts[i] == contractAccount) {
                bytes32[] storage articleTokens = _article.tokens[contractAccount];

                _article.tokens[contractAccount] = new bytes32[](0); 

                for (uint256 ii = 0; ii < articleTokens.length; ii++) {
                    bytes32 articleToken = articleTokens[ii];

                    _article.contractAccount[articleToken] = address(0);
                    _article.publisher[articleToken] = address(0);
                    _article.data[articleToken] = new bytes(0);
                }

                _contract.accounts[i] = _contract.accounts[_contract.accounts.length - 1];
                _contract.accounts.pop();
                _contract.signature[contractAccount]  = "";

                emit ACARLog.ContractDisconnected(contractAccount);
                return;
            }
        }

    }
}