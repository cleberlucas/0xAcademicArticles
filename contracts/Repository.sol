// SPDX-License-Identifier: MIT

import "./DataLib.sol";

pragma solidity ^0.8.23;

abstract contract Repository {
    constructor() {
        OWNER = msg.sender;
    }

    address internal immutable OWNER;

    DataLib.Article _article;
    DataLib.Institution _institution;
}
