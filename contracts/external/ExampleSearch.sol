// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleData.sol";
import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleSearch is ExampleData {
    function Publication(bytes32 articleIdentification) public view returns (ExampleModel.Publication memory result) {
        result = _publication.publication[articleIdentification];
    }

    function PreviewPublications(uint256 startIndex, uint256 endIndex) public view returns (ExampleModel.PublicationPreview[] memory result, uint256 currentSize) {
        currentSize = _publication.articleIdentifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            result = new ExampleModel.PublicationPreview[](0);
        } else {
            uint256 size = endIndex - startIndex + 1;
            uint256 correctedSize = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            result = new ExampleModel.PublicationPreview[](correctedSize);

            for (uint256 i = 0; i < correctedSize; i++) {
                result[i] = ExampleModel.PublicationPreview(
                    _publication.publication[_publication.articleIdentifications[startIndex + i]].content.title,
                    _publication.publication[_publication.articleIdentifications[startIndex + i]].valid
                );
            }
        }
    }
}