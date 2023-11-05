// SPDX-License-Identifier: AFL-3.0
import "../Librarys/DelimitationLibrary.sol";
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >=0.8.22;

abstract contract RepositoryExtension {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;

    RepositoryLibrary.Article _article;
    RepositoryLibrary.Institution _institution;
}
