// SPDX-License-Identifier: MIT
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