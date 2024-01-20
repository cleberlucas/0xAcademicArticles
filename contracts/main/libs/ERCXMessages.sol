// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

library ERCXMessages {
    string public constant SENDER_IS_NOT_SIGNED = "sender is not signed";
    string public constant METADATA_EMPTY = "metadata is empty";
    string public constant SIGNATURE_EMPTY = "signature is empty";
    string public constant SENDER_ALREADY_SIGNED = "sender is already signed";
    string public constant OTHER_SENDER_IS_USING_THIS_SIGNATURE = "other sender is using this signature";
    string public constant METADATA_IS_ALREADY_SENDED = "metadata is already sent";
    string public constant METADATA_IS_NOT_SENDED = "metadata is not sent";
    string public constant METADATA_IS_NOT_SENDED_BY_YOU = "metadata is not sent by you";
}
