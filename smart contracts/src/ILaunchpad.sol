// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ILaunchpad {
    function launchpadInfo() external;

    function launchpadName() external;

    function launchPadTokenSupply_() external;

    function launchPadStatus() external;

    function getUserInvestment() external;

    function hasClaimed(address _investor) external;

    function activateLaunchpad(uint _duration) external;

    function investAitch(uint _amount) external;

    function investEther() external payable;

    function claimTokens() external;

    function cancelLaunchpad() external;

    function suspendLaunchpad() external;

    function payCreator(address _receiver, uint _amount) external;

    function withdrawCommission() external;
}
