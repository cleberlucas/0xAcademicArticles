// SPDX-License-Identifier: AFL-3.0
import "AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract FinalProjectRepository {
    constructor() {
        OWNER = msg.sender;
    }

    address private immutable OWNER;

    struct PostID {
        address posterID;
        uint256 sequence;
    }

    struct StoreData {
        PostID[] postID;
        address[] institutionID;
        mapping(address posterID => uint256 sequence) nextSequence;
        mapping(address posterID => mapping(uint256 sequence => AcademicLibrary.FinalProject)) finalProject;
    }

    StoreData private _storeData;

    event FinalProjecthRegistered(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.FinalProject Data
    );

    event FinalProjecthEdited(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.FinalProject Data
    );

    event FinalProjecthUnRegistered(
        address indexed posterID,
        uint256 indexed sequence
    );

    event FinalProjecthAuthenticated(
        address indexed posterID,
        uint256 indexed sequence,
        address indexed institution
    );

    modifier IsOwner() {
        require(
            OWNER == msg.sender,
            "You must be the owner to perform this action"
        );
        _;
    }

    modifier IsInstitution() {
        bool isInstitution;

        for (uint256 i = 0; i < _storeData.institutionID.length; i++)
            if (_storeData.institutionID[i] == msg.sender) isInstitution = true;

        require(
            isInstitution,
            "You must be the institution to perform this action"
        );
        _;
    }

    modifier IsRegistered(address posterID, uint256 sequence) {
        require(
            keccak256(
                abi.encodePacked(
                    (_storeData.finalProject[posterID][sequence].title)
                )
            ) != keccak256(abi.encodePacked((""))),
            "It is not possible to execute this action because the post register do not exist"
        );
        _;
    }

    modifier ValidateFinalProject(
        AcademicLibrary.FinalProject memory finalProject
    ) {
        require(
            keccak256(abi.encodePacked((finalProject.title))) !=
                keccak256(abi.encodePacked((""))),
            "Title cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((finalProject.summary))) !=
                keccak256(abi.encodePacked((""))),
            "Summary cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((finalProject.authors))) !=
                keccak256(abi.encodePacked((""))),
            "Authors cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((finalProject.advisors))) !=
                keccak256(abi.encodePacked((""))),
            "Advisors cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((finalProject.course))) !=
                keccak256(abi.encodePacked((""))),
            "Course cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((finalProject.institution))) !=
                keccak256(abi.encodePacked((""))),
            "Institution cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((finalProject.link))) !=
                keccak256(abi.encodePacked((""))),
            "Link cannot be empty"
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

    function registerInstitutionID(
        address institutionID
    ) public payable IsOwner {
        _storeData.institutionID.push(institutionID);
    }

    function unregisterInstitutionID(
        address institutionID
    ) public payable IsOwner {
        for (uint256 i = 0; i < _storeData.institutionID.length; i++) {
            if (_storeData.institutionID[i] == institutionID) {
                _storeData.institutionID[i] = _storeData.institutionID[
                    _storeData.institutionID.length - 1
                ];
                _storeData.institutionID.pop();
            }
        }
    }

    function showPostID() public view returns (PostID[] memory postID) {
        return _storeData.postID;
    }

    function authenticateFinalProject(
        address posterId,
        uint256 sequence
    ) public IsRegistered(posterId, sequence) IsInstitution() {
        _storeData.finalProject[posterId][sequence].authenticated = msg
            .sender;

        emit FinalProjecthAuthenticated(posterId, sequence, msg.sender);
    }

    function showFinalProject(
        PostID memory postID
    )
        public
        view
        returns (AcademicLibrary.FinalProject memory finalProject)
    {
        return _storeData.finalProject[postID.posterID][postID.sequence];
    }

    function editFinalProject(
        uint256 sequence,
        AcademicLibrary.FinalProject memory finalProject
    )
        public
        IsRegistered(msg.sender, sequence)
        ValidateFinalProject(finalProject)
    {
        finalProject.authenticated = address(0);
        _storeData.finalProject[msg.sender][sequence] = finalProject;

        emit FinalProjecthEdited(msg.sender, sequence, finalProject);
    }

    function registerFinalProject(
        AcademicLibrary.FinalProject memory finalProject
    ) public ValidateFinalProject(finalProject) {
        address posterID = msg.sender;
        uint256 sequence = _storeData.nextSequence[posterID];
        _storeData.finalProject[posterID][sequence] = finalProject;
        _storeData.postID.push(PostID(msg.sender, sequence));
        _storeData.nextSequence[posterID]++;

        emit FinalProjecthRegistered(
            posterID,
            sequence,
            finalProject
        );
    }

    function unregisterFinalProject(uint256 sequence) public {
        address posterID = msg.sender;

        delete _storeData.finalProject[posterID][sequence];

        for (uint256 i = 0; i < _storeData.postID.length; i++) {
            if (
                _storeData.postID[i].posterID == msg.sender &&
                _storeData.postID[i].sequence == sequence
            ) {
                _storeData.postID[i] = _storeData.postID[
                    _storeData.postID.length - 1
                ];
                _storeData.postID.pop();
            }
        }

        emit FinalProjecthUnRegistered(posterID, sequence);
    }
}
