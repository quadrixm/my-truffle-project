// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ReceiverPays {
  address owner = msg.sender;

  mapping (uint256 => bool) usedNonces;

  constructor() payable {
  }

  function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) external {
    require(!usedNonces[nonce]);

    // this recreates the message that was signed on the client
    bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));

    require(recoverSigner(message, signature) == owner);

    payable(msg.sender).transfer(amount);
  }
  
  /// destroy the contract and reclaim the leftover funds.
  function shutdown() external {
    require (msg.sender == owner);
    selfdestruct(payable(msg.sender));
  }

  // Spliting the signature into different parts
  function splitSignature(bytes memory sig) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
    require(sig.length == 65);

    assembly {
      // geting first 32 bytes, after the prefix
      r := mload(add(sig, 32))
      // second 32 bytes
      s := mload(add(sig, 64))
      // final byte (first byte of the next 32 bytes).
      v := byte(0, mload(add(sig, 96)))
    }
  }

  function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
    (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);
    return ecrecover(message, v, r, s);
  }

  function prefixed(bytes32 hash) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
  }
}
