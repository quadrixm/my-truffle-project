// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TwitterClone {
  struct User {
    bytes32 username;
    address userAdddress;
  }

  struct Tweet {
    bytes32 ipfsHash;
    uint likes;
    uint retweets;
  }

  User[] public users;
  mapping (address => Tweet) userTweet;
  mapping (bytes32 => bool) usernameExistMap;
  mapping (address => bool) userExistMap;

  address admin;

  constructor() {
    admin = msg.sender;
  }

  event TweetPosted();
  event TweetLiked();
  event TweetRetweeted();

  modifier usernameNotExist(bytes32 _username) {
    require(!usernameExistMap[_username], "Username already exists");
    _;
  }

  modifier userExist() {
    require(userExistMap[msg.sender], "User not exists");
    _;
  }

  function addUser(bytes32 _username) usernameNotExist(_username) public {
    users.push(User({
      username: _username,
      userAdddress: msg.sender
    }));
    usernameExistMap[_username] = true;
    userExistMap[msg.sender] = true;
  }

  function postTweet(bytes32 _content) userExist public {
    userTweet[msg.sender] = Tweet({
      ipfsHash: _content,
      likes: 0,
      retweets: 0
    });
    emit TweetPosted();
  }

  function likeTweet(address _user) public {
    userTweet[_user].likes += 1;
    emit TweetLiked();
  }

  function retweet(address _user) public {
    userTweet[_user].retweets += 1;
    userTweet[msg.sender] = userTweet[_user];
    emit TweetRetweeted();
  }

  function getUsers() public view returns (User[] memory) {
    return users;
  }

  function getUserTweet(address _user) public view returns (Tweet memory) {
    return userTweet[_user];
  }
}
