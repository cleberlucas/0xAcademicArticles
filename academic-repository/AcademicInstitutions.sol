// SPDX-License-Identifier: AFL-3.0
import "AcademicRepositoryLibrary.sol";

pragma solidity >=0.8.18;

contract AcademicRepository {
    constructor() {
        OWNER = msg.sender;
    }

    struct StoreData {
        address[] InstitutionIDs;
        mapping(address InstitutionID => Institution) Institutions;
    }

    struct Institution {
        string name;
        string country;
        string phone;
        string email;
        string website;
        string logo;
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

    function showInstitutionIDs() public view returns (address[] memory InstitutionIDs) {
        return _storeData.InstitutionIDs;
    }

    function showInstitution(
        address InstitutionID
    ) public view returns (Institution memory authority) {
        return _storeData.Institutions[InstitutionID];
    }
    
    function registerInstitution(
        address InstitutionID,
        Institution memory institution
    ) public payable IsOwner {
        _storeData.Institutions[InstitutionID] = institution;
        _storeData.InstitutionIDs.push(InstitutionID);
    }

    function unregisterInstitution(
        address InstitutionID
    ) public payable IsOwner {
        delete _storeData.Institutions[InstitutionID];

        for (uint256 i = 0; i < _storeData.InstitutionIDs.length; i++) {
            if (_storeData.InstitutionIDs[i] == InstitutionID) {
                _storeData.InstitutionIDs[i] = _storeData.InstitutionIDs[
                    _storeData.InstitutionIDs.length - 1
                ];
                _storeData.InstitutionIDs.pop();
            }
        }
    }
}
