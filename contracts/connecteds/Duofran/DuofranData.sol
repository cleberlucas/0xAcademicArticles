// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranDataModel.sol";
import "../../IAcademicArticles.sol";

abstract contract DuofranData {
    address internal immutable OWNER;
    IAcademicArticles internal _academicArticles;
    DuofranDataModel.Publication internal _publication;
    DuofranDataModel.Affiliate internal _affiliate;
    DuofranDataModel.Me internal _me;
}