// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ILaunchpad{
     function launchpadName() external;
     function launchPadTokenSupply_() external;
     function launchPadStatus() external;
     function getUserInvestment() external;

     function proposeStart() external;
     function activateLaunchpad() external;
     function investAitch(uint _amount) external;
     function investEther() payable external;
     function claimTokens() external;
     function cancelLaunchpad() external;
     function suspendLaunchpad() external;

     function withdrawFunds(address _receiver, uint _amount) external;
}