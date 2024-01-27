// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title StringUtils
 * @notice A library for string manipulation functions in Solidity.
 */
library StringUtils {
    /**
     * @dev Converts all characters in a string to lowercase.
     * @param str The input string.
     * @return A new string with all characters in lowercase.
     */
    function toLower(string memory str) public pure returns (string memory) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
                bLower[i] = bytes1(uint8(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }

    /**
    * @dev Checks if a substring is present within a base string.
    * @param str The base string.
    * @param _substr The substring to search for.
    * @return True if the substring is found, false otherwise.
    */
    function contains(string memory str, string memory _substr) public pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory valueBytes = bytes(_substr);  
        if (keccak256(bytes(str)) == keccak256(bytes(_substr))) return true;
        bool found = false;
        for(uint i = 0; i < strBytes.length - valueBytes.length; i++) {
            bool flag = true;
            for(uint j = 0; j < valueBytes.length; j++) {
                if(strBytes[i + j] != valueBytes[j]) {
                    flag = false;
                    break;
                }
            }
            if(flag) {
                found = true;
                break;
            }
        }
        return found;
    }
}
