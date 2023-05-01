// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "src/LaunchpadToken.sol";

contract Factory {
   LaunchpadToken[] public launchPad;

   function CreateNewToken(string memory _name, string memory _symbol) public returns(address){
     LaunchpadToken launchToken = new LaunchpadToken(_name, _symbol);
     launchPad.push(launchToken);
     return address(launchToken);
   }
}

