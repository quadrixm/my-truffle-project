// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TwitterClone {
  struct User {
    string username;
    address userAdddress;
  }

  struct Tweet {
    string content;
    uint likes;
    uint retweets;
  }

  User[] public users;
  mapping (address => Tweet) userTweet;
  mapping (string => bool) userExistMap;

  address admin;

  constructor() {
    admin = msg.sender;
  }

  modifier userNotExist(string memory _username) {
    require(!userExistMap[_username], "Username already exists");
    _;
  }

  modifier lessThan140(string memory _content) {
    require(bytes(_content).length <= 140, "Should be less then 140 characters");
    _;
  }

  function addUser(string memory _username) userNotExist(_username) public {
    users.push(User({
      username: _username,
      userAdddress: msg.sender
    }));
    userExistMap[_username] = true;
  }

  function postTweet(string memory _content) lessThan140(_content) public {
    userTweet[msg.sender] = Tweet({
      content: _content,
      likes: 0,
      retweets: 0
    });
  }

  function likeTweet(address _user) public {
    userTweet[_user].likes += 1;
  }

  function retweet(address _user) public {
    userTweet[_user].retweets += 1;
    userTweet[msg.sender] = userTweet[_user];
  }

  function getUsers() public view returns (User[] memory) {
    return users;
  }

  function getUserTweet(address _user) public view returns (Tweet memory) {
    return userTweet[_user];
  }
}
