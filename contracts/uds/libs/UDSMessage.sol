// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title UDSMessage
 * @dev Library containing constant strings for Unified Data Storage (UDS) error messages.
 * @notice These strings are meant to provide clear and standardized error messages for different 
    scenarios and rules specified.
 */
library UDSMessage {
    string public constant METADATA_ALREADY_SENT = "Metadata has already been sent, try updating them";
    string public constant METADATA_EMPTY = "Metadata entry is empty, add a non-empty entry";
    string public constant METADATA_NOT_SENT_TO_DELETE = "No metadata to be deleted";
    string public constant METADATA_NOT_SENT_TO_UPDATE = "No metadata to be updated, try sending first";
    string public constant NEW_SENDER_ALREADY_SIGNED = "New sender already signed";
    string public constant NEW_SENDER_CANNOT_BE_YOU = "New sender cannot be you, change to a different sender that is not you";
    string public constant NEW_SENDER_NOT_CONTRACT = "New sender is not a contract, change to a valid contract account";
    string public constant NEW_SENDER_NO_SAME_SIGNATURE = "New sender does not have the same signature as you, verify if the signature of the new sender is the same as yours";
    string public constant NEW_SENDER_NO_SIGNATURE = "New sender does not have a signature, verify if the signature method is implemented in the new sender";
    string public constant ONLY_CONTRACT = "Only contracts can execute this action, try executing from a contract";
    string public constant ONLY_SIGNED_EXEC = "Only signed senders can execute this action, try signing first";
    string public constant OTHER_SENDER_USING_SIGNATURE = "Another signed sender is using this signature, change to a valid signature not being used by another sender";
    string public constant SAME_METADATA_ALREADY_SENT = "The same metadata already exists, try changing the input data";
    string public constant SENDER_ALREADY_SIGNED = "You are already signed";
    string public constant SENDER_NO_SIGNATURE = "You do not have a signature, try implementing the signature method";
    string public constant SIGNATURE_EMPTY = "Your signature cannot be empty";
}
