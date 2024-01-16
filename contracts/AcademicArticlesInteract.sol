// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./IAcademicArticlesInteract.sol";
import "./AcademicArticlesData.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

abstract contract AcademicArticlesInteract is IAcademicArticlesInteract, AcademicArticlesData, AcademicArticlesRules {

    function PublishArticle(bytes calldata articleEncoded)
    public payable
    IsConnected(_connected)
    IsNotEntryEncodedEmpty(articleEncoded)
    IsNotArticlePublished(_article, keccak256(articleEncoded)) {
        address articlePublisher = tx.origin;
        bytes32 articleToken = keccak256(articleEncoded);

        _article.tokens[articlePublisher].push(articleToken);
        _article.publisher[articleToken] = articlePublisher;
        _article.encoded[articleToken] = articleEncoded;

        emit AcademicArticlesLog.ArticlePublished(articleToken);
    }

    function UnpublishArticle(bytes32 articleToken)
    public payable
    IsConnected(_connected)
    IsArticlePublished(_article, articleToken)
    IsArticlePublishedByMe(_article, articleToken) {
        address connectedContract = msg.sender;

        _article.publisher[articleToken] = address(0);
        _article.encoded[articleToken] = new bytes(0);

        for (uint256 i = 0; i < _article.tokens[connectedContract].length; i++) {
            if (_article.tokens[connectedContract][i] == articleToken) {
                _article.tokens[connectedContract][i] = _article.tokens[connectedContract][_article.tokens[connectedContract].length - 1];
                _article.tokens[connectedContract].pop();
                emit AcademicArticlesLog.ArticleUnpublished(articleToken);
                return;
            }
        }
    }

    function ConnectContract(address connectedContract)
    public payable
    IsOwner
    IsEntryContract(connectedContract)
    IsNotContractConnected(_connected, connectedContract) {
        _connected.contracts.push(connectedContract);
        emit AcademicArticlesLog.ContractConnected(connectedContract);
    }

    function DisconnectContract(address connectedContract)
    public payable
    IsOwner
    IsContractConnected(_connected, connectedContract) {
        for (uint256 i = 0; i < _connected.contracts.length; i++) {
            if (_connected.contracts[i] == connectedContract) {
                _connected.contracts[i] = _connected.contracts[_connected.contracts.length - 1];
                _connected.contracts.pop();

                for (uint256 ii = 0; ii < _article.tokens[connectedContract].length; ii++) {
                    bytes32 articleToken = _article.tokens[connectedContract][ii];
                    _article.publisher[articleToken] = address(0);
                    _article.encoded[articleToken] = new bytes(0);
                }

                _article.tokens[connectedContract] = new bytes32[](0);

                emit AcademicArticlesLog.ContractDisconnected(connectedContract);
                return;
            }
        }
    }
}