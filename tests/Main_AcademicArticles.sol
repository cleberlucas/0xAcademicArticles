// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "remix_tests.sol"; 
import "remix_accounts.sol";
import "../AcademicArticles/Main.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract MainTestSuite {

    Main mainContract;

    /// 'beforeAll' runs before all other tests
    function beforeAll() public {
        mainContract = new Main(); // Instantiate your contract
    }

    function testRegisterInstitution() public {
        // Test the RegisterInstitution function
        address[] memory institutionAccounts = new address[](1);
        institutionAccounts[0] = TestsAccounts.getAccount(1);

        // #sender: account-1
        // #value: 1
        (bool success, ) = address(mainContract).call{value: 1}(abi.encodeWithSignature("RegisterInstitution(address[])", institutionAccounts));
        Assert.equal(success, true, "RegisterInstitution should succeed");
    }

    function testAuthenticateArticle() public {
        // Test the AuthenticateArticle function
        bytes32[] memory articleIds = new bytes32[](1);
        articleIds[0] = keccak256("SampleArticle");

        // #sender: account-2
        // #value: 1
        (bool success, ) = address(mainContract).call{value: 1}(abi.encodeWithSignature("AuthenticateArticle(bytes32[])", articleIds));
        Assert.equal(success, true, "AuthenticateArticle should succeed");
    }

    function testArticleContent() public {
        // Test the ArticleContent function
        bytes32[] memory articleIds = new bytes32[](1);
        articleIds[0] = keccak256("SampleArticle");

        DelimitationLibrary.Article[] memory articleContents = mainContract.ArticleContent(articleIds);
        Assert.equal(articleContents.length, 1, "ArticleContent should return one article");
    }

    function testUnbindAuthenticator() public {
        // Test the UnbindAuthenticator function
        address[] memory authenticatorAccounts = new address[](1);
        authenticatorAccounts[0] = TestsAccounts.getAccount(3);

        // #sender: account-3
        // #value: 1
        (bool success, ) = address(mainContract).call{value: 1}(abi.encodeWithSignature("UnbindAuthenticator(address[])", authenticatorAccounts));
        Assert.equal(success, true, "UnbindAuthenticator should succeed");
    }

}
