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
        require(OWNER == msg.sender, "");
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
    ) public payable IsOwner {
        _storeKey.postIDs.push(postID);
    }

    function unregisterPost(
        AcademicRepositoryLibrary.PostID memory PostID
    ) public payable IsOwner {
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

    event EventAuthenticatedPosterAdded(address indexed posterID);
    event EventAuthenticatedPosterUnregister(address indexed posterID);

    function registerAuthenticatedPoster(
        address posterID,
        AcademicRepositoryLibrary.AuthenticatedPoster memory poster
    ) public payable IsOwner {
        _storeData.AuthenticatedPosters[posterID] = poster;
        _storeKey.posterIDs.push(posterID);

        emit EventAuthenticatedPosterAdded(posterID);
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

        emit EventAuthenticatedPosterUnregister(posterID);
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

    event EventFinalProjectAdded(
        address indexed posterID,
        uint256 indexed sequence
    );
    event EventFinalProjectUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventFinalProjectAdded(posterID, sequence);
    }

    function showFinalProject(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.FinalProject memory finalProject = _storeData
            .FinalProject[posterID][sequence];
        return finalProject.time;
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
        emit EventFinalProjectUnregisterd(posterID, sequence);
    }

    event EventScientificPaperAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventScientificPaperUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventScientificPaperAdded(posterID, sequence);
    }

    function showScientificPaper(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.ScientificPaper
            memory scientificPaper = _storeData.ScientificPaper[posterID][
                sequence
            ];
        return scientificPaper.time;
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
        emit EventScientificPaperUnregisterd(posterID, sequence);
    }

    event EventMonographAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventMonographUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventMonographAdded(posterID, sequence);
    }

    function showMonograph(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.Monograph memory monograph = _storeData
            .Monograph[posterID][sequence];
        return monograph.time;
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
        emit EventMonographUnregisterd(posterID, sequence);
    }

    event EventMastersThesisAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventMastersThesisUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventMastersThesisAdded(posterID, sequence);
    }

    function showMastersThesis(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.MastersThesis
            memory mastersThesis = _storeData.MastersThesis[posterID][sequence];
        return mastersThesis.time;
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
        emit EventMastersThesisUnregisterd(posterID, sequence);
    }

    event EventDoctoralThesisAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventDoctoralThesisUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

    function registerDoctoralThesis(
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
        emit EventDoctoralThesisAdded(posterID, sequence);
    }

    function showDoctoralThesis(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.DoctoralThesis
            memory doctoralThesis = _storeData.DoctoralThesis[posterID][
                sequence
            ];
        return doctoralThesis.time;
    }

    function unregisterDoctoralThesis(uint256 sequence) public {
        address posterID = msg.sender;
        delete _storeData.DoctoralThesis[posterID][sequence];
        unregisterPost(
            AcademicRepositoryLibrary.PostID(
                msg.sender,
                AcademicRepositoryLibrary.AcademicTypes.DoctoralThesis,
                sequence
            )
        );
        emit EventDoctoralThesisUnregisterd(posterID, sequence);
    }

    event EventResearchReportAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventResearchReportUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventResearchReportAdded(posterID, sequence);
    }

    function showResearchReport(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.ResearchReport
            memory researchReport = _storeData.ResearchReport[posterID][
                sequence
            ];
        return researchReport.time;
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
        emit EventResearchReportUnregisterd(posterID, sequence);
    }

    event EventBookReviewAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventBookReviewUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventBookReviewAdded(posterID, sequence);
    }

    function showBookReview(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.BookReview memory bookReview = _storeData
            .BookReview[posterID][sequence];
        return bookReview.time;
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
        emit EventBookReviewUnregisterd(posterID, sequence);
    }

    event EventResearchProposalAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventResearchProposalUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventResearchProposalAdded(posterID, sequence);
    }

    function showResearchProposal(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.ResearchProposal
            memory researchProposal = _storeData.ResearchProposal[posterID][
                sequence
            ];
        return researchProposal.time;
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
        emit EventResearchProposalUnregisterd(posterID, sequence);
    }

    event EventInternshipReportAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventInternshipReportUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventInternshipReportAdded(posterID, sequence);
    }

    function showInternshipReport(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.InternshipReport
            memory internshipReport = _storeData.InternshipReport[posterID][
                sequence
            ];
        return internshipReport.time;
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
        emit EventInternshipReportUnregisterd(posterID, sequence);
    }

    event EventCourseworkAdded(
        address indexed posterID,
        uint256 indexed sequence
    );

    event EventCourseworkUnregisterd(
        address indexed posterID,
        uint256 indexed sequence
    );

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
        emit EventCourseworkAdded(posterID, sequence);
    }

    function showCoursework(
        address posterID,
        uint256 sequence
    ) public view returns (uint256 title) {
        AcademicRepositoryLibrary.Coursework memory coursework = _storeData
            .Coursework[posterID][sequence];
        return coursework.time;
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
        emit EventCourseworkUnregisterd(posterID, sequence);
    }
}
