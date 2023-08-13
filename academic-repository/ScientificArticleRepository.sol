// SPDX-License-Identifier: AFL-3.0
import "AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract ScientificArticleRepository {
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
        mapping(address posterID => mapping(uint256 sequence => AcademicLibrary.ScientificArticle)) scientificArticle;
    }

    StoreData private _storeData;

    event ScientificArticlehRegistered(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.ScientificArticle Data
    );

    event ScientificArticlehEdited(
        address indexed posterID,
        uint256 indexed sequence,
        AcademicLibrary.ScientificArticle Data
    );

    event ScientificArticlehUnRegistered(
        address indexed posterID,
        uint256 indexed sequence
    );

    event ScientificArticlehAuthenticated(
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
                    (_storeData.scientificArticle[posterID][sequence].title)
                )
            ) != keccak256(abi.encodePacked((""))),
            "It is not possible to execute this action because the post register do not exist"
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

    function authenticateScientificArticle(
        address posterId,
        uint256 sequence
    ) public IsRegistered(posterId, sequence) IsInstitution() {
        _storeData.scientificArticle[posterId][sequence].authenticated = msg
            .sender;

        emit ScientificArticlehAuthenticated(posterId, sequence, msg.sender);
    }

    function showScientificArticle(
        PostID memory postID
    )
        public
        view
        returns (AcademicLibrary.ScientificArticle memory scientificArticle)
    {
        return _storeData.scientificArticle[postID.posterID][postID.sequence];
    }

    function editScientificArticle(
        uint256 sequence,
        AcademicLibrary.ScientificArticle memory scientificArticle
    )
        public
        IsRegistered(msg.sender, sequence)
        ValidateScientificArticle(scientificArticle)
    {
        scientificArticle.authenticated = address(0);
        _storeData.scientificArticle[msg.sender][sequence] = scientificArticle;

        emit ScientificArticlehEdited(msg.sender, sequence, scientificArticle);
    }

    function registerScientificArticle(
        AcademicLibrary.ScientificArticle memory scientificArticle
    ) public ValidateScientificArticle(scientificArticle) {
        address posterID = msg.sender;
        uint256 sequence = _storeData.nextSequence[posterID];
        _storeData.scientificArticle[posterID][sequence] = scientificArticle;
        _storeData.postID.push(PostID(msg.sender, sequence));
        _storeData.nextSequence[posterID]++;

        emit ScientificArticlehRegistered(
            posterID,
            sequence,
            scientificArticle
        );
    }

    function unregisterScientificArticle(uint256 sequence) public {
        address posterID = msg.sender;

        delete _storeData.scientificArticle[posterID][sequence];

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

        emit ScientificArticlehUnRegistered(posterID, sequence);
    }
}
