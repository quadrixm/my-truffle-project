// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Ballot {
  struct Voter {
    uint weight;
    bool voted;
    address delegate;
    uint vote;
  }

  struct Proposal {
    bytes32 name;
    uint voteCount;
  }

  address public chairPerson = msg.sender;

  mapping (address => Voter) voters;

  Proposal[] public proposals;

  constructor(bytes32[] memory proposalNames) {
    voters[chairPerson].weight = 1;

    for (uint i = 0; i < proposalNames.length; i++) {
      proposals.push(Proposal({
        name: proposalNames[i],
        voteCount: 0
      }));
    }
  }

  function giveRightToVote(address[] memory _voters)  external {
    require(msg.sender == chairPerson, "Only chairperson can give right to vote.");
    for (uint i = 0; i < _voters.length; i++) {
      address voter = _voters[i];
      require(!voters[voter].voted, "The voter already voted.");
      require(voters[voter].weight == 0, "Right already given.");
      voters[voter].weight = 1;
    }
  }

  function delegate(address to)  external {
    // We are using storage since it will store the refrence since we are assigning from storage to storage.
    Voter storage sender = voters[msg.sender];
    require(sender.weight != 0, "You have no right to vote");
    require(!sender.voted, "You already voted.");
    require(to != msg.sender, "You can delegate yourself.");
    // Check if the to address has not delegated it back to the user.
    while (voters[to].delegate != address(0)) {
      to = voters[to].delegate;
      require(to != msg.sender, "Found loop in delegation.");
    }

    Voter storage delegate_ = voters[to];

    require(delegate_.weight > 0, "The user you are delegating don't have right to vote.");

    // since sender is a reference it will update the voters map.
    sender.voted = true;
    sender.delegate = to;

    if (delegate_.voted) {
      // if the delegate has voted update the vote directly to voted proposal
      proposals[delegate_.vote].voteCount += sender.weight;
    } else {
      // else update the weight
      delegate_.weight += sender.weight;
    }
  }

  function vote(uint proposal) external {
    Voter storage sender = voters[msg.sender];
    require(sender.weight != 0, "You have no right to vote");
    require(!sender.voted, "You have already voted");

    sender.voted = true;
    sender.vote = proposal;

    proposals[proposal].voteCount += sender.weight;
  }

  function winningProposal() public view returns (uint winningProposal_, bool winningIsTie_) {
    uint winningVoteCount = 0;
    for (uint p = 0; p < proposals.length; p++) {
      if (proposals[p].voteCount == winningVoteCount) {
        winningVoteCount = proposals[p].voteCount;
        winningIsTie_ = true;
      } else if (proposals[p].voteCount > winningVoteCount) {
        winningVoteCount = proposals[p].voteCount;
        winningProposal_ = p;
        winningIsTie_ = false;
      }
    }
  }

  function winnerName()  external view returns (bytes32 winnerName_) {
    (uint winningProposal_, bool winningIsTie_) = winningProposal();
    if (winningIsTie_) {
      winnerName_ = "Tie";
    } else {
      winnerName_ = proposals[winningProposal_].name;
    }
  }
}
