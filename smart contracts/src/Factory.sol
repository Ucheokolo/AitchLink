// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../src/LaunchPad.sol";
import "../src/GovernanceToken.sol";

import "../src/ILaunchpad.sol";

contract Factory {
    address factoryOwner;
    uint launchpadID;
    LaunchPad[] public launchpad;
    mapping(address => bool) public existingCreator;
    mapping(address => bool) public existingLaunchToken;

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
        string tokenCid;
        address launchpadAddress;
        address LaunchPadcreator;
        address launchpadVoteToken;
        uint tokenSupply;
        launchpadCondition status;
    }

    mapping(address => launchpadSummary) public launchDetails;
    mapping(address => mapping(address => bool)) public isOwner;
    launchpadSummary[] public allLaunchpad;

    constructor() {
        factoryOwner = msg.sender;
    }

    function CreateLaunchpad(
        address _tokenAddr,
        string memory _tokenName,
        string memory _cid,
        uint _Amount,
        address _aitchToken
    ) public returns (address, address) {
        // require(existingCreator[msg.sender] == false, "Creator Exists");
        // require(existingLaunchToken[_tokenAddr] == false, "Launchpad Exists");
        launchpadID = launchpadID + 1;
        string memory voteTokenName = string.concat(_tokenName, " VoteToken");
        address creator = msg.sender; // if you dont initialiaze here, contract becomes msg.sender for external call.

        LaunchPad launchpadContract = new LaunchPad(
            _tokenAddr,
            _tokenName,
            _cid,
            address(this),
            factoryOwner,
            creator,
            _aitchToken
        );
        existingCreator[msg.sender] = true;
        existingLaunchToken[_tokenAddr] = true;
        // isOwner[address(launchpadContract)][msg.sender] = true;

        IERC20(_tokenAddr).transferFrom(
            msg.sender,
            address(launchpadContract),
            _Amount
        );
        // require(
        //     IERC20(_tokenAddr).balanceOf(address(launchpadContract)) > 0,
        //     "Deposit Your Token"
        // );

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
        launchPadDetail.tokenCid = _cid;
        launchPadDetail.LaunchPadcreator = creator;
        launchPadDetail.launchpadAddress = address(launchpadContract);
        launchPadDetail.launchpadVoteToken = address(voteToken);
        launchPadDetail.tokenSupply = _Amount;

        launchDetails[address(launchpadContract)] = launchPadDetail;
        allLaunchpad.push(launchDetails[address(launchpadContract)]);

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
        launchDetails[_launchpadAddress].status = launchpadCondition.active;

        ILaunchpad(_launchpadAddress).activateLaunchpad(_duration);
    }

    function setConclude(address _launchpadAddress) public {
        address callerPermit = _launchpadAddress;
        require(msg.sender == callerPermit, "Unauthorized Operation");
        launchDetails[_launchpadAddress].status = launchpadCondition.concluded;
    }

    function suspendLaunchpad(address _launchpadAddress) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        ILaunchpad(_launchpadAddress).suspendLaunchpad();
    }

    function cancelLaunchpad(address _launchpadAddress) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        launchDetails[_launchpadAddress].status = launchpadCondition.canceled;
        ILaunchpad(_launchpadAddress).cancelLaunchpad();
    }

    function setReject(address _launchpadAddress) public {
        require(msg.sender == factoryOwner, "Unauthorized Operation");
        launchDetails[_launchpadAddress].status = launchpadCondition.rejected;
    }

    function getLaunchpadSize() public view returns (uint) {
        return (launchpad.length);
    }

    function getAllAddresses() public view returns (LaunchPad[] memory) {
        return (launchpad);
    }

    function getAllLaunchpad() public view returns (launchpadSummary[] memory) {
        return (allLaunchpad);
    }

    function getLauchpadDetails(
        address _launchpadAddr
    ) public view returns (launchpadSummary memory) {
        return (launchDetails[_launchpadAddr]);
    }

    function getOwner() public view returns (address) {
        return factoryOwner;
    }

    function getLaunchpadCreator(
        address _launchpadAddr
    ) public view returns (address) {
        address projectCreator = launchDetails[_launchpadAddr].LaunchPadcreator;
        return (projectCreator);
    }
}
