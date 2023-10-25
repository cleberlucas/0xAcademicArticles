// SPDX-License-Identifier: AFL-3.0
import "../Globals/DepositingGlobal.sol";

pragma solidity >=0.8.19;

abstract contract ModifierUtil is DepositingGlobal {
    function RequireHelpper(
        bool _require,
        string memory messageError
    ) public pure {
        require(_require, messageError);
    }

    function IsArticlePostedHelpper(
        DepositingLibrary.ArticleKey memory articleKey
    ) public view returns (bool registered) {
        for (uint256 i = 0; i < _key.articles.length; i++)
            if (
                _key.articles[i].poster == articleKey.poster &&
                _key.articles[i].articleType == articleKey.articleType &&
                _key.articles[i].sequence == articleKey.sequence
            ) return true;

        return false;
    }
}
