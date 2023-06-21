// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../src/LaunchPad.sol";
import "../src/GovernanceToken.sol";

import "../src/ILaunchpad.sol";

contract Factory {
    address factoryOwner;
    uint launchpadID;
    LaunchPad[] public launchpad;

    enum launchpadCondition {
        upcoming,
        active,
        concluded,
        canceled,
        rejected
    }

    struct launchpadSummary {
        uint LaunchPadId;
        string Name;
        address launchToken;
        address launchpadAddress;
        address LaunchPadcreator;
        address launchpadVoteToken;
        uint tokenSupply;
        launchpadCondition status;
    }

    mapping(address => launchpadSummary) public launchDetails;
    mapping(address => mapping(address => bool)) public isOwner;

    constructor() {
        factoryOwner = msg.sender;
    }

    function CreateLaunchpad(
        address _tokenAddr,
        string memory _tokenName,
        uint _Amount,
        address _aitchToken
    ) public returns (address, address) {
        launchpadID = launchpadID + 1;
        string memory voteTokenName = string.concat(_tokenName, " VoteToken");
        address creator = msg.sender; // if you dont initialiaze here, contract becomes msg.sender for external call.

        LaunchPad launchpadContract = new LaunchPad(
            _tokenAddr,
            _tokenName,
            address(this),
            factoryOwner,
            creator,
            _aitchToken
        );
        isOwner[address(launchpadContract)][msg.sender] = true;

        IERC20(_tokenAddr).transferFrom(
            msg.sender,
            address(launchpadContract),
            _Amount
        );
        require(
            IERC20(_tokenAddr).balanceOf(address(launchpadContract)) > 0,
            "Deposit Your Token"
        );
        GovernanceToken voteToken = new GovernanceToken(
            voteTokenName,
            "VT",
            factoryOwner,
            address(launchpadContract),
            _Amount
        );

        launchpad.push(launchpadContract);

        launchpadSummary memory launchPadDetail;
        launchPadDetail.LaunchPadId = launchpadID;
        launchPadDetail.Name = string.concat(_tokenName, " Launchpad");
        launchPadDetail.launchToken = _tokenAddr;
        launchPadDetail.LaunchPadcreator = creator;
        launchPadDetail.launchpadAddress = address(launchpadContract);
        launchPadDetail.launchpadVoteToken = address(voteToken);
        launchPadDetail.tokenSupply = _Amount;

        launchDetails[address(launchpadContract)] = launchPadDetail;

        return (address(launchpadContract), address(voteToken));
    }

    function activateLaunchpad(
        address _launchpadAddress,
        uint _duration
    ) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        launchpadCondition currentState = launchDetails[_launchpadAddress]
            .status;
        require(currentState != launchpadCondition.rejected, "Failed Review");
        launchpadSummary memory launchPadDetail;
        launchPadDetail.status = launchpadCondition.active;
        launchPadDetail = launchDetails[_launchpadAddress];

        ILaunchpad(_launchpadAddress).activateLaunchpad(_duration);
    }

    function setConclude(address _launchpadAddress) public {
        launchpadSummary memory launchPadDetail;
        address callerPermit = _launchpadAddress;
        require(msg.sender == callerPermit, "Unauthorized Operation");
        launchPadDetail.status = launchpadCondition.concluded;
        launchDetails[_launchpadAddress] = launchPadDetail;
    }

    function suspendLaunchpad(address _launchpadAddress) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        ILaunchpad(_launchpadAddress).suspendLaunchpad();
    }

    function cancelLaunchpad(address _launchpadAddress) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        launchpadSummary memory launchPadDetail;
        launchPadDetail.status = launchpadCondition.canceled;
        launchPadDetail = launchDetails[_launchpadAddress];
        ILaunchpad(_launchpadAddress).cancelLaunchpad();
    }

    function setReject(address _launchpadAddress) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        launchpadSummary memory _launchPadDetail;
        _launchPadDetail.status = launchpadCondition.rejected;
        launchDetails[_launchpadAddress] = _launchPadDetail;
    }

    function getLaunchpadSize() public view returns (uint) {
        return (launchpad.length);
    }

    function getLauchpadDetails(
        address _launchpadAddr
    ) public view returns (launchpadSummary memory) {
        return (launchDetails[_launchpadAddr]);
    }
}
