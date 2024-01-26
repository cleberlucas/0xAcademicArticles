
// File: AIO/contracts/interfaces/IAIOSearch.sol


pragma solidity ^0.8.23;

/**
 * @title IAIOSearch
 * @notice Interface for searching and retrieving information related to the AIO (All In One) system.
 */
interface IAIOSearch {
    /**
     * @dev Get the unique identifiers (IDs) associated with a given signature.
     * @param signature The signature for which IDs are to be retrieved.
     * @return ids An array of unique identifiers (IDs) associated with the given signature.
     */
    function Ids(string calldata signature) external view returns (bytes32[] memory ids);

    /**
     * @dev Get the signature associated with a specific ID.
     * @param id The unique identifier (ID) for which the associated signature is to be retrieved.
     * @return signature The signature associated with the given ID.
     */
    function Signature(bytes32 id) external view returns (string memory signature);

    /**
     * @dev Get the metadata associated with a specific ID.
     * @param id The unique identifier (ID) for which the associated metadata is to be retrieved.
     * @return metadata The metadata associated with the given ID.
     */
    function MetaData(bytes32 id) external view returns (bytes memory metadata);

    /**
     * @dev Get the list of all senders in the AIO system.
     * @return senders An array containing all sender addresses in the AIO system.
     */
    function Senders() external view returns (address[] memory senders);

    /**
     * @dev Get the signature associated with a specific sender address.
     * @param sender The address for which the associated signature is to be retrieved.
     * @return signature The signature associated with the given sender address.
     */
    function Signature(address sender) external view returns (string memory signature);

    /**
     * @dev Get the sender address associated with a specific signature.
     * @param signature The signature for which the associated sender address is to be retrieved.
     * @return sender The sender address associated with the given signature.
     */
    function Sender(string calldata signature) external view returns (address sender);
}
// File: AIO/contracts/interfaces/IAIOInteract.sol


pragma solidity ^0.8.23;

/**
 * @title IAIOInteract
 * @notice Interface defining functions for sending and cleaning metadata in the AIO (All In One) system.
 */
interface IAIOInteract {
    /**
     * @dev Sends metadata in the AIO system.
     * @param metadata The metadata to be sent.
     */
    function SendMetaData(bytes calldata metadata) external;

    /**
     * @dev Cleans metadata associated with a specific ID in the AIO system.
     * @param id The ID of the metadata to be cleaned.
     */
    function CleanMetaData(bytes32 id) external;
}
// File: @openzeppelin/contracts/utils/math/SignedMath.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/SignedMath.sol)

pragma solidity ^0.8.20;

/**
 * @dev Standard signed math utilities missing in the Solidity language.
 */
library SignedMath {
    /**
     * @dev Returns the largest of two signed numbers.
     */
    function max(int256 a, int256 b) internal pure returns (int256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two signed numbers.
     */
    function min(int256 a, int256 b) internal pure returns (int256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two signed numbers without overflow.
     * The result is rounded towards zero.
     */
    function average(int256 a, int256 b) internal pure returns (int256) {
        // Formula from the book "Hacker's Delight"
        int256 x = (a & b) + ((a ^ b) >> 1);
        return x + (int256(uint256(x) >> 255) & (a ^ b));
    }

    /**
     * @dev Returns the absolute unsigned value of a signed value.
     */
    function abs(int256 n) internal pure returns (uint256) {
        unchecked {
            // must be unchecked in order to support `n = type(int256).min`
            return uint256(n >= 0 ? n : -n);
        }
    }
}

// File: @openzeppelin/contracts/utils/math/Math.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/Math.sol)

pragma solidity ^0.8.20;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Muldiv operation overflow.
     */
    error MathOverflowedMulDiv();

    enum Rounding {
        Floor, // Toward negative infinity
        Ceil, // Toward positive infinity
        Trunc, // Toward zero
        Expand // Away from zero
    }

    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            // Guarantee the same behavior as in a regular Solidity division.
            return a / b;
        }

        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a == 0 ? 0 : (a - 1) / b + 1;
    }

    /**
     * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2^256 + prod0.
            uint256 prod0 = x * y; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2^256. Also prevents denominator == 0.
            if (denominator <= prod1) {
                revert MathOverflowedMulDiv();
            }

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator.
            // Always >= 1. See https://cs.stackexchange.com/q/138556/92363.

            uint256 twos = denominator & (0 - denominator);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
            // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv = 1 mod 2^4.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2^8
            inverse *= 2 - denominator * inverse; // inverse mod 2^16
            inverse *= 2 - denominator * inverse; // inverse mod 2^32
            inverse *= 2 - denominator * inverse; // inverse mod 2^64
            inverse *= 2 - denominator * inverse; // inverse mod 2^128
            inverse *= 2 - denominator * inverse; // inverse mod 2^256

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
            // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        uint256 result = mulDiv(x, y, denominator);
        if (unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0) {
            result += 1;
        }
        return result;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
        //
        // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
        // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
        //
        // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
        // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
        // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
        //
        // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
        uint256 result = 1 << (log2(a) >> 1);

        // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
        // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
        // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
        // into the expected uint128 result.
        unchecked {
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            result = (result + a / result) >> 1;
            return min(result, a / result);
        }
    }

    /**
     * @notice Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + (unsignedRoundsUp(rounding) && result * result < a ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 128;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 64;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 32;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 16;
            }
            if (value >> 8 > 0) {
                value >>= 8;
                result += 8;
            }
            if (value >> 4 > 0) {
                value >>= 4;
                result += 4;
            }
            if (value >> 2 > 0) {
                value >>= 2;
                result += 2;
            }
            if (value >> 1 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + (unsignedRoundsUp(rounding) && 1 << result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + (unsignedRoundsUp(rounding) && 10 ** result < value ? 1 : 0);
        }
    }

    /**
     * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >> 128 > 0) {
                value >>= 128;
                result += 16;
            }
            if (value >> 64 > 0) {
                value >>= 64;
                result += 8;
            }
            if (value >> 32 > 0) {
                value >>= 32;
                result += 4;
            }
            if (value >> 16 > 0) {
                value >>= 16;
                result += 2;
            }
            if (value >> 8 > 0) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + (unsignedRoundsUp(rounding) && 1 << (result << 3) < value ? 1 : 0);
        }
    }

    /**
     * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
    function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
        return uint8(rounding) % 2 == 1;
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol


// OpenZeppelin Contracts (last updated v5.0.0) (utils/Strings.sol)

pragma solidity ^0.8.20;



/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant HEX_DIGITS = "0123456789abcdef";
    uint8 private constant ADDRESS_LENGTH = 20;

    /**
     * @dev The `value` string doesn't fit in the specified `length`.
     */
    error StringsInsufficientHexLength(uint256 value, uint256 length);

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = Math.log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), HEX_DIGITS))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    /**
     * @dev Converts a `int256` to its ASCII `string` decimal representation.
     */
    function toStringSigned(int256 value) internal pure returns (string memory) {
        return string.concat(value < 0 ? "-" : "", toString(SignedMath.abs(value)));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        unchecked {
            return toHexString(value, Math.log256(value) + 1);
        }
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        uint256 localValue = value;
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = HEX_DIGITS[localValue & 0xf];
            localValue >>= 4;
        }
        if (localValue != 0) {
            revert StringsInsufficientHexLength(value, length);
        }
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal
     * representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), ADDRESS_LENGTH);
    }

    /**
     * @dev Returns true if the two strings are equal.
     */
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

// File: AIO/contracts/libs/AIOMessage.sol


pragma solidity ^0.8.23;

/**
 * @title AIOMessage
 * @notice Library for defining standardized error messages in the AIO (All In One) system.
 */
library AIOMessage {
    // Error message indicating that metadata is already sent
    string public constant METADATA_ALREADY_SENT = "Metadata is already sent";

    // Error message indicating that metadata is empty
    string public constant METADATA_EMPTY = "Metadata is empty";

    // Error message indicating that metadata is not sent
    string public constant METADATA_NOT_SENT = "Metadata is not sent";

    // Error message indicating that metadata is not sent by the sender
    string public constant METADATA_NOT_SENT_BY_YOU = "Metadata is not sent by you";

    // Error message indicating that the new sender cannot be the current sender
    string public constant NEW_SENDER_CANNOT_BE_YOU = "New sender cannot be you";

    // Error message indicating that the new sender is not a contract
    string public constant NEW_SENDER_NOT_CONTRACT = "New sender is not a contract";

    // Error message indicating that the new sender does not have the same signature
    string public constant NEW_SENDER_NO_SAME_SIGNATURE = "New sender does not have the same signature as you";

    // Error message indicating that the new sender does not have a signature
    string public constant NEW_SENDER_NO_SIGNATURE = "New sender does not have a signature";

    // Error message indicating that only contracts can execute a specific action
    string public constant ONLY_CONTRACT = "Only contracts can execute this action";

    // Error message indicating that only the signed sender can execute a specific action
    string public constant ONLY_SIGNED_EXEC = "Only sender signed can execute this action";

    // Error message indicating that another sender is already using the same signature
    string public constant OTHER_SENDER_USING_SIGNATURE = "Other sender signed is using this signature";

    // Error message indicating that the sender is already signed
    string public constant SENDER_ALREADY_SIGNED = "Sender is already signed";

    // Error message indicating that the sender does not have a signature
    string public constant SENDER_NO_SIGNATURE = "Sender does not have a signature";

    // Error message indicating that the signature cannot be empty
    string public constant SIGNATURE_EMPTY = "Your signature cannot be empty";
}
// File: AIO/contracts/libs/AIOStorageModel.sol


pragma solidity ^0.8.23;

/**
 * @title AIOStorageModel
 * @notice Library defining the storage model for the AIO (All In One) system.
 */
library AIOStorageModel {
    // Struct defining the token-related storage
    struct Token {   
        // Mapping from a signature to an array of associated token IDs
        mapping(string signature => bytes32[]) ids;

        // Mapping from a token ID to its associated signature
        mapping(bytes32 id => string) signature;

        // Mapping from a token ID to its associated metadata
        mapping(bytes32 id => bytes) metadata;
    }

    // Struct defining the interconnection-related storage
    struct Interconnection {  
        // Array containing all registered senders
        address[] senders;

        // Mapping from a sender's address to their associated signature
        mapping(address sender => string) signature;

        // Mapping from a signature to the associated sender's address
        mapping(string signature => address) sender;
    }
}
// File: AIO/contracts/AIOStorage.sol


pragma solidity ^0.8.23;

/**
 * @title AIOStorage
 * @notice This abstract contract provides internal storage instances for the AIO system.
 */

// Import the AIOStorageModel library for defining the storage structure


abstract contract AIOStorage {
    // Internal storage instance for token-related data
    AIOStorageModel.Token internal _token;
    // Internal storage instance for interconnection-related data
    AIOStorageModel.Interconnection internal _interconnection;
}
// File: AIO/contracts/AIOSearch.sol


pragma solidity ^0.8.23;

/**
 * @title AIOSearch
 * @notice This abstract contract provides functions for searching and retrieving data from the AIOStorage contract.
 */
 
// Import the interface for AIO search functionality

// Import the AIOStorage contract for accessing stored data


abstract contract AIOSearch is IAIOSearch, AIOStorage {
    /**
     * @dev Retrieves the IDs associated with a given signature.
     * @param signature The signature to query.
     * @return ids An array of IDs associated with the provided signature.
     */
    function Ids(string calldata signature) 
    external view 
    returns (bytes32[] memory ids) {
        ids = _token.ids[signature];
    }

    /**
     * @dev Retrieves the signature associated with a given ID.
     * @param id The ID to query.
     * @return signature The signature associated with the provided ID.
     */
    function Signature(bytes32 id) 
    external view 
    returns (string memory signature) {
        signature = _token.signature[id];
    }

    /**
     * @dev Retrieves the metadata associated with a given ID.
     * @param id The ID to query.
     * @return metadata The metadata associated with the provided ID.
     */
    function MetaData(bytes32 id) 
    external view 
    returns (bytes memory metadata) {
        metadata = _token.metadata[id];
    }

    /**
     * @dev Retrieves the array of all senders registered in the AIO system.
     * @return senders An array containing all registered senders.
     */
    function Senders()
    external view
    returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    /**
     * @dev Retrieves the signature associated with a given sender's address.
     * @param sender The sender's address to query.
     * @return signature The signature associated with the provided sender's address.
     */
    function Signature(address sender)
    external view
    returns (string memory signature) {
        signature = _interconnection.signature[sender];
    }

    /**
     * @dev Retrieves the sender's address associated with a given signature.
     * @param signature The signature to query.
     * @return sender The sender's address associated with the provided signature.
     */
    function Sender(string calldata signature)
    external view
    returns (address sender) {
        sender = _interconnection.sender[signature];
    }
}
// File: AIO/contracts/interfaces/IAIOSignature.sol


pragma solidity ^0.8.23;

/**
 * @title IAIOSignature
 * @notice This interface defines a function to retrieve a fixed signature associated with the sender.
 * @dev This interface should be inherited by the sender contract.
 */
interface IAIOSignature {
    /**
     * @dev Returns a fixed signature for the sender that the AIO contract will read later to use as
     * the signature for its initialization and transfer.
     * @return signature A string representing the fixed signature of the sender.
     */
    function SIGNATURE() external pure returns (string memory signature);
}
// File: AIO/contracts/AIORules.sol


pragma solidity ^0.8.23;

/**
 * @title AIORules
 * @notice This abstract contract provides modifiers for initializing, transferring signatures, and managing metadata in the AIO system.
 */
 
// Import the messaging library for AIORules

// Import the storage model for AIORules

// Import the interface for AIO signature functionality

// Import the OpenZeppelin Strings utility library


abstract contract AIORules {
    /**
     * @dev Modifier for initializing the sender's signature.
     * @param _interconnection The storage instance for interconnection-related data.
     */
    modifier InitializeRule(AIOStorageModel.Interconnection storage _interconnection) {
        address sender = msg.sender;

        // Check if the sender is a contract
        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        try IAIOSignature(sender).SIGNATURE() {
            // Check if the sender has a non-empty signature
            require(bytes(IAIOSignature(sender).SIGNATURE()).length > 0, AIOMessage.SIGNATURE_EMPTY);

            // Check if the sender is not already signed
            require(bytes(_interconnection.signature[sender]).length == 0, AIOMessage.SENDER_ALREADY_SIGNED);

            // Check if the signature is not already used by another sender
            require(_interconnection.sender[IAIOSignature(sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_USING_SIGNATURE);
        } catch {
            // Revert if the sender has no signature
            revert(AIOMessage.SENDER_NO_SIGNATURE);
        }

        _;
    }

    /**
     * @dev Modifier for transferring the signature from the old sender to the new sender.
     * @param _interconnection The storage instance for interconnection-related data.
     * @param newSender The address of the new sender.
     */
    modifier TransferSignatureRule(AIOStorageModel.Interconnection storage _interconnection, address newSender) {
        address oldSender = msg.sender;

        // Check if the old sender is a contract
        require(oldSender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        // Check if the new sender is a contract
        require(newSender.code.length > 0, AIOMessage.NEW_SENDER_NOT_CONTRACT);

        // Check if the old sender is signed
        require(bytes(_interconnection.signature[oldSender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);

        // Check if the new sender is not the same as the old sender
        require(newSender != oldSender, AIOMessage.NEW_SENDER_CANNOT_BE_YOU);

        try IAIOSignature(newSender).SIGNATURE() {
            // Check if the signatures of old and new senders are the same
            require(Strings.equal(IAIOSignature(oldSender).SIGNATURE(), IAIOSignature(newSender).SIGNATURE()), AIOMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        } catch {
            // Revert if the new sender has no signature
            revert(AIOMessage.NEW_SENDER_NO_SIGNATURE);
        }

        _;
    }

    /**
     * @dev Modifier for sending metadata.
     * @param _interconnection The storage instance for interconnection-related data.
     * @param _token The storage instance for token-related data.
     * @param metadata The metadata to be sent.
     */
    modifier SendMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes calldata metadata) {
        address sender = msg.sender;

        // Check if the sender is a contract
        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        // Check if the sender is signed
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata is not empty
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);

        // Check if the metadata is not already sent
        require(bytes(_token.signature[keccak256(metadata)]).length == 0, AIOMessage.METADATA_ALREADY_SENT);

        _;
    }

    /**
     * @dev Modifier for cleaning metadata.
     * @param _interconnection The storage instance for interconnection-related data.
     * @param _token The storage instance for token-related data.
     * @param id The ID of the metadata to be cleaned.
     */
    modifier CleanMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Token storage _token, bytes32 id) {
        address sender = msg.sender;

        // Check if the sender is a contract
        require(sender.code.length > 0, AIOMessage.ONLY_CONTRACT);

        // Check if the sender is signed
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);

        // Check if the metadata with the given ID is sent
        require(bytes(_token.signature[id]).length > 0, AIOMessage.METADATA_NOT_SENT);

        // Check if the metadata is sent by the sender
        require(Strings.equal((_token.signature[id]), _interconnection.signature[sender]), AIOMessage.METADATA_NOT_SENT_BY_YOU);

        _;
    }
}
// File: AIO/contracts/interfaces/IAIOInterconnection.sol


pragma solidity ^0.8.23;

/**
 * @title IAIOInterconnection
 * @notice Interface defining functions for initializing and transferring signatures in the AIO (All In One) system.
 */
interface IAIOInterconnection {
    /**
     * @dev Initializes the sender by signing them up in the AIO system.
     */
    function Initialize() external;

    /**
     * @dev Transfers the signature from the current sender to a new sender.
     * @param newSender The address of the new sender.
     */
    function TransferSignature(address newSender) external;
}
// File: AIO/contracts/libs/AIOLog.sol


pragma solidity ^0.8.23;

/**
 * @title AIOLog
 * @notice Library for logging events related to the AIO (All In One) system.
 */
library AIOLog {
    /**
     * @dev Emitted when metadata is successfully sent.
     * @param id The unique identifier of the metadata.
     */
    event MetadataSended(bytes32 indexed id);

    /**
     * @dev Emitted when metadata is successfully cleaned.
     * @param id The unique identifier of the cleaned metadata.
     */
    event MetadataCleaned(bytes32 indexed id);

    /**
     * @dev Emitted when a new sender is successfully signed.
     * @param sender The address of the newly signed sender.
     */
    event SenderSigned(address indexed sender);

    /**
     * @dev Emitted when a signature is successfully transferred to a new sender.
     * @param newSender The address of the new sender who now holds the signature.
     */
    event SignatureTransferred(address indexed newSender);
}
// File: AIO/contracts/AIOInteract.sol


pragma solidity ^0.8.23;

/**
 * @title AIOInteract
 * @notice This contract handles the interaction with metadata in the AIO system.
 */

// Import the logging library for AIOInteract

// Import the interface for AIO interaction functionality

// Import the AIOStorage contract for accessing stored data

// Import the rules and modifiers for AIO functionality


contract AIOInteract is IAIOInteract, AIOStorage, AIORules {
    /**
     * @dev Sends metadata to the AIO contract.
     * @param metadata The metadata to be sent.
     */
    function SendMetaData(bytes calldata metadata)
    external
    SendMetaDataRule(_interconnection, _token, metadata) {
        // Retrieve the sender's signature from the interconnection mapping
        string storage signature = _interconnection.signature[msg.sender];
        // Generate an ID using the metadata and store it in the token mappings
        bytes32 id = keccak256(metadata);

        _token.ids[signature].push(id);
        _token.signature[id] = signature;
        _token.metadata[id] = metadata;

        // Emit an event indicating that metadata has been successfully sent
        emit AIOLog.MetadataSended(id);
    }

    /**
     * @dev Cleans metadata based on its ID.
     * @param id The ID of the metadata to be cleaned.
     */
    function CleanMetaData(bytes32 id)
    external
    CleanMetaDataRule(_interconnection, _token, id) {
        // Retrieve the sender's signature from the interconnection mapping
        string storage signature = _interconnection.signature[msg.sender];

        // Iterate through the array of IDs associated with the sender's signature
        for (uint256 i = 0; i < _token.ids[signature].length; i++) {            
            if (_token.ids[signature][i] == id) {
                // Find the matching ID and remove it from the array
                _token.ids[signature][i] = _token.ids[signature][_token.ids[signature].length - 1];
                _token.ids[signature].pop();

                // Clear the corresponding entries in the token mappings
                _token.signature[id] = "";
                _token.metadata[id] = new bytes(0);

                // Emit an event indicating that metadata has been successfully cleaned
                emit AIOLog.MetadataCleaned(id);
                break;
            }
        }
    }
}
// File: AIO/contracts/AIOInterconnection.sol


pragma solidity ^0.8.23;

/**
 * @title AIOInterconnection
 * @notice This contract handles the initialization and transfer of signatures in the AIO system.
 */

// Import the logging library for AIOInterconnection

// Import the interface for AIO interconnection functionality

// Import the interface for AIO signature functionality

// Import the AIOStorage contract for accessing stored data

// Import the rules and modifiers for AIO functionality


contract AIOInterconnection is IAIOInterconnection, AIOStorage, AIORules {
    /**
     * @dev Initializes the sender by signing with a unique signature.
     */
    function Initialize()
    external
    InitializeRule(_interconnection) {
        // Get the sender's address and retrieve the associated fixed signature
        address sender = msg.sender;
        string memory signature = IAIOSignature(sender).SIGNATURE();

        // Update interconnection mappings with sender information
        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        // Emit an event indicating that the sender has been signed
        emit AIOLog.SenderSigned(sender);
    }

    /**
     * @dev Transfers the signature from the old sender to the new sender.
     * @param newSender The address of the new sender.
     */
    function TransferSignature(address newSender)
    external
    TransferSignatureRule(_interconnection, newSender) {
        // Get the old sender's address
        address oldSender = msg.sender;

        // Iterate through the array of senders to find the old sender
        for (uint256 i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                string memory signature = IAIOSignature(oldSender).SIGNATURE();

                // Find the matching old sender and remove it from the array
                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();

                // Clear the old sender's signature in the mapping
                _interconnection.signature[oldSender] = "";

                // Update the interconnection mappings with the new sender information
                _interconnection.senders.push(newSender); 
                _interconnection.sender[signature] = newSender;
                _interconnection.signature[newSender] = signature;

                // Emit an event indicating that the signature has been transferred
                emit AIOLog.SignatureTransferred(newSender);
                break;
            }
        }
    }
}
// File: AIO/contracts/AIO.sol


pragma solidity ^0.8.23;

/**
 * @title AIO (All In One) Contract
 * @author Cleber Lucas
 * @notice This contract serves as the central point in the AIO system with data traceability.
 * - Combines functionalities from AIOInterconnection, AIOInteract, and AIOSearch contracts.
 * - Acts as the central component providing a unified interface for interaction, interconnection, data retrieval, and traceability within the AIO system.
 * - Designed to facilitate continuous communication and collaboration among various components in the AIO ecosystem.
 * - Users can interact, transfer signatures, send and search metadata, and perform other actions through this unified contract.
 *
 */

// Import the contract providing functionality for interconnecting senders

// Import the contract providing functionality for sender interactions

// Import the contract providing functionality for searching and retrieving data


contract AIO is AIOInterconnection, AIOInteract, AIOSearch {}