// SPDX-License-Identifier: MIT

import "./ExampleDataModel.sol";

pragma solidity ^0.8.23;

library ExampleCommon {

    function IsAffiliateLinked(ExampleDataModel.Affiliate storage affiliate, address affiliateAccount)
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