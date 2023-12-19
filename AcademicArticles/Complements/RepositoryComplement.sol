// SPDX-License-Identifier: MIT
import "../Librarys/RepositoryLibrary.sol";

pragma solidity >=0.8.22;

abstract contract RepositoryComplement {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;

    RepositoryLibrary.Article _article;
    RepositoryLibrary.Institution _institution;
}
