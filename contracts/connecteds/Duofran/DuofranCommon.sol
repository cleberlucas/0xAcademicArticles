// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./DuofranDataModel.sol";

library DuofranCommon {
    function IsAffiliateLinked(DuofranDataModel.Affiliate storage affiliate, address affiliateAccount)
    internal view 
    returns (bool isAffiliateLinked) { 
        for (uint256 i = 0; i < affiliate.accounts.length; i++) {
            if (affiliate.accounts[i] == affiliateAccount) {
                isAffiliateLinked = true;       
                break;
            }
        }
    }
}