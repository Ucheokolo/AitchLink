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
    LaunchpadToken public Aitch;
    address factoryOwner = mkaddr("factoryOwner");
    address me = mkaddr("me");
    address inv1 = mkaddr("inv1");
    address inv2 = mkaddr("inv2");
    address inv3 = mkaddr("inv3");
    address inv4 = mkaddr("inv4");
    address inv5 = mkaddr("inv5");
    address inv6 = mkaddr("inv6");
    address launchpad;


    function setUp() public {
        vm.startPrank(factoryOwner);
        token = new LaunchpadToken("FirstPad", "FP");
        Aitch = new LaunchpadToken("Aitch", "AT");
        factory = new Factory();
        vm.stopPrank();
    }

    function testCreateLaunchpad() public {
        vm.startPrank(factoryOwner);
        token.mintTokens(me, 10 ether);
        Aitch.mintTokens(inv1, 10 ether);
        Aitch.mintTokens(inv2, 10 ether);
        Aitch.mintTokens(inv3, 10 ether);
        Aitch.mintTokens(inv4, 10 ether);
        Aitch.mintTokens(inv5, 10 ether);
        Aitch.mintTokens(inv6, 10 ether);
        vm.stopPrank();
        
        vm.startPrank(me);
        token.approve(address(factory), 1 ether);
        launchpad = factory.CreateLaunchpad(address(token), "Aitch", 1 ether, factoryOwner);
        vm.stopPrank();
        

    }

    function testActivateLaunchpad() public {
        
        testCreateLaunchpad();
        vm.prank(factoryOwner);
        ILaunchpad(address(launchpad)).activateLaunchpad();
    }

    function testInvestWithEth() public {
        vm.deal(inv1, 2 ether);
        vm.deal(inv2, 2 ether);
        vm.deal(inv3, 2 ether);
        vm.deal(inv4, 2 ether);
        vm.deal(inv5, 2 ether);
        vm.deal(inv6, 2 ether);
        testCreateLaunchpad();
        testActivateLaunchpad();
        // testActivateLaunchpad();
        vm.prank(inv1);
        ILaunchpad(address(launchpad)).investWithEth{value: 0.2 ether}();
        vm.startPrank(inv2);
        Aitch.approve(address(launchpad), 1 ether);
        ILaunchpad(address(launchpad)).investWithAitch(0.5 ether, address(Aitch));
        vm.stopPrank();

       vm.startPrank(inv3);
        Aitch.approve(address(launchpad), 1 ether);
        ILaunchpad(address(launchpad)).investWithAitch(0.5 ether, address(Aitch));
        vm.stopPrank();

        vm.prank(inv4);
        ILaunchpad(address(launchpad)).investWithEth{value: 0.2 ether}();

        console.log(address(launchpad).balance);
        // 4 000 000 000 000 000 00

    }


    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
