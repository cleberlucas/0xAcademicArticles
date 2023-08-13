// SPDX-License-Identifier: AFL-3.0
import "AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract InstituitionRepository {
    constructor() {
        OWNER = msg.sender;
    }

    struct StoreData {
        address[] InstitutionID;
        mapping(address InstitutionID => AcademicLibrary.Institution) Institution;
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

    function showInstitutionID() public view returns (address[] memory InstitutionIDs) {
        return _storeData.InstitutionID;
    }

    function showInstitution(
        address InstitutionID
    ) public view returns (AcademicLibrary.Institution memory authority) {
        return _storeData.Institution[InstitutionID];
    }
    
    function registerInstitution(
        address InstitutionID,
        AcademicLibrary.Institution memory institution
    ) public payable IsOwner {
        _storeData.Institution[InstitutionID] = institution;
        _storeData.InstitutionID.push(InstitutionID);
    }

    function editInstitution(
        address InstitutionID,
        AcademicLibrary.Institution memory institution
    ) public payable IsOwner {
        _storeData.Institution[InstitutionID] = institution;
    }

    function unregisterInstitution(
        address InstitutionID
    ) public payable IsOwner {
        delete _storeData.Institution[InstitutionID];

        for (uint256 i = 0; i < _storeData.InstitutionID.length; i++) {
            if (_storeData.InstitutionID[i] == InstitutionID) {
                _storeData.InstitutionID[i] = _storeData.InstitutionID[
                    _storeData.InstitutionID.length - 1
                ];
                _storeData.InstitutionID.pop();
            }
        }
    }
}
