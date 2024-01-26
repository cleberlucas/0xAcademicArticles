// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library AIOMessage {
    string public constant METADATA_ALREADY_SENT = "Metadata is already sent";
    string public constant METADATA_EMPTY = "Metadata is empty";
    string public constant METADATA_NOT_SENT = "Metadata is not sent";
    string public constant METADATA_NOT_SENT_BY_YOU = "Metadata is not sent by you";
    string public constant NEW_SENDER_CANNOT_BE_YOU = "New sender cannot be you";
    string public constant NEW_SENDER_NOT_CONTRACT = "New sender is not a contract";
    string public constant NEW_SENDER_NO_SAME_SIGNATURE = "New sender does not have the same signature as you";
    string public constant NEW_SENDER_NO_SIGNATURE = "New sender does not have a signature";
    string public constant ONLY_CONTRACT = "Only contracts can execute this action";
    string public constant ONLY_SIGNED_EXEC = "Only sender signed can execute this action";
    string public constant OTHER_SENDER_USING_SIGNATURE = "Other sender signed is using this signature";
    string public constant SENDER_ALREADY_SIGNED = "Sender is already signed";
    string public constant SENDER_NO_SIGNATURE = "Sender does not have a signature";
    string public constant SIGNATURE_EMPTY = "Your signature cannot be empty";
}