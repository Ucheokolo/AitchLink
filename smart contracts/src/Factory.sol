// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../src/LaunchPad.sol";
import "../src/GovernanceToken.sol";
import "../src/ILaunchpad.sol";

contract Factory {
    address factoryOwner;
    uint launchpadID;
    LaunchPad[] public launchpad;

    enum launchpadStatus {
        upcoming,
        active,
        concluded,
        canceled,
        rejected
    }

    struct launchpadPackage {
        uint LaunchPadId;
        string Name;
        address launchToken;
        address launchpadAddress;
        address LaunchPadcreator;
        address launchpadVoteToken;
        uint tokenSupply;
        launchpadStatus status;
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
        string memory voteTokenName = string.concat(_tokenName, " VoteToken");
        address creator = msg.sender; // if you dont initialiaze here, contract becomes msg.sender for external call.

        LaunchPad launchpadContract = new LaunchPad(
            _tokenAddr,
            _tokenName,
            address(this),
            factoryOwner,
            creator,
            _aitchToken
        );

        IERC20(_tokenAddr).transferFrom(
            msg.sender,
            address(launchpadContract),
            _Amount
        );
        require(
            IERC20(_tokenAddr).balanceOf(address(launchpadContract)) > 0,
            "Deposit Your Token"
        );
        GovernanceToken voteToken = new GovernanceToken(
            voteTokenName,
            "VT",
            factoryOwner,
            address(launchpadContract),
            _Amount
        );

        launchpad.push(launchpadContract);

        launchpadPackage memory launchPadDetail;
        launchPadDetail.LaunchPadId = launchpadID;
        launchPadDetail.Name = string.concat(_tokenName, " Launchpad");
        launchPadDetail.LaunchPadcreator = creator;
        launchPadDetail.launchpadAddress = address(launchpadContract);
        launchPadDetail.launchpadVoteToken = address(voteToken);
        launchPadDetail.tokenSupply = _Amount;

        launchDetails[address(launchpadContract)] = launchPadDetail;

        return (address(launchpadContract), address(voteToken));
    }

    function activateLaunchpad(address _launchpadAddress) public {
        ILaunchpad(_launchpadAddress).activateLaunchpad();
    }

    function getLauchpadDetails(
        address _launchpadAddr
    ) public view returns (launchpadPackage memory) {
        return (launchDetails[_launchpadAddr]);
    }
}
