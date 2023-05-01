// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";


contract DaoContract is ERC20{
    address private admin;

    //This to be gotten from launchpadContract
    uint totalParticipants = 100;
    uint VoteTokenSupply = 400;

    enum VoteOptions{
        For, 
        Against, 
        Abstain
    }

    enum proposalStatus{
        active,
        delay,
        completed,
        failed
    }

    struct ProposalDetails {
        uint proposalId;
        string votePurpose;
        address voteToken;
        uint voteTokenSupply;
        uint votePeriod;
        uint delayVote;
        uint quoromNumber;
        uint totalVotesCast;
        uint NumberOfMilestone;
        proposalStatus status;

    }

    uint proposalID;
    uint[] public allProposals;
    mapping(uint => uint) public proposalTracker;

    // params proposalID. returns proposal detail
    mapping(uint => ProposalDetails) public proposalDetail;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        admin = msg.sender;
    }

    function onlyAdmin() view internal {
        require(msg.sender == admin,"Unauthorized Operation");
        
    }

    function setQuorum(uint _percentage) view internal returns(uint){
        uint quorum = _percentage * totalParticipants/ 100;
        return quorum;
    }

    function setVotingPower() internal {
        
    }

    function getProposalDetails(uint _proposalId) view public returns(ProposalDetails memory){
        ProposalDetails memory pDetails = proposalDetail[_proposalId];
        return(pDetails);
    }

    function createProposal(uint _percentage, uint _numberOfMilestone, string memory _purpose) public{
        onlyAdmin();
        uint setQuorumValue = setQuorum(_percentage);
        proposalID = proposalID + 1;

        ProposalDetails memory _details;
        _details.proposalId = proposalID;
        _details.votePurpose = _purpose;
        _details.voteToken = 0xf8e81D47203A594245E36C48e151709F0C19fBe8;
        _details.voteTokenSupply = VoteTokenSupply;
        _details.votePeriod = block.timestamp +2 days;
        _details.delayVote = 1 days;
        _details.quoromNumber = setQuorumValue;
        _details.NumberOfMilestone = _numberOfMilestone;
        _details.status = proposalStatus.active;

        proposalDetail[proposalID] = _details;

        // push proposalID to array to keep record of all IDs
        // get proposalID position in aray by subtracting array length by 1 for every push.
        allProposals.push(proposalID);
        uint idPosition = allProposals.length - 1;
        proposalTracker[proposalID] = idPosition;
    }

    function castVote(uint _proposalId) public {

    }


    

    

}