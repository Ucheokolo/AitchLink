// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

enum state {
    processing,
    active,
    concluded,
    canceled,
    suspended
}

struct launchpadPackage {
    uint LaunchPadId;
    string Name;
    address LaunchPadcreator;
    address launchpadAddress;
    address launchpadVoteToken;
    uint voteTokenSupply;
    state launchpadStatus;
}

interface ILaunchpad {
    function getLauchpadDetails(
        address _launchpadAddr
    ) external returns (launchpadPackage memory);
}
