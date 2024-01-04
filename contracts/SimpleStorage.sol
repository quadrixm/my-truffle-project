// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract SimpleStorage {
  uint256 public value;
  address public owner;

  constructor() {
    owner = msg.sender;
  }

  modifier isValidValue(uint256 _value) {
    require(_value > 0, "Invalid Value");
    _;
  }

  modifier isOwner {
    require(owner == msg.sender, "Unauthorize access");
    _;
  }

  function getValue() public view returns (uint256) {
    return value;
  }

  function setValue(uint256 _value) isOwner isValidValue(_value) public {
    value = _value;
  }
}
