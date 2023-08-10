// SPDX-License-Identifier: AFL-3.0
import "AcademicRepositoryLibrary.sol";

pragma solidity >=0.8.18;

contract RepositoryMonograph {
    struct PostID {
        address posterID;
        uint256 sequence;
    }

    struct StoreData {
        PostID[] postIDs;
        mapping(address posterID => uint256 sequence) NextSequence;
        mapping(address posterID => mapping(uint256 sequence => AcademicRepositoryLibrary.Monograph)) Repository;
    }

    event MonographRegistered(
        address indexed posterID,
        uint256 indexed sequence,
        string title
    );

    event MonographUnRegistered(
        address indexed posterID,
        uint256 indexed sequence
    );

    StoreData private _storeData;
 
    function showPostIDs() public view returns (PostID[] memory postID) {
        return _storeData.postIDs;
    }

    function showMonograph(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (
            AcademicRepositoryLibrary.Monograph memory monograph
        )
    {
        return _storeData.Repository[posterID][sequence];
    }

    function registerMonograph(
        AcademicRepositoryLibrary.Monograph memory monograph
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequence[posterID];
        _storeData.NextSequence[posterID]++;
        _storeData.Repository[posterID][sequence] = monograph;
        _storeData.postIDs.push(PostID(msg.sender, sequence));

        emit MonographRegistered(posterID, sequence, monograph.title);
    }

    function unregisterMonograph(uint256 sequence) public {
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

        emit MonographUnRegistered(posterID, sequence);
    }  
}
