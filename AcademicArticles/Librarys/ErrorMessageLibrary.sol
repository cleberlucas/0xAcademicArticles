// SPDX-License-Identifier: AFL-3.0
import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity >=0.8.18;

library ErrorMessageLibrary {
    using Strings for uint256;

    string public constant OwnerAction = "Only the creator performs this action!";
    string public constant ArticleNotFound = "The article was not found!";
    string public constant InstitutionFound = "Institution was found!";
    string public constant InstitutionNotFound = "Institution was not found!";
    string public constant AuthenticatorNotFound = "Authenticator was not found!";
    string public constant AuthenticatorInstitutionFound = "Authenticator institution was found!";
    string public constant AuthenticatorInstitutionNotFound = "Authenticator institution was not found!";

    function ArticleInArticlesNotFound(uint256 index) public pure returns(string memory message){
        return string.concat("The article in the index (", index.toString(),")  was not found!");
    }

    function ArticleInArticlesIsAuthenticated(uint256 index) public pure returns(string memory message){
        return string.concat("An authenticated article was found in the index (", index.toString(),")!");
    }
}
