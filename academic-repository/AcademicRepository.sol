//                        _                _
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

    modifier IsAuthenticityNotSolicited(
        AcademicRepositoryLibrary.PostID memory postID
    ) {
        require(showPost(postID).authenticity.authority == address(0), "");

        _;
    }

    modifier IsPostCreated(AcademicRepositoryLibrary.PostID memory postID) {
        require(showPost(postID).created, "");
        _;
    }

    modifier IsAuthorizedModel(string memory model) {
        bool result;
        string[] memory authorizedModels;

        authorizedModels = _storeKey.authorizedModels;

        for (uint256 i = 0; i < authorizedModels.length; i++) {
            if (
                keccak256(abi.encodePacked(authorizedModels[i])) ==
                keccak256(abi.encodePacked(model))
            ) {
                result = true;
                break;
            }
        }

        require(result, "");
        _;
    }

    modifier IsAuthority() {
        bool result;
        address[] memory authoritys;

        authoritys = _storeKey.authorityIDs;

        for (uint256 i = 0; i < authoritys.length; i++) {
            if (authoritys[i] == msg.sender) {
                result = true;
                break;
            }
        }

        require(result, "");
        _;
    }

    modifier IsRequestForMe(AcademicRepositoryLibrary.PostID memory postID) {
        require(showPost(postID).authenticity.authority == msg.sender, "");
        _;
    }

    function sendAuthorizedModel(string memory model) public payable IsOwner {
        _storeKey.authorizedModels.push(model);
    }

    function removeAuthorizedModel(string memory model) public payable IsOwner {
        for (uint256 i = 0; i < _storeKey.authorizedModels.length; i++) {
            if (
                keccak256(abi.encodePacked(_storeKey.authorizedModels[i])) ==
                keccak256(abi.encodePacked(model))
            ) {
                _storeKey.authorizedModels[i] = _storeKey.authorizedModels[
                    _storeKey.authorizedModels.length - 1
                ];
                _storeKey.authorizedModels.pop();
            }
        }
    }

    function showAuthorizedModels()
        public
        payable
        returns (string[] memory authorizedModels)
    {
        return _storeKey.authorizedModels;
    }

    function sendPost(
        string memory model,
        string[] memory description
    ) public payable IsAuthorizedModel(model) {
        AcademicRepositoryLibrary.PostID memory postID;
        AcademicRepositoryLibrary.Post memory post;

        postID.posterID = msg.sender;
        postID.model = model;
        postID.sequence = _storeData.postSequences[msg.sender][model];

        post.created = true;
        post.description = description;

        _storeData.posts[postID.posterID][postID.model][postID.sequence] = post;

        _storeKey.postIDs.push(postID);

        _storeData.postSequences[msg.sender][model]++;
    }

    function sendPostWithAuthenticateRequest(
        string memory model,
        string[] memory description,
        address authorityID
    ) public payable IsAuthorizedModel(model) {
        AcademicRepositoryLibrary.PostID memory postID;
        AcademicRepositoryLibrary.Post memory post;

        postID.posterID = msg.sender;
        postID.model = model;
        postID.sequence = _storeData.postSequences[msg.sender][model];

        post.created = true;
        post.description = description;
        post.authenticity.authority = authorityID;

        _storeData.posts[postID.posterID][postID.model][postID.sequence] = post;

        _storeKey.postIDs.push(postID);

        _storeData.requests[authorityID].push(postID);

        _storeData.postSequences[msg.sender][model]++;
    }

    function sendAuthenticateRequest(
        string memory model,
        uint256 sequence,
        address authorityID
    )
        public
        payable
        IsPostCreated(
            AcademicRepositoryLibrary.PostID(msg.sender, model, sequence)
        )
        IsAuthenticityNotSolicited(
            AcademicRepositoryLibrary.PostID(msg.sender, model, sequence)
        )
    {
        AcademicRepositoryLibrary.PostID memory postID;
        postID.posterID = msg.sender;
        postID.model = model;
        postID.sequence = sequence;

        _storeData
        .posts[postID.posterID][postID.model][postID.sequence]
            .authenticity
            .authority = authorityID;

        _storeData.requests[authorityID].push(postID);
    }

    function deleteAuthenticateRequest(
        string memory model,
        uint256 sequence
    ) public payable {
        AcademicRepositoryLibrary.PostID memory postID;
        postID.posterID = msg.sender;
        postID.model = model;
        postID.sequence = sequence;

        deleteAuthenticateRequest(
            showPost(postID).authenticity.authority,
            postID
        );

        _storeData
        .posts[postID.posterID][postID.model][postID.sequence]
            .authenticity
            .authority = address(0);
    }

    function deleteAuthenticateRequest(
        address authorityID,
        AcademicRepositoryLibrary.PostID memory request
    ) private {
        for (uint256 i = 0; i < _storeData.requests[authorityID].length; i++) {
            if (
                _storeData.requests[authorityID][i].posterID ==
                request.posterID &&
                keccak256(
                    abi.encodePacked(_storeData.requests[authorityID][i].model)
                ) ==
                keccak256(abi.encodePacked(request.model)) &&
                _storeData.requests[authorityID][i].sequence == request.sequence
            ) {
                _storeData.requests[authorityID][i] = _storeData.requests[
                    authorityID
                ][_storeData.requests[authorityID].length - 1];
                _storeData.requests[authorityID].pop();
                break;
            }
        }
    }

    function authenticatePost(
        AcademicRepositoryLibrary.PostID memory postID,
        bool authentic,
        string memory message
    ) public payable IsRequestForMe(postID) IsAuthority {
        AcademicRepositoryLibrary.Authenticity memory authenticity;

        authenticity.authority = msg.sender;
        authenticity.authentic = authentic;
        authenticity.message = message;

        _storeData
        .posts[postID.posterID][postID.model][postID.sequence]
            .authenticity = authenticity;

        deleteAuthenticateRequest(msg.sender, postID);
    }

    function deletePost(string memory model, uint256 sequence) public payable {
        AcademicRepositoryLibrary.PostID memory request;
        request.posterID = msg.sender;
        request.model = model;
        request.sequence = sequence;
        deleteAuthenticateRequest(
            showPost(request).authenticity.authority,
            request
        );

        for (uint256 i = 0; i < _storeKey.postIDs.length; i++) {
            if (
                keccak256(abi.encodePacked(_storeKey.postIDs[i].model)) ==
                keccak256(abi.encodePacked(model)) &&
                _storeKey.postIDs[i].posterID == msg.sender &&
                _storeKey.postIDs[i].sequence == sequence
            ) {
                _storeKey.postIDs[i] = _storeKey.postIDs[
                    _storeKey.postIDs.length - 1
                ];
                _storeKey.postIDs.pop();
            }
        }

        delete _storeData.posts[msg.sender][model][sequence];
    }

    function showPost(
        AcademicRepositoryLibrary.PostID memory postID
    ) public payable returns (AcademicRepositoryLibrary.Post memory post) {
        return _storeData.posts[postID.posterID][postID.model][postID.sequence];
    }

    function showPosts(
        AcademicRepositoryLibrary.PostID[] memory postIDs
    ) public payable returns (AcademicRepositoryLibrary.Post[] memory posts) {
        AcademicRepositoryLibrary.Post[]
            memory result = new AcademicRepositoryLibrary.Post[](
                postIDs.length
            );
        for (uint256 i = 0; i < postIDs.length; i++)
            result[i] = _storeData.posts[postIDs[i].posterID][postIDs[i].model][
                postIDs[i].sequence
            ];

        return result;
    }

    function registerAuthority(
        address authorityID,
        AcademicRepositoryLibrary.Authority memory authority
    ) public payable IsOwner {
        _storeData.authoritys[authorityID] = authority;
        _storeKey.authorityIDs.push(authorityID);
    }

    function unregisterAuthority(address authorityID) public payable IsOwner {
        delete _storeData.authoritys[authorityID];
        delete _storeData.requests[authorityID];

        for (uint256 i = 0; i < _storeKey.authorityIDs.length; i++) {
            if (_storeKey.authorityIDs[i] == authorityID) {
                _storeKey.authorityIDs[i] = _storeKey.authorityIDs[
                    _storeKey.authorityIDs.length - 1
                ];
                _storeKey.authorityIDs.pop();
            }
        }
    }

    function showAuthority(
        address authorityID
    )
        public
        view
        returns (AcademicRepositoryLibrary.Authority memory authority)
    {
        return _storeData.authoritys[authorityID];
    }

    function ShowAuthenticateRequests(
        address authorityID
    ) public view returns (AcademicRepositoryLibrary.PostID[] memory requests) {
        return _storeData.requests[authorityID];
    }

    function showAuthoritysIDs()
        public
        payable
        returns (address[] memory authorityIDs)
    {
        return _storeKey.authorityIDs;
    }

    function showPostIDs()
        public
        payable
        returns (AcademicRepositoryLibrary.PostID[] memory postIDs)
    {
        return _storeKey.postIDs;
    }

    function getStoreKey()
        public
        payable
        returns (AcademicRepositoryLibrary.StoreKey memory storeKey)
    {
        return storeKey;
    }
}
