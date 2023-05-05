// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Factory.sol";
import "src/LaunchpadToken.sol";
import "src/ILaunchpad.sol";
// import {ITokens} from "src/iToken.sol";


contract FactoryTest is Test {
    Factory public factory;
    LaunchpadToken public token;
    address factoryOwner = mkaddr("factoryOwner");
    address me = mkaddr("me");
    address inv1 = mkaddr("inv1");
    address launchpad;


    function setUp() public {
        vm.startPrank(factoryOwner);
        token = new LaunchpadToken("Aitch", "AT");
        factory = new Factory();
        vm.stopPrank();
    }

    function testCreateNewToken() public {
        vm.prank(factoryOwner);
        token.mintTokens(me, 10 ether);
        
        vm.startPrank(me);
        token.approve(address(factory), 1 ether);
        launchpad = factory.CreateNewToken(address(token), "Aitch", 1 ether, factoryOwner);
        vm.stopPrank();
        

    }

    // function testActivateLaunchpad() public {
        
    //     testCreateNewToken();
    //     vm.prank(factoryOwner);
    //     ILaunchpad(address(launchpad)).activateLaunchpad();
    // }

    function testInvestWithEth() public {
        vm.deal(inv1, 2 ether);
        testCreateNewToken();
        // testActivateLaunchpad();
        vm.prank(inv1);
        ILaunchpad(address(launchpad)).investWithEth{value: 0.2 ether}();

    }


    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
