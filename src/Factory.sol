// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "src/LaunchPad.sol";

contract Factory {
  address factoryOwner;
   LaunchPad[] public launchpad;
   mapping(uint => address) public Lps;
   uint launchpadID;
   


   constructor(){
    factoryOwner = msg.sender;
   }

   function CreateNewToken(address _tokenAddr, string memory _tokenName, uint _Amount, address _factoryOwner) public returns(address){
    launchpadID = launchpadID + 1;
    LaunchPad launchpadName = new LaunchPad(_tokenAddr, _tokenName, _Amount, factoryOwner);
    launchpad.push(launchpadName);
    IERC20(_tokenAddr).transferFrom(msg.sender, address(launchpadName), _Amount);
    Lps[launchpadID] = address(launchpadName);
    launchpadName.proposeStart();

    return address(launchpadName);
    }
}

