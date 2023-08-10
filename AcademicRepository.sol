//     /\                | |              (_)
//    /  \   ___ __ _  __| | ___ _ __ ___  _  ___
//   / /\ \ / __/ _` |/ _` |/ _ \ '_ ` _ \| |/ __|
//  / ____ \ (_| (_| | (_| |  __/ | | | | | | (__
// /_/___ \_\___\__,_|\__,_|\___|_| |_| |_|_|\___|
// |  __ \                    (_) |
// | |__) |___ _ __   ___  ___ _| |_ ___  _ __ _   _
// |  _  // _ \ '_ \ / _ \/ __| | __/ _ \| '__| | | |
// | | \ \  __/ |_) | (_) \__ \ | || (_) | |  | |_| |
// |_|  \_\___| .__/ \___/|___/_|\__\___/|_|   \__, |
//            | |                               __/ |
//           |_|                              |___/
// SPDX-License-Identifier: AFL-3.0
import "AcademicRepositoryLibrary.sol";

pragma solidity >=0.8.18;

contract AcademicRepository {
    constructor() {
        OWNER = msg.sender;
    }

    struct StoreData {
        mapping(address posterID => AuthenticatedPoster) AuthenticatedPosters;
        mapping(AcademicTypes academicTypes => mapping(address posterID => uint256 sequence)) NextSequenceAcademicType;
        mapping(address posterID => mapping(uint256 sequence => AcademicRepositoryLibrary.FinalProject)) FinalProject;
        mapping(address posterID => mapping(uint256 sequence => AcademicRepositoryLibrary.ScientificArticle)) ScientificArticle;
        mapping(address posterID => mapping(uint256 sequence => AcademicRepositoryLibrary.Monograph)) Monograph;
        mapping(address posterID => mapping(uint256 sequence => AcademicRepositoryLibrary.MastersThesis)) MastersThesis;
        mapping(address posterID => mapping(uint256 sequence => AcademicRepositoryLibrary.DoctoralThesis)) DoctoralThesis;
    }

    struct StoreKey {
        address[] posterIDs;
        PostID[] postIDs;
    }

    struct PostID {
        address posterID;
        AcademicTypes academicType;
        uint256 sequence;
    }

    struct AuthenticatedPoster {
        string name;
        PosterTypes posterType;
        string country;
        string phone;
        string email;
        string website;
    }

    enum PosterTypes {
        normal,
        institution
    }

    enum AcademicTypes {
        FinalProject,
        ScientificArticle,
        Monograph,
        MastersThesis,
        DoctoralThesis
    }

    StoreData private _storeData;
    StoreKey private _storeKey;

    address private immutable OWNER;

    modifier IsOwner() {
        require(
            OWNER == msg.sender,
            "You must be the owner to perform this action"
        );
        _;
    }

    function showStoreKey() public view returns (StoreKey memory storeKey) {
        return _storeKey;
    }

    function registerPost(PostID memory postID) private IsOwner {
        _storeKey.postIDs.push(postID);
    }

    function unregisterPost(PostID memory postID) private IsOwner {
        PostID[] storage postIDs = _storeKey.postIDs;

        for (uint256 i = 0; i < postIDs.length; i++) {
            if (
                postIDs[i].posterID == postID.posterID &&
                postIDs[i].academicType == postID.academicType &&
                postIDs[i].sequence == postID.sequence
            ) {
                postIDs[i] = _storeKey.postIDs[postIDs.length - 1];
                postIDs.pop();
            }
        }
    }

    function registerAuthenticatedPoster(
        address posterID,
        AuthenticatedPoster memory poster
    ) public payable IsOwner {
        _storeData.AuthenticatedPosters[posterID] = poster;
        _storeKey.posterIDs.push(posterID);
    }

    function unregisterAuthenticatedPoster(
        address posterID
    ) public payable IsOwner {
        delete _storeData.AuthenticatedPosters[posterID];

        for (uint256 i = 0; i < _storeKey.posterIDs.length; i++) {
            if (_storeKey.posterIDs[i] == posterID) {
                _storeKey.posterIDs[i] = _storeKey.posterIDs[
                    _storeKey.posterIDs.length - 1
                ];
                _storeKey.posterIDs.pop();
            }
        }
    }

    function showAuthenticatedPoster(
        address posterID
    ) public view returns (AuthenticatedPoster memory authority) {
        return _storeData.AuthenticatedPosters[posterID];
    }

    function registerFinalProject(
        AcademicRepositoryLibrary.FinalProject memory finalProject
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicTypes.FinalProject
        ][posterID];
        _storeData.NextSequenceAcademicType[AcademicTypes.FinalProject][
            posterID
        ]++;
        _storeData.FinalProject[posterID][sequence] = finalProject;
        registerPost(PostID(msg.sender, AcademicTypes.FinalProject, sequence));
    }

    function showFinalProject(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.FinalProject memory finalProject)
    {
        return _storeData.FinalProject[posterID][sequence];
    }

    function unregisterFinalProject(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.FinalProject[posterID][sequence];
        unregisterPost(
            PostID(msg.sender, AcademicTypes.FinalProject, sequence)
        );
    }

    function registerScientificArticle(
        AcademicRepositoryLibrary.ScientificArticle memory scientificPaper
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicTypes.ScientificArticle
        ][posterID];
        _storeData.NextSequenceAcademicType[AcademicTypes.ScientificArticle][
            posterID
        ]++;
        _storeData.ScientificArticle[posterID][sequence] = scientificPaper;
        registerPost(
            PostID(msg.sender, AcademicTypes.ScientificArticle, sequence)
        );
    }

    function showScientificArticle(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (
            AcademicRepositoryLibrary.ScientificArticle memory scientificPaper
        )
    {
        return _storeData.ScientificArticle[posterID][sequence];
    }

    function unregisterScientificArticle(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.ScientificArticle[posterID][sequence];
        unregisterPost(
            PostID(msg.sender, AcademicTypes.ScientificArticle, sequence)
        );
    }

    function registerMonograph(
        AcademicRepositoryLibrary.Monograph memory monograph
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicTypes.Monograph
        ][posterID];
        _storeData.NextSequenceAcademicType[AcademicTypes.Monograph][
            posterID
        ]++;
        _storeData.Monograph[posterID][sequence] = monograph;
        registerPost(PostID(msg.sender, AcademicTypes.Monograph, sequence));
    }

    function showMonograph(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.Monograph memory monograph)
    {
        return _storeData.Monograph[posterID][sequence];
    }

    function unregisterMonograph(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.Monograph[posterID][sequence];
        unregisterPost(PostID(msg.sender, AcademicTypes.Monograph, sequence));
    }

    function registerMastersThesis(
        AcademicRepositoryLibrary.MastersThesis memory mastersThesis
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicTypes.MastersThesis
        ][posterID];
        _storeData.NextSequenceAcademicType[AcademicTypes.MastersThesis][
            posterID
        ]++;
        _storeData.MastersThesis[posterID][sequence] = mastersThesis;
        registerPost(PostID(msg.sender, AcademicTypes.MastersThesis, sequence));
    }

    function showMastersThesis(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.MastersThesis memory mastersThesis)
    {
        return _storeData.MastersThesis[posterID][sequence];
    }

    function unregisterMastersThesis(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.MastersThesis[posterID][sequence];
        unregisterPost(
            PostID(msg.sender, AcademicTypes.MastersThesis, sequence)
        );
    }

    function registereDoctoralThesis(
        AcademicRepositoryLibrary.DoctoralThesis memory doctoralThesis
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicTypes.DoctoralThesis
        ][posterID];
        _storeData.NextSequenceAcademicType[AcademicTypes.DoctoralThesis][
            posterID
        ]++;
        _storeData.DoctoralThesis[posterID][sequence] = doctoralThesis;
        registerPost(
            PostID(msg.sender, AcademicTypes.DoctoralThesis, sequence)
        );
    }

    function showDoctoralThesis(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.DoctoralThesis memory doctoralThesis)
    {
        return _storeData.DoctoralThesis[posterID][sequence];
    }

    function unRegisteredoctoralThesis(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.DoctoralThesis[posterID][sequence];
        unregisterPost(
            PostID(msg.sender, AcademicTypes.DoctoralThesis, sequence)
        );
    }
}
