// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import "../src/Factory.sol";
import "../src/AitchToken.sol";
import "../src/LaunchPad.sol";
import "../src/GovernanceToken.sol";
import "../src/LaunchpadToken.sol";

contract FactoryDeployer is Script {
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    Factory public factoryContract;
    AitchToken public aitch;
    LaunchPad public launchpad;
    LaunchpadToken public launchToken;
    GovernanceToken public daoToken;

    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        factoryContract = new Factory();
        // launchToken = new LaunchpadToken("Shots", "ST");

        launchpad = new LaunchPad(
            0xF89A6eD3d82A274D7E0a2C1660b058e9D38166b4,
            "Shots",
            "ahs12yty437jdjgfj",
            0x83cb6d9484D73E1c6b1059980634aAAefea646ED,
            0x9CE29Ba0c9680561e2EB21B8776a98f13786B2e3,
            0x194e43c87560861168f18C811B0E9EB64Ba18233,
            0xd8cab297543d2f5b3b9445Ac4D2cAe12369Be1BF
        );
        // aitch = new AitchToken("AitchLink", "AL");
        // daoToken = new GovernanceToken(
        //     "daoT",
        //     "DT",
        //     msg.sender,
        //     0x9CE29Ba0c9680561e2EB21B8776a98f13786B2e3,
        //     100 ether
        // );

        vm.stopBroadcast();
    }
}

// FACTORY :0xf3BB933d05f5EF0310D9E0c49ab8734864b2a23B
// AITCH: 0xd8cab297543d2f5b3b9445Ac4D2cAe12369Be1BF
// MKK voteToken: 0xC16E0373CfA7f479B333272c978C94aC3e5E45e3
// AVG Launchpad: 0x444F08C39310e7e4A9B54e6d8B9a3560a033745c
// Parent contract DaoToken: 0x543260Eb58720eA27ddfDA3b1C9AD33e0A4bbe3f (irrelevant)
