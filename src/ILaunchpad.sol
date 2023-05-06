// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ILaunchpad{
     function proposeStart() external;
     function activateLaunchpad() external;
     function investWithEth() external payable;
     function investWithAitch(uint _amount, address _aitchToken) external;
     function claimTokens() external;
     function cancelLaunchpad() external;
     function suspendLaunchpad() external;
}