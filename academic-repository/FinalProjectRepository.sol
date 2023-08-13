// SPDX-License-Identifier: AFL-3.0
import "AcademicLibrary.sol";

pragma solidity >=0.8.18;

contract FinalProjectRepository {
    struct PostID {
        address posterID;
        uint256 sequence;
    }

    struct StoreData {
        PostID[] postIDs;
        mapping(address posterID => uint256 sequence) NextSequence;
        mapping(address posterID => mapping(uint256 sequence => AcademicLibrary.FinalProject)) Repository;
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
            keccak256(abi.encodePacked((finalProject.documentUrl))) !=
                keccak256(abi.encodePacked((""))),
            "Document URL cannot be empty"
        );

        _;
    }

    function showPostIDs() public view returns (PostID[] memory postID) {
        return _storeData.postIDs;
    }

    function showFinalProject(
        PostID memory postID
    )
        public
        view
        returns (AcademicLibrary.FinalProject memory finalProject)
    {
        return _storeData.Repository[postID.posterID][postID.sequence];
    }

    function editFinalProject(
        uint256 sequence,
        AcademicLibrary.FinalProject memory finalProject
    ) public IsRegistered(msg.sender, sequence) ValidateFinalProject(finalProject) {
        _storeData.Repository[msg.sender][sequence] = finalProject;

        emit FinalProjecthEdited(msg.sender, sequence, finalProject);
    }

    function registerFinalProject(
        AcademicLibrary.FinalProject memory finalProject
    ) public ValidateFinalProject(finalProject) {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequence[posterID];
        _storeData.NextSequence[posterID]++;
        _storeData.Repository[posterID][sequence] = finalProject;
        _storeData.postIDs.push(PostID(msg.sender, sequence));

        emit FinalProjecthRegistered(posterID, sequence, finalProject);
    }

    function unregisterFinalProject(uint256 sequence) public {
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

        emit FinalProjecthUnRegistered(posterID, sequence);
    }
}
