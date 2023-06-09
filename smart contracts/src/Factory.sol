// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "src/LaunchPad.sol";
import "src/GovernanceToken.sol";

contract Factory {
    address factoryOwner;
    uint launchpadID;
    LaunchPad[] public launchpad;

    struct launchpadPackage {
        uint LaunchPadId;
        string Name;
        address LaunchPadcreator;
        address launchpadAddress;
        address launchpadVoteToken;
        uint voteTokenSupply;
    }

    launchpadPackage[] public launchpadInfo;
    mapping(uint => launchpadPackage) public launchDetails;

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
        string memory voteTokenName = string.concat(_tokenName, "VoteToken");
        address creator = msg.sender;

        LaunchPad launchpadName = new LaunchPad(
            _tokenAddr,
            _tokenName,
            factoryOwner,
            creator,
            _aitchToken
        );

        IERC20(_tokenAddr).transferFrom(
            msg.sender,
            address(launchpadName),
            _Amount
        );
        require(
            IERC20(_tokenAddr).balanceOf(address(launchpadName)) > 0,
            "Deposit Your Token"
        );
        GovernanceToken voteToken = new GovernanceToken(
            voteTokenName,
            "VT",
            factoryOwner,
            address(launchpadName),
            _Amount
        );

        launchpad.push(launchpadName);
        launchpadPackage memory launchPadDetails;
        launchPadDetails.LaunchPadId = launchpadID;
        launchPadDetails.Name = string.concat(_tokenName, " Launchpad");
        launchPadDetails.LaunchPadcreator = creator;
        launchPadDetails.launchpadAddress = address(launchpadName);
        launchPadDetails.launchpadVoteToken = address(voteToken);
        launchPadDetails.voteTokenSupply = _Amount;

        launchDetails[launchpadID] = launchPadDetails;
        return (address(launchpadName), address(voteToken));
    }

    function getLauchpadDetails(
        uint _launchpadId
    ) public view returns (launchpadPackage memory) {
        return (launchDetails[_launchpadId]);
    }
}
