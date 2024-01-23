// SPDX-License-Identifier: MIT

/*
    *** Flattened code
    Original code in: https://github.com/cleberlucas/SmartContracts/tree/develop/AIO
*/

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

library AIOMessage {
    string public constant NOT_EXEC_DIRECT_AIO = "This action cannot be executed directly from AIO";
    string public constant METADATA_ALREADY_SENT = "Metadata is already sent";
    string public constant METADATA_EMPTY = "Metadata is empty";
    string public constant METADATA_NOT_SENT = "Metadata is not sent";
    string public constant METADATA_NOT_SENT_BY_YOU = "Metadata is not sent by you";
    string public constant NEW_SENDER_CANNOT_BE_YOU = "New sender cannot be you";
    string public constant NEW_SENDER_NO_SAME_SIGNATURE = "New sender does not have the same signature as you";
    string public constant NEW_SENDER_NO_SIGNATURE = "New sender does not have a signature";
    string public constant ONLY_SIGNED_EXEC = "Only sender signed can execute this action";
    string public constant OTHER_SENDER_USING_SIGNATURE = "Other sender signed is using this signature";
    string public constant SENDER_ALREADY_SIGNED = "Sender is already signed";
    string public constant SENDER_NO_SIGNATURE = "Sender does not have a signature";
    string public constant SIGNATURE_EMPTY = "Your signature cannot be empty";
}
// File: AIO/contracts/libs/AIOStorageModel.sol


pragma solidity ^0.8.23;

library AIOStorageModel {
    struct Data {   
        mapping(string signature => bytes32[]) tokens;
        mapping(bytes32 token => string) signature;
        mapping(bytes32 token => bytes) metadata;
    }

    struct Interconnection {  
        address[] senders;
        mapping(address sender => string) signature;
        mapping(string signature => address) sender;
    }
}
// File: AIO/contracts/AIOStorage.sol


pragma solidity ^0.8.23;


abstract contract AIOStorage {
    AIOStorageModel.Data internal _data;
    AIOStorageModel.Interconnection internal _interconnection;
}
// File: AIO/contracts/interfaces/IAIOSignature.sol


pragma solidity ^0.8.23;

interface IAIOSignature {
    function SIGNATURE() external pure returns (string memory signature);
}
// File: AIO/contracts/AIORules.sol


pragma solidity ^0.8.23;





abstract contract AIORules {
    modifier InitializeRule(AIOStorageModel.Interconnection storage _interconnection) {
        address sender = msg.sender;

        require(sender != tx.origin, AIOMessage.NOT_EXEC_DIRECT_AIO);
        try IAIOSignature(sender).SIGNATURE() {
            require(bytes(IAIOSignature(sender).SIGNATURE()).length > 0, AIOMessage.SIGNATURE_EMPTY);
            require(bytes(_interconnection.signature[sender]).length == 0, AIOMessage.SENDER_ALREADY_SIGNED);
            require(_interconnection.sender[IAIOSignature(sender).SIGNATURE()] == address(0), AIOMessage.OTHER_SENDER_USING_SIGNATURE);
        }   catch {
                revert(AIOMessage.SENDER_NO_SIGNATURE);
        } 
        _;
    }

    modifier TransferSignatureRule(AIOStorageModel.Interconnection storage _interconnection, address newSender) {
        address oldSender = msg.sender;

        require(oldSender != tx.origin, AIOMessage.NOT_EXEC_DIRECT_AIO);
        require(bytes(_interconnection.signature[oldSender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(newSender != oldSender, AIOMessage.NEW_SENDER_CANNOT_BE_YOU); 
        try IAIOSignature(newSender).SIGNATURE() {
            require(Strings.equal(IAIOSignature(oldSender).SIGNATURE(), IAIOSignature(newSender).SIGNATURE()), AIOMessage.NEW_SENDER_NO_SAME_SIGNATURE);
        }   catch {
                revert(AIOMessage.NEW_SENDER_NO_SIGNATURE);
        }    
        _;
    }

    modifier SendMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Data storage _data, bytes calldata metadata) {
        address sender = msg.sender;

        require(address(this) != sender, AIOMessage.NOT_EXEC_DIRECT_AIO);
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(metadata.length > 0, AIOMessage.METADATA_EMPTY);
        require(bytes(_data.signature[keccak256(metadata)]).length == 0, AIOMessage.METADATA_ALREADY_SENT);
        _;
    }

    modifier CleanMetaDataRule(AIOStorageModel.Interconnection storage _interconnection, AIOStorageModel.Data storage _data, bytes32 token) {
        address sender = msg.sender;
        
        require(address(this) != sender, AIOMessage.NOT_EXEC_DIRECT_AIO);
        require(bytes(_interconnection.signature[sender]).length > 0, AIOMessage.ONLY_SIGNED_EXEC);
        require(bytes(_data.signature[token]).length > 0, AIOMessage.METADATA_NOT_SENT);
        require(Strings.equal((_data.signature[token]), _interconnection.signature[sender]), AIOMessage.METADATA_NOT_SENT_BY_YOU);
        _;
    }
}
// File: AIO/contracts/interfaces/IAIOInterconnection.sol


pragma solidity ^0.8.23;

interface IAIOInterconnection {
    function Initialize() external payable;
    function TransferSignature(address newSender) external payable;
}
// File: AIO/contracts/libs/AIOLog.sol


pragma solidity ^0.8.23;

library AIOLog {
    event MetaDataSended(bytes32 indexed token);
    event MetaDataCleaned(bytes32 indexed token);
    event SenderSigned(address indexed sender);
    event SignatureTransferred(address indexed newSender);
}
// File: AIO/contracts/AIOInterconnection.sol


pragma solidity ^0.8.23;






contract AIOInterconnection is IAIOInterconnection, AIOStorage, AIORules {
    function Initialize()
    external payable
    InitializeRule(_interconnection) {
        address sender = msg.sender;
        string memory signature = IAIOSignature(sender).SIGNATURE();

        _interconnection.senders.push(sender); 
        _interconnection.sender[signature] = sender;
        _interconnection.signature[sender] = signature;

        emit AIOLog.SenderSigned(sender);
    }

    function TransferSignature(address newSender)
    external payable
    TransferSignatureRule(_interconnection, newSender) {
        address oldSender = msg.sender;

        for (uint256 i = 0; i < _interconnection.senders.length; i++) {
            if (_interconnection.senders[i] == oldSender) {
                string memory signature = IAIOSignature(oldSender).SIGNATURE();

                _interconnection.senders[i] = _interconnection.senders[_interconnection.senders.length - 1];
                _interconnection.senders.pop();

                _interconnection.signature[oldSender] = "";

                _interconnection.senders.push(newSender); 
                _interconnection.sender[signature] = newSender;
                _interconnection.signature[newSender] = signature;

                emit AIOLog.SignatureTransferred(newSender);
                return;
            }
        }
    }
}
// File: AIO/contracts/interfaces/IAIOSearch.sol


pragma solidity ^0.8.23;

interface IAIOSearch {
    function Tokens(string calldata signature) external view returns (bytes32[] memory tokens);
    function Signature(bytes32 token) external view returns (string memory signature);
    function MetaData(bytes32 token) external view returns (bytes memory metadata);
    function Senders() external view returns (address[] memory senders);
    function Signature(address sender) external view returns (string memory signature);
    function Sender(string calldata signature) external view returns (address sender);
}
// File: AIO/contracts/AIOSearch.sol


pragma solidity ^0.8.23;



abstract contract AIOSearch is IAIOSearch, AIOStorage {
    function Tokens(string calldata signature) 
    external view 
    returns (bytes32[] memory tokens) {
        tokens = _data.tokens[signature];
    }

    function Signature(bytes32 token) 
    external view 
    returns (string memory signature) {
        signature = _data.signature[token];
    }

    function MetaData(bytes32 token) 
    external view 
    returns (bytes memory metadata) {
        metadata = _data.metadata[token];
    }

    function Senders()
    external view
    returns (address[] memory senders) {
        senders = _interconnection.senders;
    }

    function Signature(address sender)
    external view
    returns (string memory signature) {
        signature = _interconnection.signature[sender];
    }

    function Sender(string calldata signature)
    external view
    returns (address sender) {
        sender = _interconnection.sender[signature];
    }
}
// File: AIO/contracts/interfaces/IAIOInteract.sol


pragma solidity ^0.8.23;

interface IAIOInteract {
    function SendMetaData(bytes calldata metadata) external payable;
    function CleanMetaData(bytes32 token) external payable;
}
// File: AIO/contracts/AIOInteract.sol


pragma solidity ^0.8.23;





contract AIOInteract is IAIOInteract, AIOStorage, AIORules {
    function SendMetaData(bytes calldata metadata)
    external payable
    SendMetaDataRule(_interconnection, _data, metadata)  {
        string memory signature = IAIOSignature(msg.sender).SIGNATURE();
        bytes32 token = keccak256(metadata);

        _data.tokens[signature].push(token);
        _data.signature[token] = signature;
        _data.metadata[token] = metadata;

        emit AIOLog.MetaDataSended(token);
    }

    function CleanMetaData(bytes32 token)
    external payable
    CleanMetaDataRule(_interconnection, _data, token) {
        string memory signature = IAIOSignature(msg.sender).SIGNATURE();

        for (uint256 i = 0; i < _data.tokens[signature].length; i++) {
            if (_data.tokens[signature][i] == token) {
                _data.tokens[signature][i] = _data.tokens[signature][_data.tokens[signature].length - 1];
                _data.tokens[signature].pop();

                _data.signature[token] = "";
                _data.metadata[token] = new bytes(0);

                emit AIOLog.MetaDataCleaned(token);
                return;
            }
        }
    }
}
// File: AIO/contracts/AIO.sol


pragma solidity ^0.8.23;






/*
    AIO - All in One
    Created by Cleber Lucas
    Proposal: stores data from different contracts in just one central contract, facilitating extensions of external contracts
*/
contract AIO is AIOInterconnection, AIOInteract, AIOSearch {}