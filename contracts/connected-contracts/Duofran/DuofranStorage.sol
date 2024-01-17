// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranStorageModel.sol";
import "../../interfaces/IAcademicArticles.sol";

abstract contract DuofranStorage {
    address internal immutable OWNER;
    IAcademicArticles internal _academicArticles;
    DuofranStorageModel.Publication internal _publication;
    DuofranStorageModel.Affiliate internal _affiliate;
    DuofranStorageModel.Me internal _me;
}