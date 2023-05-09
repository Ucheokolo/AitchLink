// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ILaunchpad{
     function proposeStart() external;
     function activateLaunchpad() external;
     function investLaunchpad(uint _amount) external;
     function claimTokens() external;
     function cancelLaunchpad() external;
     function suspendLaunchpad() external;
}