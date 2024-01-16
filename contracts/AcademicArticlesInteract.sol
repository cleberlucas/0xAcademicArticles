// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./IAcademicArticlesInteract.sol";
import "./AcademicArticlesData.sol";
import "./AcademicArticlesRules.sol";
import "./AcademicArticlesLog.sol";

abstract contract AcademicArticlesInteract is IAcademicArticlesInteract, AcademicArticlesData, AcademicArticlesRules {

    function PublishArticle(bytes calldata articleEncoded)
    public payable
    IsConnected(_interconnection)
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
    IsConnected(_interconnection)
    IsArticlePublished(_article, articleToken)
    IsArticlePublishedByMe(_article, articleToken) {
        address interconnectionContract = msg.sender;

        _article.publisher[articleToken] = address(0);
        _article.encoded[articleToken] = new bytes(0);

        for (uint256 i = 0; i < _article.tokens[interconnectionContract].length; i++) {
            if (_article.tokens[interconnectionContract][i] == articleToken) {
                _article.tokens[interconnectionContract][i] = _article.tokens[interconnectionContract][_article.tokens[interconnectionContract].length - 1];
                _article.tokens[interconnectionContract].pop();
                emit AcademicArticlesLog.ArticleUnpublished(articleToken);
                return;
            }
        }
    }

    function ConnectContract(address interconnectionContract)
    public payable
    IsOwner
    IsEntryContract(interconnectionContract)
    IsNotContractConnected(_interconnection, interconnectionContract) {
        _interconnection.contracts.push(interconnectionContract);
        emit AcademicArticlesLog.ContractConnected(interconnectionContract);
    }

    function DisconnectContract(address interconnectionContract)
    public payable
    IsOwner
    IsContractConnected(_interconnection, interconnectionContract) {
        for (uint256 i = 0; i < _interconnection.contracts.length; i++) {
            if (_interconnection.contracts[i] == interconnectionContract) {
                _interconnection.contracts[i] = _interconnection.contracts[_interconnection.contracts.length - 1];
                _interconnection.contracts.pop();

                for (uint256 ii = 0; ii < _article.tokens[interconnectionContract].length; ii++) {
                    bytes32 articleToken = _article.tokens[interconnectionContract][ii];
                    _article.publisher[articleToken] = address(0);
                    _article.encoded[articleToken] = new bytes(0);
                }

                _article.tokens[interconnectionContract] = new bytes32[](0);

                emit AcademicArticlesLog.ContractDisconnected(interconnectionContract);
                return;
            }
        }
    }
}