// SPDX-License-Identifier: AFL-3.0
import "./AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract ScientificArticleRepository {
    constructor() {
        OWNER = msg.sender;
    }

    address private immutable OWNER;

    struct ScientificArticleID {
        address posterID;
        uint256 sequence;
    }

    struct StoreData {
        address[] institutionID;
        ScientificArticleID[] scientificArticleID;
        mapping(address posterID => uint256 sequence) nextSequence;
        mapping(address posterID => mapping(uint256 sequence => AcademicLibrary.ScientificArticle)) scientificArticle;
    }

    StoreData private _storeData;

    event ScientificArticleRegistered(
        ScientificArticleID indexed scientificArticleID,
        AcademicLibrary.ScientificArticle scientificArticle
    );

    event ScientificArticleEdited(
        ScientificArticleID indexed scientificArticleID,
        AcademicLibrary.ScientificArticle scientificArticle
    );

    event ScientificArticleUnRegistered(
        ScientificArticleID indexed scientificArticleID,
        AcademicLibrary.ScientificArticle scientificArticle
    );

    event ScientificArticleAuthenticated(
        ScientificArticleID indexed scientificArticleID,
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

    modifier IsRegistered(ScientificArticleID memory scientificArticleID) {
        require(
            keccak256(
                abi.encodePacked(
                    (_storeData.scientificArticle[scientificArticleID.posterID][scientificArticleID.sequence].title)
                )
            ) != keccak256(abi.encodePacked((""))),
            "It is not possible to execute this action because the post register do not exist"
        );
        _;
    }

    modifier IsNotAuthenticated(ScientificArticleID memory scientificArticleID) {
        require(
            _storeData.scientificArticle[scientificArticleID.posterID][scientificArticleID.sequence].authenticated ==
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

    modifier ValidateScientificArticle(
        AcademicLibrary.ScientificArticle memory scientificArticle
    ) {
        require(
            keccak256(abi.encodePacked((scientificArticle.title))) !=
                keccak256(abi.encodePacked((""))),
            "Title cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((scientificArticle.summary))) !=
                keccak256(abi.encodePacked((""))),
            "Summary cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((scientificArticle.authors))) !=
                keccak256(abi.encodePacked((""))),
            "Authors cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((scientificArticle.advisors))) !=
                keccak256(abi.encodePacked((""))),
            "Advisors cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((scientificArticle.course))) !=
                keccak256(abi.encodePacked((""))),
            "Course cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((scientificArticle.institution))) !=
                keccak256(abi.encodePacked((""))),
            "Institution cannot be empty"
        );

        require(
            keccak256(abi.encodePacked((scientificArticle.link))) !=
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

    function showScientificArticleID()
        public
        view
        returns (ScientificArticleID[] memory scientificArticleID)
    {
        return _storeData.scientificArticleID;
    }

    function authenticateScientificArticle(
        ScientificArticleID memory scientificArticleID
    )
        public
        payable
        IsRegistered(scientificArticleID)
        IsNotAuthenticated(scientificArticleID)
        IsInstitution
    {
        _storeData.scientificArticle[scientificArticleID.posterID][scientificArticleID.sequence].authenticated = msg.sender;

        emit ScientificArticleAuthenticated(scientificArticleID, msg.sender);
    }

    function showScientificArticle(
        ScientificArticleID memory scientificArticleID
    ) public view returns (AcademicLibrary.ScientificArticle memory scientificArticle) {
        return
            _storeData.scientificArticle[scientificArticleID.posterID][
                scientificArticleID.sequence
            ];
    }

    function editScientificArticle(
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
        ValidateScientificArticle(
            AcademicLibrary.ScientificArticle(
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
        IsRegistered(ScientificArticleID(msg.sender, sequence))
    {
        AcademicLibrary.ScientificArticle memory scientificArticle;

        scientificArticle = AcademicLibrary.ScientificArticle(
            title,
            summary,
            authors,
            advisors,
            course,
            institution,
            link,
            address(0)
        );

        _storeData.scientificArticle[msg.sender][sequence] = scientificArticle;

        emit ScientificArticleEdited(ScientificArticleID(msg.sender, sequence), scientificArticle);
    }

    function registerScientificArticle(
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
        ValidateScientificArticle(
            AcademicLibrary.ScientificArticle(
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
        AcademicLibrary.ScientificArticle memory scientificArticle;

        scientificArticle = AcademicLibrary.ScientificArticle(
            title,
            summary,
            authors,
            advisors,
            course,
            institution,
            link,
            address(0)
        );

        _storeData.scientificArticle[msg.sender][sequence] = scientificArticle;
        _storeData.scientificArticleID.push(ScientificArticleID(msg.sender, sequence));
        _storeData.nextSequence[msg.sender]++;

        emit ScientificArticleRegistered(ScientificArticleID(msg.sender, sequence), scientificArticle);
    }

    function unregisterScientificArticle(
        uint256 sequence
    ) public payable IsRegistered(ScientificArticleID(msg.sender, sequence)) {
        AcademicLibrary.ScientificArticle memory scientificArticle;

        scientificArticle = _storeData.scientificArticle[msg.sender][sequence];

        delete _storeData.scientificArticle[msg.sender][sequence];

        for (uint256 i = 0; i < _storeData.scientificArticleID.length; i++) {
            if (
                _storeData.scientificArticleID[i].posterID == msg.sender &&
                _storeData.scientificArticleID[i].sequence == sequence
            ) {
                _storeData.scientificArticleID[i] = _storeData.scientificArticleID[
                    _storeData.scientificArticleID.length - 1
                ];
                _storeData.scientificArticleID.pop();
            }
        }

        emit ScientificArticleUnRegistered(ScientificArticleID(msg.sender, sequence), scientificArticle);
    }
}
