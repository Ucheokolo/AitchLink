// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ITokens{
     function mintTokens(address _recipient, uint _amount) external;
     function approve(address spender, uint256 amount) external returns (bool);
     function transfer(address to, uint256 amount) external returns (bool);
     function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
     function balanceOf(address account) external view returns (uint256);
}