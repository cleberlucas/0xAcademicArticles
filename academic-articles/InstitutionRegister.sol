// SPDX-License-Identifier: AFL-3.0
import "./AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract InstitutionRegister {
    constructor() {
        OWNER = msg.sender;
    }

    struct StoreData {
        address[] institutionID;
        mapping(address institutionID => AcademicLibrary.Institution) institution;
    }

    StoreData private _storeData;

    address private immutable OWNER;

    modifier IsOwner() {
        require(
            OWNER == msg.sender,
            "You must be the owner to perform this action"
        );
        _;
    }

    modifier IsRegisteredInstitution(address institutionID) {
        bool isRegisteredInstitution;

        for (uint256 i = 0; i < _storeData.institutionID.length; i++)
            if (_storeData.institutionID[i] == institutionID)
                isRegisteredInstitution = true;

        require(
            isRegisteredInstitution,
            "Do not hesitate to register an institution with this id"
        );
        _;
    }

    modifier IsNotRegisteredInstitution(address institutionID) {
        bool isNotRegisteredInstitution;
        isNotRegisteredInstitution = true;

        for (uint256 i = 0; i < _storeData.institutionID.length; i++)
            if (_storeData.institutionID[i] == institutionID)
                isNotRegisteredInstitution = false;

        require(
            isNotRegisteredInstitution,
            "There is already an id of an institution registered with the same id"
        );
        _;
    }

    function showInstitutionID()
        public
        view
        returns (address[] memory institutionID)
    {
        return _storeData.institutionID;
    }

    function showInstitution(
        address institutionID
    ) public view returns (AcademicLibrary.Institution memory authority) {
        return _storeData.institution[institutionID];
    }

    function registerInstitution(
        address institutionID,
        AcademicLibrary.Institution memory institution
    ) public payable IsOwner IsNotRegisteredInstitution(institutionID) {
        _storeData.institution[institutionID] = institution;
        _storeData.institutionID.push(institutionID);
    }

    function editInstitution(
        address institutionID,
        AcademicLibrary.Institution memory institution
    ) public payable IsOwner IsRegisteredInstitution(institutionID) {
        _storeData.institution[institutionID] = institution;
    }

    function unregisterInstitution(
        address institutionID
    ) public payable IsOwner IsRegisteredInstitution(institutionID) {
        delete _storeData.institution[institutionID];

        for (uint256 i = 0; i < _storeData.institutionID.length; i++) {
            if (_storeData.institutionID[i] == institutionID) {
                _storeData.institutionID[i] = _storeData.institutionID[
                    _storeData.institutionID.length - 1
                ];
                _storeData.institutionID.pop();
            }
        }
    }
}
