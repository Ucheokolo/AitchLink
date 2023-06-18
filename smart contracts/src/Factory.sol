// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../src/LaunchPad.sol";
import "../src/GovernanceToken.sol";

contract Factory {
    address factoryOwner;
    uint launchpadID;
    LaunchPad[] public launchpad;
    uint[] public launchpadIDs;

    enum state {
        processing,
        active,
        concluded,
        canceled,
        suspended
    }

    struct launchpadPackage {
        uint LaunchPadId;
        string Name;
        address LaunchPadcreator;
        address launchpadAddress;
        address launchpadVoteToken;
        uint voteTokenSupply;
        state launchpadStatus;
    }

    mapping(address => launchpadPackage) public launchDetails;

    constructor() {
        factoryOwner = msg.sender;
    }

    function CreateLaunchpad(
        address _tokenAddr,
        string memory _tokenName,
        uint _Amount,
        address _aitchToken
    ) public returns (address, address) {
        launchpadID = launchpadID + 1;
        string memory voteTokenName = string.concat(_tokenName, "VoteToken");
        address creator = msg.sender;

        LaunchPad launchpadName = new LaunchPad(
            _tokenAddr,
            _tokenName,
            factoryOwner,
            creator,
            _aitchToken
        );

        IERC20(_tokenAddr).transferFrom(
            msg.sender,
            address(launchpadName),
            _Amount
        );
        require(
            IERC20(_tokenAddr).balanceOf(address(launchpadName)) > 0,
            "Deposit Your Token"
        );
        GovernanceToken voteToken = new GovernanceToken(
            voteTokenName,
            "VT",
            factoryOwner,
            address(launchpadName),
            _Amount
        );

        launchpad.push(launchpadName);
        launchpadPackage memory launchPadDetail;
        launchPadDetail.LaunchPadId = launchpadID;
        launchPadDetail.Name = string.concat(_tokenName, " Launchpad");
        launchPadDetail.LaunchPadcreator = creator;
        launchPadDetail.launchpadAddress = address(launchpadName);
        launchPadDetail.launchpadVoteToken = address(voteToken);
        launchPadDetail.voteTokenSupply = _Amount;

        launchDetails[address(launchpadName)] = launchPadDetail;

        return (address(launchpadName), address(voteToken));
    }

    function getLauchpadDetails(
        address _launchpadAddr
    ) public view returns (launchpadPackage memory) {
        return (launchDetails[_launchpadAddr]);
    }
}
