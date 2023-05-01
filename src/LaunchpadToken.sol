// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract LaunchpadToken is ERC20{
    address public owner;

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        owner = msg.sender;
    }

    function onlyOwner() view internal {
        require(msg.sender == owner, "Unauthorized Operation");
    }

    function mintTokens(address _recipient, uint _amount) public {
        onlyOwner();
        require(_recipient != address(0), "Invalid Address");
        _mint(_recipient, _amount);
    }
}