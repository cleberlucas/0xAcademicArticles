// SPDX-License-Identifier: AFL-3.0
import "../Shareds/DepositingShared.sol";

pragma solidity >=0.8.19;

contract ModifierHelpper is DepositingShared  {

    function RequireHelpper(bool _require, string memory messageError) public pure {
        require(_require, messageError);
    }

    function IsArticleRegisteredHelpper(
        RepositoryLibrary.ArticleKey memory articleKey
    ) public view returns (bool registered){
        for (uint256 i = 0; i < keyShared.articles.length; i++) 
            if (
                keyShared.articles[i].poster == articleKey.poster &&
                keyShared.articles[i].articleType == articleKey.articleType &&
                keyShared.articles[i].sequence == articleKey.sequence
            ) 
             return true;

        return false;
    }
}
