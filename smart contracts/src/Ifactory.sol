// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// enum launchpadCondition {
//     upcoming,
//     active,
//     concluded,
//     canceled,
//     rejected
// }

// struct launchpadSummary {
//     uint LaunchPadId;
//     string Name;
//     address launchToken;
//     address launchpadAddress;
//     address LaunchPadcreator;
//     address launchpadVoteToken;
//     uint tokenSupply;
//     launchpadCondition status;
// }

interface IFactory {
    function setConclude(address _launchpadAddress) external;
}
