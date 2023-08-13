// SPDX-License-Identifier: AFL-3.0
import "./AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract FinalProjectRepository {
    constructor() {
        OWNER = msg.sender;
    }

    address private immutable OWNER;

    struct FinalProjectID {
        address posterID;
        uint256 sequence;
    }

    struct StoreData {
        address[] institutionID;
        FinalProjectID[] finalProjectID;
        mapping(address posterID => uint256 sequence) nextSequence;
        mapping(address posterID => mapping(uint256 sequence => AcademicLibrary.FinalProject)) finalProject;
    }

    StoreData private _storeData;

    event FinalProjectRegistered(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.FinalProject finalProject
    );

    event FinalProjectEdited(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.FinalProject finalProject
    );

    event FinalProjectUnRegistered(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.FinalProject finalProject
    );

    event FinalProjectAuthenticated(
        address indexed posterID,
        uint256 indexed sequence,
        address indexed authenticator
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

    modifier IsNotAuthenticated(address posterID, uint256 sequence) {
        require(
            _storeData.finalProject[posterID][sequence].authenticated ==
                address(0),
            "It will not be possible to authenticate because it is already authenticated"
        );
        _;
    }

    modifier ExistInstitutionID(address institutionID) {
        bool exitsInstitutionID;

        for (uint256 i = 0; i < _storeData.institutionID.length; i++)
            if (_storeData.institutionID[i] == institutionID)
                exitsInstitutionID = true;

        require(
            exitsInstitutionID,
            "Do not hesitate to register an institution with this id"
        );
        _;
    }

    modifier NotExistInstitutionID(address institutionID) {
        bool notExitsInstitutionID;
        notExitsInstitutionID = true;

        for (uint256 i = 0; i < _storeData.institutionID.length; i++)
            if (_storeData.institutionID[i] == institutionID)
                notExitsInstitutionID = false;

        require(
            notExitsInstitutionID,
            "There is already an id of an institution registered with the same id"
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
    ) public payable IsOwner NotExistInstitutionID(institutionID) {
        _storeData.institutionID.push(institutionID);
    }

    function unregisterInstitutionID(
        address institutionID
    ) public payable IsOwner ExistInstitutionID(institutionID) {
        for (uint256 i = 0; i < _storeData.institutionID.length; i++) {
            if (_storeData.institutionID[i] == institutionID) {
                _storeData.institutionID[i] = _storeData.institutionID[
                    _storeData.institutionID.length - 1
                ];
                _storeData.institutionID.pop();
            }
        }
    }

    function showFinalProjectID()
        public
        view
        returns (FinalProjectID[] memory finalProjectID)
    {
        return _storeData.finalProjectID;
    }

    function authenticateFinalProject(
        address posterId,
        uint256 sequence
    )
        public
        payable
        IsRegistered(posterId, sequence)
        IsNotAuthenticated(posterId, sequence)
        IsInstitution
    {
        _storeData.finalProject[posterId][sequence].authenticated = msg.sender;

        emit FinalProjectAuthenticated(posterId, sequence, msg.sender);
    }

    function showFinalProject(
        FinalProjectID memory finalProjectID
    ) public view returns (AcademicLibrary.FinalProject memory finalProject) {
        return
            _storeData.finalProject[finalProjectID.posterID][
                finalProjectID.sequence
            ];
    }

    function editFinalProject(
        uint256 sequence,
        string memory title,
        string memory summary,
        string memory authors,
        string memory advisors,
        string memory course,
        string memory institution,
        string memory link
    )
        public
        payable
        ValidateFinalProject(
            AcademicLibrary.FinalProject(
                title,
                summary,
                authors,
                advisors,
                course,
                institution,
                link,
                address(0)
            )
        )
        IsRegistered(msg.sender, sequence)
    {
        AcademicLibrary.FinalProject memory finalProject;

        finalProject = AcademicLibrary.FinalProject(
            title,
            summary,
            authors,
            advisors,
            course,
            institution,
            link,
            address(0)
        );

        _storeData.finalProject[msg.sender][sequence] = finalProject;

        emit FinalProjectEdited(msg.sender, sequence, finalProject);
    }

    function registerFinalProject(
        string memory title,
        string memory summary,
        string memory authors,
        string memory advisors,
        string memory course,
        string memory institution,
        string memory link
    )
        public
        payable
        ValidateFinalProject(
            AcademicLibrary.FinalProject(
                title,
                summary,
                authors,
                advisors,
                course,
                institution,
                link,
                address(0)
            )
        )
    {
        uint256 sequence = _storeData.nextSequence[msg.sender];
        AcademicLibrary.FinalProject memory finalProject;

        finalProject = AcademicLibrary.FinalProject(
            title,
            summary,
            authors,
            advisors,
            course,
            institution,
            link,
            address(0)
        );

        _storeData.finalProject[msg.sender][sequence] = finalProject;
        _storeData.finalProjectID.push(FinalProjectID(msg.sender, sequence));
        _storeData.nextSequence[msg.sender]++;

        emit FinalProjectRegistered(msg.sender, sequence, finalProject);
    }

    function unregisterFinalProject(
        uint256 sequence
    ) public payable IsRegistered(msg.sender, sequence) {
        AcademicLibrary.FinalProject memory finalProject;

        finalProject = _storeData.finalProject[msg.sender][sequence];

        delete _storeData.finalProject[msg.sender][sequence];

        for (uint256 i = 0; i < _storeData.finalProjectID.length; i++) {
            if (
                _storeData.finalProjectID[i].posterID == msg.sender &&
                _storeData.finalProjectID[i].sequence == sequence
            ) {
                _storeData.finalProjectID[i] = _storeData.finalProjectID[
                    _storeData.finalProjectID.length - 1
                ];
                _storeData.finalProjectID.pop();
            }
        }

        emit FinalProjectUnRegistered(msg.sender, sequence, finalProject);
    }
}
