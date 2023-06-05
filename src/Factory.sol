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
        address LaunchPadcreator;
        address launchpadAddress;
        address launchpadVoteToken;
        uint voteTokenSupply;
    }

    launchpadPackage[] public launchpadInfo;

    constructor() {
        factoryOwner = msg.sender;
    }

    function CreateLaunchpad(
        address _tokenAddr,
        string memory _tokenName,
        uint _Amount,
        address _factoryOwner,
        address _creator,
        address _aitchToken
    ) public returns (address, address) {
        launchpadID = launchpadID + 1;
        string memory voteTokenName = string.concat(_tokenName, "VoteToken");
        _creator = msg.sender;

        LaunchPad launchpadName = new LaunchPad(
            _tokenAddr,
            _tokenName,
            factoryOwner,
            _creator,
            _aitchToken
        );

        GovernanceToken voteToken = new GovernanceToken(
            voteTokenName,
            "VT",
            factoryOwner,
            _creator,
            address(launchpadName),
            _Amount
        );

        IERC20(_tokenAddr).transferFrom(
            msg.sender,
            address(launchpadName),
            _Amount
        );

        launchpad.push(launchpadName);
        return (address(launchpadName), address(voteToken));
    }
}
