// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

contract Twitter {
    mapping(address => string[]) private tweets;

    function makeTweet(string memory _tweet) public {
        if (tweets[msg.sender].length == 0) {
            tweets[msg.sender].push("INVALID INDEX");
            tweets[msg.sender].push(_tweet);
        } else {
            tweets[msg.sender].push(_tweet);
        }
    }

    function getTweet(address _owner, uint256 _i)
        public
        view
        returns (string memory)
    {
        if (_i > tweets[msg.sender].length) {
            return tweets[_owner][0];
        } else if (_i == tweets[_owner].length) {
            return tweets[_owner][0];
        } else if (_i < 1) {
            return tweets[_owner][0];
        } else {
            return tweets[_owner][_i];
        }
    }

    function viewAllTweets(address _owner) public view returns (string[] memory) {
        string[] memory userTweets = new string[](tweets[_owner].length - 1);
        for (uint256 i = 1; i < tweets[_owner].length; i++) {
            userTweets[i - 1] = tweets[_owner][i];
        }
        return userTweets;
    }


    function getTotalTweetCount(address _owner) public view returns (uint256) {
        return tweets[_owner].length - 1;
    }
}
