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
import "./AcademicRepositoryLibrary.sol";

pragma solidity >=0.8.18;

contract AcademicRepository {
    constructor() {
        OWNER = msg.sender;
    }

    AcademicRepositoryLibrary.StoreData private _storeData;
    AcademicRepositoryLibrary.StoreKey private _storeKey;

    address private immutable OWNER;

    modifier IsOwner() {
        require(OWNER == msg.sender, "You must be the owner to perform this action");
        _;
    }

    function showStoreKey()
        public
        view
        returns (AcademicRepositoryLibrary.StoreKey memory storeKey)
    {
        return _storeKey;
    }

    function registerPost(
        AcademicRepositoryLibrary.PostID memory postID
    ) private IsOwner {
        _storeKey.postIDs.push(postID);
    }

    function unregisterPost(
        AcademicRepositoryLibrary.PostID memory PostID
    ) private IsOwner {
        AcademicRepositoryLibrary.PostID[] storage postIDs = _storeKey.postIDs;

        for (uint256 i = 0; i < postIDs.length; i++) {
            if (
                postIDs[i].posterID == PostID.posterID &&
                postIDs[i].academicType == PostID.academicType &&
                postIDs[i].sequence == PostID.sequence
            ) {
                postIDs[i] = _storeKey.postIDs[postIDs.length - 1];
                postIDs.pop();
            }
        }
    }

    function registerAuthenticatedPoster(
        address posterID,
        AcademicRepositoryLibrary.AuthenticatedPoster memory poster
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
    )
        public
        view
        returns (AcademicRepositoryLibrary.AuthenticatedPoster memory authority)
    {
        return _storeData.AuthenticatedPosters[posterID];
    }

    function registerFinalProject(
        AcademicRepositoryLibrary.FinalProject memory finalProject
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.FinalProject
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.FinalProject
        ][posterID]++;
        _storeData.FinalProject[posterID][sequence] = finalProject;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.FinalProject,
                sequence
            )
        );
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
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.FinalProject,
                sequence
            )
        );
    }

    function registerScientificPaper(
        AcademicRepositoryLibrary.ScientificPaper memory scientificPaper
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.ScientificPaper
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.ScientificPaper
        ][posterID]++;
        _storeData.ScientificPaper[posterID][sequence] = scientificPaper;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.ScientificPaper,
                sequence
            )
        );
    }

    function showScientificPaper(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (
            AcademicRepositoryLibrary.ScientificPaper memory scientificPaper
        )
    {
        return _storeData.ScientificPaper[posterID][sequence];
    }

    function unregisterScientificPaper(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.ScientificPaper[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.ScientificPaper,
                sequence
            )
        );
    }

    function registerMonograph(
        AcademicRepositoryLibrary.Monograph memory monograph
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.Monograph
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.Monograph
        ][posterID]++;
        _storeData.Monograph[posterID][sequence] = monograph;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.Monograph,
                sequence
            )
        );
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
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.Monograph,
                sequence
            )
        );
    }

    function registerMastersThesis(
        AcademicRepositoryLibrary.MastersThesis memory mastersThesis
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.MastersThesis
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.MastersThesis
        ][posterID]++;
        _storeData.MastersThesis[posterID][sequence] = mastersThesis;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.MastersThesis,
                sequence
            )
        );
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
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.MastersThesis,
                sequence
            )
        );
    }

    function registereDoctoralThesis(
        AcademicRepositoryLibrary.DoctoralThesis memory doctoralThesis
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.DoctoralThesis
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.DoctoralThesis
        ][posterID]++;
        _storeData.DoctoralThesis[posterID][sequence] = doctoralThesis;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.DoctoralThesis,
                sequence
            )
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
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.DoctoralThesis,
                sequence
            )
        );
    }

    function registerResearchReport(
        AcademicRepositoryLibrary.ResearchReport memory researchReport
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.ResearchReport
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.ResearchReport
        ][posterID]++;
        _storeData.ResearchReport[posterID][sequence] = researchReport;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.ResearchReport,
                sequence
            )
        );
    }

    function showResearchReport(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.ResearchReport memory researchReport)
    {
        return _storeData.ResearchReport[posterID][sequence];
    }

    function unregisterResearchReport(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.ResearchReport[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.ResearchReport,
                sequence
            )
        );
    }

    function registerBookReview(
        AcademicRepositoryLibrary.BookReview memory bookReview
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.BookReview
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.BookReview
        ][posterID]++;
        _storeData.BookReview[posterID][sequence] = bookReview;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.BookReview,
                sequence
            )
        );
    }

    function showBookReview(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.BookReview memory bookReview)
    {
        return _storeData.BookReview[posterID][sequence];
    }

    function unregisterBookReview(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.BookReview[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.BookReview,
                sequence
            )
        );
    }

    function registerResearchProposal(
        AcademicRepositoryLibrary.ResearchProposal memory researchProposal
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.ResearchProposal
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.ResearchProposal
        ][posterID]++;
        _storeData.ResearchProposal[posterID][sequence] = researchProposal;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.ResearchProposal,
                sequence
            )
        );
    }

    function showResearchProposal(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (
            AcademicRepositoryLibrary.ResearchProposal memory researchProposal
        )
    {
        return _storeData.ResearchProposal[posterID][sequence];
    }

    function unregisterResearchProposal(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.ResearchProposal[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.ResearchProposal,
                sequence
            )
        );
    }

    function registerInternshipReport(
        AcademicRepositoryLibrary.InternshipReport memory internshipReport
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.InternshipReport
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.InternshipReport
        ][posterID]++;
        _storeData.InternshipReport[posterID][sequence] = internshipReport;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.InternshipReport,
                sequence
            )
        );
    }

    function showInternshipReport(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (
            AcademicRepositoryLibrary.InternshipReport memory internshipReport
        )
    {
        return _storeData.InternshipReport[posterID][sequence];
    }

    function unregisterInternshipReport(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.InternshipReport[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.InternshipReport,
                sequence
            )
        );
    }

    function registerCoursework(
        AcademicRepositoryLibrary.Coursework memory coursework
    ) public {
        address posterID = msg.sender;
        uint256 sequence = _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.Coursework
        ][posterID];
        _storeData.NextSequenceAcademicType[
            AcademicRepositoryLibrary.AcademicTypes.Coursework
        ][posterID]++;
        _storeData.Coursework[posterID][sequence] = coursework;
        registerPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.Coursework,
                sequence
            )
        );
    }

    function showCoursework(
        address posterID,
        uint256 sequence
    )
        public
        view
        returns (AcademicRepositoryLibrary.Coursework memory coursework)
    {
        return _storeData.Coursework[posterID][sequence];
    }

    function unregisterCoursework(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.Coursework[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.Coursework,
                sequence
            )
        );
    }
}
