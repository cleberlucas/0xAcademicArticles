// SPDX-License-Identifier: AFL-3.0
import "AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract ScientificArticleRepository {
    struct PostID {
        address posterID;
        uint256 sequence;
    }

    struct StoreData {
        PostID[] postIDs;
        mapping(address posterID => uint256 sequence) NextSequence;
        mapping(address posterID => mapping(uint256 sequence => AcademicLibrary.ScientificArticle)) Repository;
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

    modifier IsRegistered(address posterID, uint256 sequence) {
        require(
            keccak256(
                abi.encodePacked(
                    (_storeData.Repository[posterID][sequence].title)
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
            keccak256(abi.encodePacked((scientificArticle.documentUrl))) !=
                keccak256(abi.encodePacked((""))),
            "Document URL cannot be empty"
        );

        _;
    }

    function showPostIDs() public view returns (PostID[] memory postID) {
        return _storeData.postIDs;
    }

    function showScientificArticle(
        PostID memory postID
    )
        public
        view
        returns (AcademicLibrary.ScientificArticle memory scientificArticle)
    {
        return _storeData.Repository[postID.posterID][postID.sequence];
    }

    function editScientificArticle(
        uint256 sequence,
        AcademicLibrary.ScientificArticle memory scientificArticle
    )
        public
        IsRegistered(msg.sender, sequence)
        ValidateScientificArticle(scientificArticle)
    {
        _storeData.Repository[msg.sender][sequence] = scientificArticle;

        emit ScientificArticlehEdited(msg.sender, sequence, scientificArticle);
    }

    function registerScientificArticle(
        AcademicLibrary.ScientificArticle memory scientificArticle
    ) public ValidateScientificArticle(scientificArticle) {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequence[posterID];
        _storeData.NextSequence[posterID]++;
        _storeData.Repository[posterID][sequence] = scientificArticle;
        _storeData.postIDs.push(PostID(msg.sender, sequence));

        emit ScientificArticlehRegistered(
            posterID,
            sequence,
            scientificArticle
        );
    }

    function unregisterScientificArticle(uint256 sequence) public {
        address posterID = msg.sender;
        PostID[] storage postIDs = _storeData.postIDs;

        delete _storeData.Repository[posterID][sequence];

        for (uint256 i = 0; i < postIDs.length; i++) {
            if (
                postIDs[i].posterID == msg.sender &&
                postIDs[i].sequence == sequence
            ) {
                postIDs[i] = _storeData.postIDs[postIDs.length - 1];
                postIDs.pop();
            }
        }

        emit ScientificArticlehUnRegistered(posterID, sequence);
    }
}
