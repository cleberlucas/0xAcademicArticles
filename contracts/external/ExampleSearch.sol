// SPDX-License-Identifier: MIT

// Created by Cleber Lucas

import "./ExampleData.sol";
import "./ExampleModel.sol";

pragma solidity ^0.8.23;

abstract contract ExampleSearch is ExampleData {
    function Publication(bytes32 articleIdentification) public view returns (ExampleModel.Publication memory publication) {

    publication = ExampleModel.Publication(
        abi.decode(_academicArticles.ArticleEncode(articleIdentification, CONTRACT), (ExampleModel.Article)),
        articleIdentification,
        _publication.publisher[articleIdentification],
        _publication.datatime[articleIdentification],
        _publication.valid[articleIdentification]
    );
}


    function PreviewPublications(uint256 startIndex, uint256 endIndex) public view returns (ExampleModel.PublicationPreview[] memory publicationsPreview, uint256 currentSize) {
        currentSize = _publication.identifications.length;

        if (startIndex >= currentSize || startIndex > endIndex) {
            publicationsPreview = new ExampleModel.PublicationPreview[](0);
        } else {
            uint256 size = endIndex - startIndex + 1;
            uint256 correctedSize = (size <= currentSize - startIndex) ? size : currentSize - startIndex;

            publicationsPreview = new ExampleModel.PublicationPreview[](correctedSize);

            for (uint256 i = 0; i < correctedSize; i++) {
                publicationsPreview[i] = ExampleModel.PublicationPreview(
                    abi.decode(_academicArticles.ArticleEncode(_publication.identifications[startIndex + i], CONTRACT), (ExampleModel.Article)).title,
                    _publication.valid[_publication.identifications[startIndex + i]]
                );
            }
        }
    }
}