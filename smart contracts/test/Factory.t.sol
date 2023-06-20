// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Factory.sol";
import "../src/LaunchpadToken.sol";
import "../src/ILaunchpad.sol";

import {ITokens} from "../src/iToken.sol";

contract FactoryTest is Test {
    Factory public factory;
    LaunchpadToken public token;
    LaunchpadToken public Aitch;
    // uint256 mainnetFork;
    // string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");

    // address public Aitch 0xF3164AAcb3Ed9EEa02bed546EFbC693BDf130d36;
    address factoryOwner = mkaddr("factoryOwner");
    address me = mkaddr("me");
    address inv1 = mkaddr("inv1");
    address inv2 = mkaddr("inv2");
    address inv3 = mkaddr("inv3");
    address inv4 = mkaddr("inv4");
    address inv5 = mkaddr("inv5");
    address inv6 = mkaddr("inv6");
    address launchpad;
    address voteToken;

    function setUp() public {
        // mainnetFork = vm.createFork(MAINNET_RPC_URL);
        vm.startPrank(factoryOwner);
        uint256 forkId = vm.createFork(
            "https://eth-mainnet.g.alchemy.com/v2/Z3fhnS-rtbXvUck31_58ooWa-ApUzHbo",
            17292955
        );
        vm.selectFork(forkId);
        token = new LaunchpadToken("Legion", "LG");
        Aitch = new LaunchpadToken("Aitch", "AT");
        factory = new Factory();
        vm.stopPrank();
    }

    function testCreateLaunchpad() public {
        // vm.selectFork(mainnetFork);
        vm.startPrank(factoryOwner);
        token.mintTokens(me, 50 ether);
        Aitch.mintTokens(inv1, 20 ether);
        Aitch.mintTokens(inv2, 20 ether);
        Aitch.mintTokens(inv3, 20 ether);
        Aitch.mintTokens(inv4, 20 ether);
        Aitch.mintTokens(inv5, 20 ether);
        Aitch.mintTokens(inv6, 20 ether);
        vm.stopPrank();
        vm.startPrank(me);
        token.approve(address(factory), 45 ether);
        (launchpad, voteToken) = factory.CreateLaunchpad(
            address(token),
            "Legion",
            40 ether,
            address(Aitch)
        );
        factory.getLauchpadDetails(1);
        ILaunchpad(address(launchpad)).launchPadStatus();
        IERC20(address(voteToken)).balanceOf(address(launchpad));
        vm.stopPrank();
    }

    function testActivateLaunchpad() public {
        testCreateLaunchpad();
        vm.prank(factoryOwner);
        ILaunchpad(address(launchpad)).activateLaunchpad();
    }

    function testInvestLaunchpad() public returns (uint) {
        vm.deal(inv1, 2 ether);
        vm.deal(inv2, 2 ether);
        vm.deal(inv3, 2 ether);
        vm.deal(inv4, 2 ether);
        vm.deal(inv5, 2 ether);
        vm.deal(inv6, 2 ether);
        testCreateLaunchpad();
        testActivateLaunchpad();
        vm.startPrank(inv1);
        Aitch.approve(address(launchpad), 8 ether);
        ILaunchpad(address(launchpad)).investAitch(7.91 ether);
        vm.stopPrank();

        vm.startPrank(inv2);
        Aitch.approve(address(launchpad), 4 ether);
        ILaunchpad(address(launchpad)).investAitch(3.7 ether);
        vm.stopPrank();

        vm.startPrank(inv3);
        Aitch.approve(address(launchpad), 6 ether);
        ILaunchpad(address(launchpad)).investAitch(5 ether);
        vm.stopPrank();

        vm.startPrank(inv4);
        Aitch.approve(address(launchpad), 6 ether);
        ILaunchpad(address(launchpad)).investAitch(4.7 ether);
        vm.stopPrank();

        vm.startPrank(inv4);
        ILaunchpad(address(launchpad)).investEther{value: 0.2 ether}();
        vm.stopPrank();

        vm.startPrank(inv3);
        ILaunchpad(address(launchpad)).investEther{value: 1.3 ether}();
        vm.stopPrank();

        vm.startPrank(inv2);
        ILaunchpad(address(launchpad)).investEther{value: 1.8 ether}();
        vm.stopPrank();

        uint aitchBal = IERC20(Aitch).balanceOf(address(launchpad));

        vm.prank(factoryOwner);
        // ILaunchpad(address(launchpad)).cancelLaunchpad();

        ILaunchpad(address(launchpad)).launchPadStatus();

        return (aitchBal);

        // https://eth-mainnet.g.alchemy.com/v2/Z3fhnS-rtbXvUck31_58ooWa-ApUzHbo
    }

    function testClaimToken() public returns (uint) {
        testCreateLaunchpad();
        testActivateLaunchpad();
        testInvestLaunchpad();
        vm.warp(block.timestamp + 5 days);
        ILaunchpad(address(launchpad)).launchPadStatus();
        vm.prank(inv3);
        ILaunchpad(address(launchpad)).claimTokens();

        vm.prank(inv1);
        ILaunchpad(address(launchpad)).claimTokens();

        vm.prank(inv2);
        ILaunchpad(address(launchpad)).claimTokens();

        vm.prank(inv4);
        ILaunchpad(address(launchpad)).claimTokens();

        uint remaining = IERC20(token).balanceOf(address(launchpad));

        ILaunchpad(address(launchpad)).launchpadName();

        vm.startPrank(factoryOwner);
        ILaunchpad(address(launchpad)).withdrawCommission();
        ILaunchpad(address(launchpad)).payCreator(me, 2 ether);

        ILaunchpad(address(launchpad)).launchpadInfo();
        ILaunchpad(address(launchpad)).launchpadName();

        return remaining;
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }
}
