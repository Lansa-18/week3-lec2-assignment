// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this.");
        _;
    }
}

contract VotingSystem is Ownable {
    uint256 private candidateCount;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public hasVoted;

    function addCandidate(string calldata name) onlyOwner public  {
        // Only callable by the contract owner, adds a new candidate to the list.
        candidateCount++;
        
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
    }

    function vote(uint candidateId) public {
        // Allows an address to vote for a candidate.
        // Prevent double voting using the voters mapping.
        require(!hasVoted[msg.sender], "you have already voted");
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate ID");

        hasVoted[msg.sender] = true;

        candidates[candidateId].voteCount++;
    }

    function getCandidate(uint candidateId) public view returns (string memory name, uint voteCount) {
        // Return the candidate's details using proper memory allocation.
        require(candidateId > 0 && candidateId <= candidateCount);

        return (candidates[candidateId].name, candidates[candidateId].voteCount);
    }

    function getTotalCandidates() public view returns (uint) {
        return candidateCount;
    }
}