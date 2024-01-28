// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title StringUtils
 * @notice A library for string manipulation functions in Solidity.
 * @dev This library provides functions for string manipulation, including converting strings to lowercase and checking for the presence of a word in another string.
 */
library StringUtils {

    /**
     * @dev Converts the input string to lowercase.
     * @param str The input string to be converted.
     * @return toLower The resulting lowercase string.
     * @dev This function is based on the implementation available at: https://gist.github.com/ottodevs/c43d0a8b4b891ac2da675f825b1d1dbf?permalink_comment_id=3310614#gistcomment-3310614
     */
    function ToLower(string memory str) internal pure returns (string memory toLower) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);

        for (uint i = 0; i < bStr.length; i++) {
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        
        toLower =  string(bLower);
    }

    /**
     * @dev Checks if a specific word is contained within another string.
     * @param what The word to check for.
     * @param where The string in which to check for the word.
     * @return found A boolean indicating whether the word was found in the string.
     * @dev This function is based on the implementation available at: https://github.com/HermesAteneo/solidity-repeated-word-in-string/blob/main/RepeatedWords.sol
     */
    function ContainWord(string memory what, string memory where) internal pure returns (bool found){
        bytes memory whatBytes = bytes(what);
        bytes memory whereBytes = bytes(where);

        if (whereBytes.length < whatBytes.length){ 
            found = false; 
        }
        else {
            found = false;
            for (uint i = 0; i <= whereBytes.length - whatBytes.length; i++) {
                bool flag = true;
                for (uint j = 0; j < whatBytes.length; j++)
                    if (whereBytes[i + j] != whatBytes[j]) {
                        flag = false;
                        break;
                    }
                if (flag) {
                    found = true;
                    break;
                }
            }
        }
    }
}
