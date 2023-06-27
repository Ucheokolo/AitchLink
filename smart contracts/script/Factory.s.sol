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
        launchToken = new LaunchpadToken("Faith", "FT");

        // launchpad = new LaunchPad(
        //     0xA131A46dbcEd42Dc7f08D11381d712711361CDDE,
        //     "Legacy",
        //     0x40C1A565c7516145369AEf1E6438B1d1D47464d1,
        //     0x9CE29Ba0c9680561e2EB21B8776a98f13786B2e3,
        //     0x194e43c87560861168f18C811B0E9EB64Ba18233,
        //     0xd8cab297543d2f5b3b9445Ac4D2cAe12369Be1BF
        // );
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

// FACTORY :0x464b571265002aE4914Ec813f90d04D6f1770B5C
// AITCH: 0xd8cab297543d2f5b3b9445Ac4D2cAe12369Be1BF
// MKK voteToken: 0xC16E0373CfA7f479B333272c978C94aC3e5E45e3
// MKK Launchpad: 0xc29E157239016e6fea2E9311645abbfa177101C1
// Parent contract DaoToken: 0x543260Eb58720eA27ddfDA3b1C9AD33e0A4bbe3f (irrelevant)
