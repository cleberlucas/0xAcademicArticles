// SPDX-License-Identifier: MIT

import "./RepositoryLib.sol";

pragma solidity ^0.8.23;

abstract contract RepositoryExt {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;

    RepositoryLib.Article _article;
    RepositoryLib.Institution _institution;
}
